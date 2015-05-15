//
//  MyMerchantViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/30.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "MyMerchantViewController.h"
#import "CreateMerchantController.h"
#import "RefreshView.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "MerchantModel.h"
#import "MerchantDetailController.h"
#import "MultipleDeleteCell.h"

typedef enum {
    MerchantSingleDeleteTag = 10,
    MerchantMultiDeleteTag,
}MerchantDeleteTag;

@interface MyMerchantViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL isMultiDelete;

/***************上下拉刷新**********/
@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;

@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property (nonatomic, assign) int page;
/**********************************/

@property (nonatomic, strong) NSMutableArray *merchantItems;

@property (nonatomic, strong) NSMutableDictionary *selectedItem; //多选的行

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NSIndexPath *deletePath;

@end

@implementation MyMerchantViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的商户";
    _merchantItems = [[NSMutableArray alloc] init];
    _selectedItem = [[NSMutableDictionary alloc] init];
    [self initAndLayoutUI];
    [self firstLoadData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshMerchantList:)
                                                 name:RefreshMerchantListNotification
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
    [self initNavigationBarView];
    [self initContentView];
}

- (void)initNavigationBarView {
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(0, 0, 24, 24);
    [deleteButton setBackgroundImage:kImageName(@"merchant1.png") forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(multiDelete:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 24, 24);
    [addButton setBackgroundImage:kImageName(@"merchant2.png") forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addMerchant:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置间距
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    spaceItem.width = -5;
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithCustomView:deleteButton];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:spaceItem,deleteItem,addItem, nil];
}

- (void)initContentView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self setHeaderAndFooterView];
    [self.view addSubview:_tableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    _topRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, -80, self.view.bounds.size.width, 80)];
    _topRefreshView.direction = PullFromTop;
    _topRefreshView.delegate = self;
    [_tableView addSubview:_topRefreshView];
    
    _bottomRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    _bottomRefreshView.direction = PullFromBottom;
    _bottomRefreshView.delegate = self;
    _bottomRefreshView.hidden = YES;
    [_tableView addSubview:_bottomRefreshView];
    
    [self initBottomView];
}

- (void)initBottomView {
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 49 - 64, kScreenWidth, 49)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kLineHeight)];
    firstLine.backgroundColor = kColor(170, 169, 169, 1);
    [_bottomView addSubview:firstLine];
    UIButton *readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    readBtn.frame = CGRectMake(10, 7, 60, 36);
    readBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [readBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [readBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [readBtn setTitle:@"取消" forState:UIControlStateNormal];
    [readBtn addTarget:self action:@selector(cancelDelete:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:readBtn];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(kScreenWidth - 60, 7, 60, 36);
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteMerchant:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:deleteBtn];
}

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footerView;
}

- (void)setIsMultiDelete:(BOOL)isMultiDelete {
    _isMultiDelete = isMultiDelete;
    [_tableView setEditing:_isMultiDelete animated:YES];
    if (_isMultiDelete) {
        [self.view addSubview:_bottomView];
    }
    else {
        [_selectedItem removeAllObjects];
        [_bottomView removeFromSuperview];
    }
}

#pragma mark - Request

- (void)firstLoadData {
    _page = 1;
    [self downloadDataWithPage:_page isMore:NO];
}

- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getMerchantListWithToken:delegate.token userID:delegate.userID page:page rows:kPageSize * 2 finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            NSLog(@"!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    if (!isMore) {
                        [_merchantItems removeAllObjects];
                    }
                    id list = [[object objectForKey:@"result"] objectForKey:@"list"];
                    if ([list isKindOfClass:[NSArray class]] && [list count] > 0) {
                        //有数据
                        self.page++;
                        [hud hide:YES];
                    }
                    else {
                        //无数据
                        hud.labelText = @"没有更多数据了...";
                    }
                    [self parseMerchantDataWithDictionary:object];
                }
            }
            else {
                //返回错误数据
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
        if (!isMore) {
            [self refreshViewFinishedLoadingWithDirection:PullFromTop];
        }
        else {
            [self refreshViewFinishedLoadingWithDirection:PullFromBottom];
        }
    }];
}

//删除单个商户
- (void)deleteSingleMerchantWithIndexPath:(NSIndexPath *)indexPath {
    MerchantModel *model = [_merchantItems objectAtIndex:indexPath.row];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface deleteMerchantWithToken:delegate.token merchantIDs:[NSArray arrayWithObject:[NSNumber numberWithInt:[model.merchantID intValue]]] finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    hud.labelText = @"删除成功";
                    [_merchantItems removeObject:model];
                    [_tableView beginUpdates];
                    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [_tableView endUpdates];
                }
            }
            else {
                //返回错误数据
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
}

//商户多删
- (void)deleteMultiMerchant {
    NSArray *merchantsID = [self merchantIDForEditRows];
    if ([merchantsID count] <= 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择需要删除的商户";
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface deleteMerchantWithToken:delegate.token merchantIDs:merchantsID finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    hud.labelText = @"删除成功";
                    [self updateMerchantListForMultiDelete];
                }
            }
            else {
                //返回错误数据
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
}

#pragma mark - Data

- (void)parseMerchantDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *merchantList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    for (int i = 0; i < [merchantList count]; i++) {
        MerchantModel *model = [[MerchantModel alloc] initWithParseDictionary:[merchantList objectAtIndex:i]];
        [_merchantItems addObject:model];
    }
    [_tableView reloadData];
}

