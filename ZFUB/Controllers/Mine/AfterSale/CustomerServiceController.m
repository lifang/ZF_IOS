//
//  CustomerServiceController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CustomerServiceController.h"
#import "RefreshView.h"
#import "AppDelegate.h"
#import "CustomerServiceHandle.h"
#import "CustomerServiceModel.h"
#import "RepairDetailController.h"
#import "ReturnDetailController.h"
#import "CancelDetailController.h"
#import "ChangeDetailController.h"
#import "UpdateDetailController.h"
#import "RentDetailController.h"

@interface CustomerServiceController ()<UITableViewDataSource,UITableViewDelegate,RefreshDelegate>

@property (nonatomic, strong) UITableView *tableView;

/***************上下拉刷新**********/
@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;

@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property (nonatomic, assign) int page;
/**********************************/

@property (nonatomic, strong) NSMutableArray *csItems;

@end

@implementation CustomerServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [CustomerServiceHandle titleForCSType:_csType];
    _csItems = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
    [self firstLoadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 8.f)];
    headerView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.tableHeaderView = headerView;
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
    [NetworkInterface getCSListWithToken:delegate.token userID:delegate.userID csType:_csType page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
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
                        [_csItems removeAllObjects];
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
                    [self parseCSDataWithDictionary:object];
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


#pragma mark - Data

- (void)parseCSDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *csList = [[dict objectForKey:@"result"] objectForKey:@"content"];
    for (int i = 0; i < [csList count]; i++) {
        CustomerServiceModel *model = [[CustomerServiceModel alloc] initWithParseDictionary:[csList objectAtIndex:i]];
        [_csItems addObject:model];
    }
    [_tableView reloadData];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_csItems count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomerServiceModel *data = [_csItems objectAtIndex:indexPath.section];
    NSString *identifier = [data getCellIdentifier];
    CustomerServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CustomerServiceCell alloc] initWithCSType:_csType reuseIdentifier:identifier];
    }
    [cell setContentsWithData:data];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomerServiceModel *data = [_csItems objectAtIndex:indexPath.section];
    NSString *identifier = [data getCellIdentifier];
    if (_csType == CSTypeRepair) {
        if ([identifier isEqualToString:firstStatusIdentifier] ||
            [identifier isEqualToString:secondStatusIdentifier]) {
            return kCSCellLongHeight;
        }
    }
    else if (_csType == CSTypeReturn) {
        if ([identifier isEqualToString:firstStatusIdentifier] ||
            [identifier isEqualToString:secondStatusIdentifier]) {
            return kCSCellLongHeight;
        }
    }
    else if (_csType == CSTypeCancel) {
        if ([identifier isEqualToString:firstStatusIdentifier] ||
            [identifier isEqualToString:fifthStatusIdentifier]) {
            return kCSCellLongHeight;
        }
    }
    else if (_csType == CSTypeChange) {
        if ([identifier isEqualToString:firstStatusIdentifier] ||
            [identifier isEqualToString:secondStatusIdentifier]) {
            return kCSCellLongHeight;
        }
    }
    else if (_csType == CSTypeUpdate) {
        if ([identifier isEqualToString:firstStatusIdentifier]) {
            return kCSCellLongHeight;
        }
    }
    else if (_csType == CSTypeLease) {
        if ([identifier isEqualToString:firstStatusIdentifier] ||
            [identifier isEqualToString:secondStatusIdentifier]) {
            return kCSCellLongHeight;
        }
    }
    return kCSCellShortHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CustomerServiceModel *model = [_csItems objectAtIndex:indexPath.section];
    switch (_csType) {
        case CSTypeRepair: {
            RepairDetailController *detailC = [[RepairDetailController alloc] init];
            detailC.csID = model.csID;
            detailC.csType = _csType;
            [self.navigationController pushViewController:detailC animated:YES];
        }
            break;
        case CSTypeReturn: {
            ReturnDetailController *detailC = [[ReturnDetailController alloc] init];
            detailC.csID = model.csID;
            detailC.csType = _csType;
            [self.navigationController pushViewController:detailC animated:YES];
        }
            break;
        case CSTypeCancel: {
            CancelDetailController *detailC = [[CancelDetailController alloc] init];
            detailC.csID = model.csID;
            detailC.csType = _csType;
            [self.navigationController pushViewController:detailC animated:YES];
        }
            break;
        case CSTypeChange: {
            ChangeDetailController *detailC = [[ChangeDetailController alloc] init];
            detailC.csID = model.csID;
            detailC.csType = _csType;
            [self.navigationController pushViewController:detailC animated:YES];
        }
            break;
        case CSTypeUpdate: {
            UpdateDetailController *detailC = [[UpdateDetailController alloc] init];
            detailC.csID = model.csID;
            detailC.csType = _csType;
            [self.navigationController pushViewController:detailC animated:YES];
        }
            break;
        case CSTypeLease: {
            RentDetailController *detailC = [[RentDetailController alloc] init];
            detailC.csID = model.csID;
            detailC.csType = _csType;
            [self.navigationController pushViewController:detailC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8.f;
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


@end
