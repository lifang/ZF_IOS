//
//  OpenApplyController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/28.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "OpenApplyController.h"
#import "RefreshView.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "OpenApplyCell.h"
#import "ApplyDetailController.h"
#import "TerminalDetailController.h"
#import "VideoAuthController.h"
#import "ProtocolView.h"

@interface OpenApplyController ()<UITableViewDataSource,UITableViewDelegate,RefreshDelegate,OpenApplyCellDelegate,ProtocolAgreeDelegate>

@property (nonatomic, strong) UITableView *tableView;

/***************上下拉刷新**********/
@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;

@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property (nonatomic, assign) int page;
/**********************************/

//终端信息数据
@property (nonatomic, strong) NSMutableArray *applyList;

@property (nonatomic, strong) TerminalManagerModel *selectedModel;

@end

@implementation OpenApplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"开通申请";
    _applyList = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
    [self firstLoadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
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
    [NetworkInterface getApplyListWithToken:delegate.token userID:delegate.userID page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
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
                        [_applyList removeAllObjects];
                    }
                    if ([[object objectForKey:@"result"] count] > 0) {
                        //有数据
                        self.page++;
                        [hud hide:YES];
                    }
                    else {
                        //无数据
                        hud.labelText = @"没有更多数据了...";
                    }
                    [self parseApplyDataWithDictionary:object];
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

//发起视频请求
- (void)beginVideoAuthWithTerminalID:(NSString *)terminalID {
    [NetworkInterface beginVideoAuthWithTerminalID:terminalID finished:^(BOOL success, NSData *response) {
        NSLog(@"!!!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                }
                else if ([errorCode intValue] == RequestSuccess) {
                }
            }
            else {
                //返回错误数据
            }
        }
        else {
        }
    }];
}

#pragma mark - Data

- (void)parseApplyDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *TM_List = [dict objectForKey:@"result"];
    for (int i = 0; i < [TM_List count]; i++) {
        TerminalManagerModel *tm_Model = [[TerminalManagerModel alloc] initWithParseDictionary:[TM_List objectAtIndex:i]];
        [_applyList addObject:tm_Model];
    }
    [_tableView reloadData];
}

#pragma mark - Action


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_applyList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TerminalManagerModel *model = [_applyList objectAtIndex:indexPath.section];
    NSString *cellIdentifier = nil;
    switch ([model.TM_status intValue]) {
        case TerminalStatusPartOpened:
            //部分开通
            cellIdentifier = partOpenedApplyIdentifier;
            break;
        case TerminalStatusUnOpened:
            //未开通
            cellIdentifier = unOpenedApplyIdentifier;
            break;
        default:
            break;
    }
    OpenApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[OpenApplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier hasVideoAuth:model.hasVideoAuth];
        cell.delegate = self;
    }
    [cell setContentsWithData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kOpenApplyCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TerminalManagerModel *model = [_applyList objectAtIndex:indexPath.section];
    TerminalDetailController *detailC = [[TerminalDetailController alloc] init];
    detailC.terminalModel = model;
    [self.navigationController pushViewController:detailC animated:YES];
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

#pragma mark - OpenApplyCellDelegate
//申请开通
- (void)openApplyWithData:(TerminalManagerModel *)model {
    ProtocolView *protocolView = [[ProtocolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) string:@"博物馆现有藏品1000多件，工作人员50余人，现设有办公室、业务部、保卫部等部门。展览的主题：触摸农家记忆—传统农耕文明中的百姓文化生活，突出农家农耕文化特点和器物制作的成就，展现出传统农耕文明中百姓家庭生活的情趣和喜怒哀乐等。博物馆主要从事农业、民俗、餐饮等文化相关的藏品收藏、保护、研究、展示和文化交流。把历史悠久的文物打造成新时期具有教育性、研究性、欣赏性、利用性为一体的红色教育基地。活的情趣和喜怒哀乐等。博物馆主要从事农业、民俗、餐饮等文化相关的藏品收藏、保护、研究、展示和文化交流。把历史悠久的文物打造成新时期具有教育性、研究性、欣赏性、利用性为一体的红色教育基地"];
    protocolView.delegate = self;
    [[AppDelegate shareAppDelegate].window addSubview:protocolView];

    _selectedModel = model;
}

//视频认证
- (void)videoAuthWithData:(TerminalManagerModel *)model {
    [self beginVideoAuthWithTerminalID:model.TM_ID];
    VideoAuthController *videoAuthC = [[VideoAuthController alloc] init];
    videoAuthC.terminalID = model.TM_ID;
    [self.navigationController pushViewController:videoAuthC animated:YES];
}
//重新申请开通
- (void)reopenApplyWithData:(TerminalManagerModel *)model {
    ApplyDetailController *detailC = [[ApplyDetailController alloc] init];
    detailC.terminalID = model.TM_ID;
    detailC.openStatus = OpenStatusReopen;
    [self.navigationController pushViewController:detailC animated:YES];
}

#pragma mark - ProcotolAgreeDelegate 

- (void)protocolView:(ProtocolView *)view agreeProtocolWithStatus:(BOOL)isSelected {
    if (!isSelected) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[AppDelegate shareAppDelegate].window animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.5f];
        hud.labelText = @"请仔细阅读开通协议，并接受协议";
        return;
    }
    else {
        [view removeFromSuperview];
        ApplyDetailController *detailC = [[ApplyDetailController alloc] init];
        detailC.terminalID = _selectedModel.TM_ID;
        detailC.openStatus = OpenStatusNew;
        [self.navigationController pushViewController:detailC animated:YES];
    }
}

@end