//多删成功后更新列表
- (void)updateMerchantListForMultiDelete {
    NSMutableArray *deleteAddressArray = [[NSMutableArray alloc] init];
    NSMutableArray *deleteIndexArray = [[NSMutableArray alloc] init];
    for (NSNumber *index in _selectedItem) {
        if ([index intValue] < [_merchantItems count]) {
            MerchantModel *model = [_merchantItems objectAtIndex:[index intValue]];
            [deleteAddressArray addObject:model];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[index intValue] inSection:0];
            [deleteIndexArray addObject:indexPath];
        }
    }
    [_merchantItems removeObjectsInArray:deleteAddressArray];
    [_tableView beginUpdates];
    [_tableView deleteRowsAtIndexPaths:deleteIndexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableView endUpdates];
    self.isMultiDelete = NO;
}

//获取多选状态下选中的商户id数组
- (NSArray *)merchantIDForEditRows {
    NSMutableArray *IDs = [[NSMutableArray alloc] init];
    for (NSNumber *index in _selectedItem) {
        if ([index intValue] < [_merchantItems count]) {
            MerchantModel *model = [_merchantItems objectAtIndex:[index intValue]];
            [IDs addObject:[NSNumber numberWithInt:[model.merchantID intValue]]];
        }
    }
    return IDs;
}

#pragma mark - Action

- (IBAction)multiDelete:(id)sender {
    if (!_isMultiDelete && _tableView.isEditing) {
        _tableView.editing = NO;
    }
    self.isMultiDelete = !_isMultiDelete;
}

- (IBAction)addMerchant:(id)sender {
    if (_isMultiDelete) {
        self.isMultiDelete = NO;
    }
    CreateMerchantController *createC = [[CreateMerchantController alloc] init];
    [self.navigationController pushViewController:createC animated:YES];
}

- (IBAction)cancelDelete:(id)sender {
    self.isMultiDelete = NO;
}

- (IBAction)deleteMerchant:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:@"确认删除商户？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.tag = MerchantMultiDeleteTag;
    [alert show];
}

#pragma mark - UITableView


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_merchantItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Merchant";
    MultipleDeleteCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MultipleDeleteCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    MerchantModel *model = [_merchantItems objectAtIndex:indexPath.row];
    cell.textLabel.text = model.merchantName;
    cell.detailTextLabel.text = model.merchantLegal;
    cell.textLabel.textColor = kColor(108, 108, 108, 1);
    cell.detailTextLabel.textColor = kColor(182, 182, 182, 1);
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isMultiDelete) {
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }
    else {
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        _deletePath = indexPath;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"确认删除商户？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        alert.tag = MerchantSingleDeleteTag;
        [alert show];
    }
    else if (editingStyle == 3) {
        NSLog(@"33333");
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isMultiDelete) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        MerchantModel *model = [_merchantItems objectAtIndex:indexPath.row];
        MerchantDetailController *detailC = [[MerchantDetailController alloc] init];
        detailC.merchant = model;
        [self.navigationController pushViewController:detailC animated:YES];
    }
    else {
        [_selectedItem setObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithInteger:indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isMultiDelete) {
        [_selectedItem removeObjectForKey:[NSNumber numberWithInteger:indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Refresh

- (void)refreshViewReloadData {
    _reloading = YES;
}

- (void)refreshViewFinishedLoadingWithDirection:(PullDirection)direction {
    _reloading = NO;
    if (direction == PullFromTop) {
        [_topRefreshView refreshViewDidFinishedLoading:_tableView];
    }
    else if (direction == PullFromBottom) {
        _bottomRefreshView.frame = CGRectMake(0, _tableView.contentSize.height, _tableView.bounds.size.width, 60);
        [_bottomRefreshView refreshViewDidFinishedLoading:_tableView];
    }
    [self updateFooterViewFrame];
}

- (BOOL)refreshViewIsLoading:(RefreshView *)view {
    return _reloading;
}

- (void)refreshViewDidEndTrackingForRefresh:(RefreshView *)view {
    [self refreshViewReloadData];
    //loading...
    if (view == _topRefreshView) {
        [self pullDownToLoadData];
    }
    else if (view == _bottomRefreshView) {
        [self pullUpToLoadData];
    }
}

- (void)updateFooterViewFrame {
    _bottomRefreshView.frame = CGRectMake(0, _tableView.contentSize.height, _tableView.bounds.size.width, 60);
    _bottomRefreshView.hidden = NO;
    if (_tableView.contentSize.height < _tableView.frame.size.height) {
        _bottomRefreshView.hidden = YES;
    }
}

#pragma mark - UIScrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _primaryOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView) {
        CGPoint newPoint = scrollView.contentOffset;
        if (_primaryOffsetY < newPoint.y) {
            //上拉
            if (_bottomRefreshView.hidden) {
                return;
            }
            [_bottomRefreshView refreshViewDidScroll:scrollView];
        }
        else {
            //下拉
            [_topRefreshView refreshViewDidScroll:scrollView];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == _tableView) {
        CGPoint newPoint = scrollView.contentOffset;
        if (_primaryOffsetY < newPoint.y) {
            //上拉
            if (_bottomRefreshView.hidden) {
                return;
            }
            [_bottomRefreshView refreshViewDidEndDragging:scrollView];
        }
        else {
            //下拉
            [_topRefreshView refreshViewDidEndDragging:scrollView];
        }
    }
}

#pragma mark - 上下拉刷新
//下拉刷新
- (void)pullDownToLoadData {
    [self firstLoadData];
}

//上拉加载
- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}

#pragma mark - NSNotification

- (void)refreshMerchantList:(NSNotification *)notification {
    [self firstLoadData];
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        if (alertView.tag == MerchantSingleDeleteTag) {
            if (_deletePath) {
                [self deleteSingleMerchantWithIndexPath:_deletePath];
            }
        }
        else if (alertView.tag == MerchantMultiDeleteTag) {
            [self deleteMultiMerchant];
        }
    }
}

@end
