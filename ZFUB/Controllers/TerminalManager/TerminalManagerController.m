//
//  TerminalManagerController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/27.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "TerminalManagerController.h"
#import "RefreshView.h"
#import "AppDelegate.h"
#import "NetworkInterface.h"
#import "TerminalManagerCell.h"
#import "AddTerminalController.h"
#import "TerminalDetailController.h"
#import "ApplyDetailController.h"
#import "VideoAuthController.h"

@interface TerminalManagerController ()<UITableViewDataSource,UITableViewDelegate,RefreshDelegate,TerminalManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;

/***************上下拉刷新**********/
@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;

@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property (nonatomic, assign) int page;
/**********************************/

//终端信息数据
@property (nonatomic, strong) NSMutableArray *terminalItems;

@end

@implementation TerminalManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"终端管理";
    _terminalItems = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
    [self firstLoadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 78)];
    headerView.backgroundColor = kColor(244, 243, 243, 1);
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(80, 15, kScreenWidth - 160, 40);
    addBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [addBtn setImage:kImageName(@"add.png") forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addTerminal:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setTitle:@"添加其他终端" forState:UIControlStateNormal];
    [addBtn setTitleColor:kColor(255, 102, 36, 1) forState:UIControlStateNormal];
    [addBtn setTitleColor:kColor(134, 56, 0, 1) forState:UIControlStateHighlighted];
    addBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 10);
    [headerView addSubview:addBtn];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(116, 45, kScreenWidth - 200, 20)];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.font = [UIFont systemFontOfSize:10.f];
    infoLabel.textColor = kColor(132, 131, 131, 1);
    infoLabel.text = @"方便您查看交易流水";
    [headerView addSubview:infoLabel];
    
    _tableView.tableHeaderView = headerView;
    
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
//    footerView.backgroundColor = [UIColor clearColor];
//    _tableView.tableFooterView = footerView;
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
    [NetworkInterface getTerminalManagerListWithToken:delegate.token userID:delegate.userID page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
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
                        [_terminalItems removeAllObjects];
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
                    [self parseTerminalDataWithDictionary:object];
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

- (void)findPOSPasswordWithTerminalID:(NSString *)terminalID {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface findPOSPasswordWithToken:delegate.token tmID:terminalID finished:^(BOOL success, NSData *response) {
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
                    hud.hidden = YES;
                    id tipInfo = [object objectForKey:@"result"];
                    if ([tipInfo isKindOfClass:[NSString class]]) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                            message:tipInfo
                                                                           delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
                        [alertView show];
                    }
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

- (void)synchronizeTerminalWithTerminalID:(NSString *)terminalID {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface synchronizeWithToken:delegate.token tmID:terminalID finished:^(BOOL success, NSData *response) {
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
                    [hud hide:YES];
                    hud.labelText = @"同步成功";
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

- (void)parseTerminalDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *TM_List = [[dict objectForKey:@"result"] objectForKey:@"list"];
    for (int i = 0; i < [TM_List count]; i++) {
        TerminalManagerModel *tm_Model = [[TerminalManagerModel alloc] initWithParseDictionary:[TM_List objectAtIndex:i]];
        [_terminalItems addObject:tm_Model];
    }
    [_tableView reloadData];
}

#pragma mark - Action

- (IBAction)addTerminal:(id)sender {
    AddTerminalController *addC = [[AddTerminalController alloc] init];
    [self.navigationController pushViewController:addC animated:YES];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_terminalItems count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TerminalManagerModel *model = [_terminalItems objectAtIndex:indexPath.section];
    NSString *cellIdentifier = nil;
    switch ([model.TM_status intValue]) {
        case TerminalStatusOpened:
            //已开通
            if (model.appID) {
                cellIdentifier = OpenedFirstStatusIdentifier;
            }
            else {
                cellIdentifier = OpenedSecondStatusIdentifier;
            }
            break;
        case TerminalStatusPartOpened:
            //部分开通
            cellIdentifier = PartOpenedStatusIdentifier;
            break;
        case TerminalStatusUnOpened:
            //未开通
            if (model.appID) {
                cellIdentifier = UnOpenedSecondStatusIdentifier;
            }
            else {
                cellIdentifier = UnOpenedFirstStatusIdentifier;
            }
            break;
        case TerminalStatusCanceled:
            //已注销
            cellIdentifier = CanceledStatusIdentifier;
            break;
        case TerminalStatusStopped:
            //已停用
            cellIdentifier = StoppedStatusIdentifier;
            break;
        default:
            break;
    }
    TerminalManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[TerminalManagerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier hasVideoAuth:model.hasVideoAuth];
        cell.delegate = self;
    }
    [cell setContentsWithData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TerminalManagerModel *model = [_terminalItems objectAtIndex:indexPath.section];
    if ([model.TM_status intValue] == TerminalStatusCanceled) {
        return kTMShortCellHeight;
    }
    else if ([model.TM_status intValue] == TerminalStatusOpened && !model.appID) {
        return kTMMiddleCellHeight;
    }
    return kTMLongCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TerminalManagerModel *model = [_terminalItems objectAtIndex:indexPath.section];
    if ([model.TM_status intValue] == TerminalStatusOpened && !model.appID) {
        //自助开通无法查看详情
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"自助开通终端无详情信息";
        return;
    }
    else {
        TerminalDetailController *detailC = [[TerminalDetailController alloc] init];
        detailC.terminalModel = model;
        [self.navigationController pushViewController:detailC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
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

#pragma mark - TerminalManagerDelegate
//视频认证
- (void)terminalManagerVideoAuthWithData:(TerminalManagerModel *)model {
    VideoAuthController *videoAuthC = [[VideoAuthController alloc] init];
    videoAuthC.terminalID = model.TM_ID;
    [self.navigationController pushViewController:videoAuthC animated:YES];
}

//找回POS密码
- (void)terminalManagerFindPasswordWithData:(TerminalManagerModel *)model {
    [self findPOSPasswordWithTerminalID:model.TM_ID];
}

//同步
- (void)terminalManagerSynchronizationWithData:(TerminalManagerModel *)model {
    
}

//开通申请
- (void)terminalManagerOpenApplyWithData:(TerminalManagerModel *)model {
    ApplyDetailController *detail = [[ApplyDetailController alloc] init];
    detail.terminalID = model.TM_ID;
    [self.navigationController pushViewController:detail animated:YES];
}

//重新开通申请
- (void)terminalManagerOpenConfirmWithData:(TerminalManagerModel *)model {
    ApplyDetailController *detail = [[ApplyDetailController alloc] init];
    detail.terminalID = model.TM_ID;
    [self.navigationController pushViewController:detail animated:YES];
}


@end
