//
//  MessageViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/23.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "MessageViewController.h"
#import "RefreshView.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "MessageModel.h"
#import "MessageDetailController.h"
#import "MultipleDeleteCell.h"

typedef enum {
    MessageSingleDeleteTag = 30,
    MessageMultiDeleteTag,
}MessageDeleteTag;

@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshDelegate,UIAlertViewDelegate >

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL isMultiDelete;

/***************上下拉刷新**********/
@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;

@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property (nonatomic, assign) int page;
/**********************************/

@property (nonatomic, strong) NSMutableArray *messageItems;
@property (nonatomic, strong) NSMutableDictionary *selectedItem; //多选的行

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NSIndexPath *deletePath;

@end

@implementation MessageViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的消息";
    _messageItems = [[NSMutableArray alloc] init];
    _selectedItem = [[NSMutableDictionary alloc] init];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(showEdit:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self initAndLayoutUI];
    [self firstLoadData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshMessageList:)
                                                 name:RefreshMessageListNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarItem.badgeValue = nil;
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    delegate.messageCount = 0;
}

#pragma mark - UI

- (void)setIsMultiDelete:(BOOL)isMultiDelete {
    _isMultiDelete = isMultiDelete;
    [_tableView setEditing:_isMultiDelete animated:YES];
    if (_isMultiDelete) {
        [[AppDelegate shareAppDelegate].window addSubview:_bottomView];
    }
    else {
        [_selectedItem removeAllObjects];
        [_bottomView removeFromSuperview];
    }
    NSString *rightName = nil;
    if (_isMultiDelete) {
        rightName = @"取消";
    }
    else {
        rightName = @"编辑";
    }
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:rightName
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(showEdit:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setHeaderAndFooterView {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    footerView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footerView;
}

- (void)initAndLayoutUI {
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
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 49, kScreenWidth, 49)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kLineHeight)];
    firstLine.backgroundColor = [UIColor clearColor];
    [_bottomView addSubview:firstLine];
    UIButton *readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    readBtn.frame = CGRectMake(10, 7, 80, 36);
    readBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [readBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [readBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [readBtn setTitle:@"标注为已读" forState:UIControlStateNormal];
    [readBtn addTarget:self action:@selector(setReadAll:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:readBtn];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(kScreenWidth - 60, 7, 60, 36);
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteMessage:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:deleteBtn];
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
    [NetworkInterface getMyMessageListWithToken:delegate.token userID:delegate.userID page:page rows:kPageSize * 2 finished:^(BOOL success, NSData *response) {
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
                        [_messageItems removeAllObjects];
                    }
                    id list = [[object objectForKey:@"result"] objectForKey:@"content"];
                    if ([list isKindOfClass:[NSArray class]] && [list count] > 0) {
                        //有数据
                        self.page++;
                        [hud hide:YES];
                    }
                    else {
                        //无数据
                        hud.labelText = @"没有更多数据了...";
                    }
                    [self parseMessageListWithDictionary:object];
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

//标记已读
- (void)setReadStatusForSelectedMessages {
    NSArray *messagesID = [self messagesIDForEditRows];
    if ([messagesID count] <= 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择需要标注的消息";
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface messageReadWithToken:delegate.token userID:delegate.userID messagesID:messagesID finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"标注成功";
                    [self updateMessageStautsForRead];
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

//多删
- (void)deleteSelectedMessages {
    NSArray *messagesID = [self messagesIDForEditRows];
    if ([messagesID count] <= 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择需要删除的消息";
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface messsageDeleteMultiWithToken:delegate.token userID:delegate.userID messagesID:messagesID finished:^(BOOL success, NSData *response) {
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
                    [self updateMessageListForMultiDelete];
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

//单删
- (void)deleteSingleMessageWithIndexPath:(NSIndexPath *)indexPath {
    MessageModel *model = [_messageItems objectAtIndex:indexPath.row];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface messageDeleteSingleWithToken:delegate.token userID:delegate.userID messageID:model.messageID finished:^(BOOL success, NSData *response) {
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
                    [_messageItems removeObject:model];
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

#pragma mark - Data

- (void)parseMessageListWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id infoList = [[dict objectForKey:@"result"] objectForKey:@"content"];
    if ([infoList isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [infoList count]; i++) {
            id messageDict = [infoList objectAtIndex:i];
            if ([messageDict isKindOfClass:[NSDictionary class]]) {
                MessageModel *model = [[MessageModel alloc] initWithParseDictionary:messageDict];
                [_messageItems addObject:model];
            }
        }
    }
    [_tableView reloadData];
}

//标注已读后更新状态
- (void)updateMessageStautsForRead {
    for (NSNumber *index in _selectedItem) {
        if ([index intValue] < [_messageItems count]) {
            MessageModel *model = [_messageItems objectAtIndex:[index intValue]];
            model.messageRead = YES;
        }
    }
    self.isMultiDelete = NO;
    [_tableView reloadData];
}

//多删成功后更新列表
- (void)updateMessageListForMultiDelete {
    NSMutableArray *deleteMessageArray = [[NSMutableArray alloc] init];
    NSMutableArray *deleteIndexArray = [[NSMutableArray alloc] init];
    for (NSNumber *index in _selectedItem) {
        if ([index intValue] < [_messageItems count]) {
            MessageModel *model = [_messageItems objectAtIndex:[index intValue]];
            [deleteMessageArray addObject:model];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[index intValue] inSection:0];
            [deleteIndexArray addObject:indexPath];
        }
    }
    [_messageItems removeObjectsInArray:deleteMessageArray];
    [_tableView beginUpdates];
    [_tableView deleteRowsAtIndexPaths:deleteIndexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableView endUpdates];
    self.isMultiDelete = NO;
}

//获取多选状态下选中的消息id数组
- (NSArray *)messagesIDForEditRows {
    NSMutableArray *IDs = [[NSMutableArray alloc] init];
    for (NSNumber *index in _selectedItem) {
        if ([index intValue] < [_messageItems count]) {
            MessageModel *model = [_messageItems objectAtIndex:[index intValue]];
            [IDs addObject:[NSNumber numberWithInt:[model.messageID intValue]]];
        }
    }
    return IDs;
}

#pragma mark - Action

- (IBAction)showEdit:(id)sender {
    if (!_isMultiDelete && _tableView.isEditing) {
        _tableView.editing = NO;
    }
    self.isMultiDelete = !_isMultiDelete;
}

- (IBAction)setReadAll:(id)sender {
    [self setReadStatusForSelectedMessages];
}

- (IBAction)deleteMessage:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:@"确认删除消息？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.tag = MessageMultiDeleteTag;
    [alert show];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_messageItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *messageIdentifier = @"messageIdentifier";
    MultipleDeleteCell *cell = [tableView dequeueReusableCellWithIdentifier:messageIdentifier];
    if (cell == nil) {
        cell = [[MultipleDeleteCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:messageIdentifier];
    }
    MessageModel *message = [_messageItems objectAtIndex:indexPath.row];
    cell.textLabel.text = message.messageTitle;
    cell.detailTextLabel.text = message.messageTime;
    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.f];
    cell.detailTextLabel.textColor = kColor(108, 108, 108, 1);
    if (message.messageRead) {
        cell.textLabel.textColor = kColor(108, 108, 108, 1);
    }
    else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_isMultiDelete) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        MessageModel *message = [_messageItems objectAtIndex:indexPath.row];
        MessageDetailController *detailC = [[MessageDetailController alloc] init];
        detailC.message = message;
        detailC.hidesBottomBarWhenPushed = YES;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        _deletePath = indexPath;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"确认删除消息？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        alert.tag = MessageSingleDeleteTag;
        [alert show];
    }
    else if (editingStyle == 3) {
        NSLog(@"33333");
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
    if (!_isMultiDelete) {
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
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!_isMultiDelete) {
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

- (void)refreshMessageList:(NSNotification *)notification {
    id message = [notification.userInfo objectForKey:@"message"];
    if (message) {
        [_messageItems removeObject:message];
    }
    [_tableView reloadData];
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        if (alertView.tag == MessageSingleDeleteTag) {
            if (_deletePath) {
                [self deleteSingleMessageWithIndexPath:_deletePath];
            }
        }
        else if (alertView.tag == MessageMultiDeleteTag) {
            [self deleteSelectedMessages];
        }
    }
}


@end
