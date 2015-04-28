//
//  MyOrderViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/7.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "MyOrderViewController.h"
#import "KxMenu.h"
#import "RefreshView.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "OrderCell.h"
#import "OrderDetailController.h"
#import "PayWayViewController.h"
#import "OrderCommentController.h"

@interface MyOrderViewController ()<UITableViewDelegate,UITableViewDataSource,RefreshDelegate,OrderCellDelegate,UIAlertViewDelegate>

@property (nonatomic, assign) OrderType currentType;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *statusButton;

@property (nonatomic, strong) UILabel *statusLabel;

/***************上下拉刷新**********/
@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;

@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property (nonatomic, assign) int page;
/**********************************/

//订单信息
@property (nonatomic, strong) NSMutableArray *orderItems;

//保存进行操作的cell对应的数据
@property (nonatomic, strong) OrderModel *selectedModel;

@end

@implementation MyOrderViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的订单";
    
    _orderItems = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshOrderList:)
                                                 name:RefreshMyOrderListNotification
                                               object:nil];
    
    [self initAndLayoutUI];
    self.currentType = OrderTypeAll;
    [self firstLoadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    headerView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.tableHeaderView = headerView;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 30)];
    backView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:backView];
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kLineHeight)];
    firstLine.backgroundColor = kColor(200, 199, 204, 1);
    [backView addSubview:firstLine];
    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(0, 30 - kLineHeight, kScreenWidth, kLineHeight)];
    secondLine.backgroundColor = kColor(200, 199, 204, 1);
    [backView addSubview:secondLine];
    
    _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _statusButton.frame = CGRectMake(10, 0, 110, 30);
    _statusButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [_statusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_statusButton setTitle:@"选择订单类型" forState:UIControlStateNormal];
    [_statusButton setImage:kImageName(@"arrow.png") forState:UIControlStateNormal];
    [_statusButton addTarget:self action:@selector(showOrderStatus:) forControlEvents:UIControlEventTouchUpInside];
    _statusButton.imageEdgeInsets = UIEdgeInsetsMake(0, 100, 0, 0);
    _statusButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [backView addSubview:_statusButton];
    
    CGFloat originX = _statusButton.frame.origin.x + _statusButton.frame.size.width + 10;
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, kScreenWidth - originX, 30)];
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.font = [UIFont systemFontOfSize:13.f];
    _statusLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrderStatus:)];
    [_statusLabel addGestureRecognizer:tap];
    [backView addSubview:_statusLabel];
    
    UIView *footerView = [[UIView alloc] init];
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
}

- (NSString *)stringForOrderType:(OrderType)type {
    NSString *title = nil;
    switch (type) {
        case OrderTypeAll:
            title = @"全部";
            break;
        case OrderTypeBuy:
            title = @"购买";
            break;
        case OrderTypeRent:
            title = @"租赁";
            break;
        default:
            break;
    }
    return title;
}

- (void)setCurrentType:(OrderType)currentType {
    _currentType = currentType;
    _statusLabel.text = [self stringForOrderType:_currentType];
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
    [NetworkInterface getMyOrderListWithToken:delegate.token userID:delegate.userID orderType:_currentType page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
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
                        [_orderItems removeAllObjects];
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
                    [self parseOrderListDataWithDictionary:object];
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

//取消订单
- (void)cancelOrder {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface cancelMyOrderWithToken:delegate.token orderID:_selectedModel.orderID finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",[object objectForKey:@"code"]];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    hud.labelText = @"订单取消成功";
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshMyOrderListNotification object:nil];
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

- (void)parseOrderListDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *orderList = [[dict objectForKey:@"result"] objectForKey:@"content"];
    for (int i = 0; i < [orderList count]; i++) {
        OrderModel *model = [[OrderModel alloc] initWithParseDictionary:[orderList objectAtIndex:i]];
        [_orderItems addObject:model];
    }
    [_tableView reloadData];
}

#pragma mark - Action

- (IBAction)showOrderStatus:(id)sender {
    NSMutableArray *listArray = [NSMutableArray arrayWithObjects:
                                 [KxMenuItem menuItem:[self stringForOrderType:OrderTypeAll]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.text
                                                  tag:OrderTypeAll],
                                 [KxMenuItem menuItem:[self stringForOrderType:OrderTypeBuy]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.text
                                                  tag:OrderTypeBuy],
                                 [KxMenuItem menuItem:[self stringForOrderType:OrderTypeRent]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.text
                                                  tag:OrderTypeRent],
                                 nil];
    
    CGRect rect = CGRectMake(_statusButton.frame.origin.x + _statusButton.frame.size.width / 2, _statusButton.frame.origin.y + _statusButton.frame.size.height + 5, 0, 0);
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:listArray];
}

- (IBAction)selectStatus:(id)sender {
    KxMenuItem *item = (KxMenuItem *)sender;
    self.currentType = (OrderType)item.tag;
    [self firstLoadData];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_orderItems count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderModel *model = [_orderItems objectAtIndex:indexPath.section];
    NSString *identifier = [model getCellIdentifier];
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[OrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.delegate = self;
    [cell setContentsWithData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderModel *model = [_orderItems objectAtIndex:indexPath.section];
    NSString *identifier = [model getCellIdentifier];
    if ([identifier isEqualToString:unPaidIdentifier] ||
        [identifier isEqualToString:sendingIdentifier]) {
        return kOrderLongCellHeight;
    }
    return kOrderShortCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderModel *model = [_orderItems objectAtIndex:indexPath.section];
    OrderDetailController *detailC = [[OrderDetailController alloc] init];
    detailC.orderID = model.orderID;
    detailC.goodName = model.orderGood.goodName;
    detailC.fromType = PayWayFromNone;
    [self.navigationController pushViewController:detailC animated:YES];
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


#pragma mark - Notification

- (void)refreshOrderList:(NSNotification *)notification {
    [self performSelector:@selector(firstLoadData) withObject:nil afterDelay:0.1f];
}

#pragma mark - OrderCellDelegate 

- (void)orderCellCancelOrderForData:(OrderModel *)model {
    _selectedModel = model;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:@"确定取消此订单？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)orderCellPayOrderForData:(OrderModel *)model {
    _selectedModel = model;
    PayWayViewController *payWayC = [[PayWayViewController alloc] init];
    payWayC.orderID = _selectedModel.orderID;
    payWayC.totalPrice = _selectedModel.orderTotalPrice;
    payWayC.goodName = _selectedModel.orderGood.goodName;
    payWayC.fromType = PayWayFromOrder;
    [self.navigationController pushViewController:payWayC animated:YES];
}

- (void)orderCellCommentOrderForData:(OrderModel *)model {
    _selectedModel = model;
    OrderCommentController *commentC = [[OrderCommentController alloc] init];
    commentC.orderID = _selectedModel.orderID;
    [self.navigationController pushViewController:commentC animated:YES];   
}

#pragma mark - AlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self cancelOrder];
    }
}

@end
