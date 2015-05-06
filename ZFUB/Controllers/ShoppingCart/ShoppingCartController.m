//
//  ShoppingCartController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/23.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ShoppingCartController.h"
#import "ShoppingCartCell.h"
#import "ShoppingCartFooterView.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "ShoppingCartModel.h"
#import "ShoppingCartOrderController.h"
#import "RefreshView.h"

@interface ShoppingCartController ()<UITableViewDataSource,UITableViewDelegate,ShoppingCartDelegate,SelectedShopCartDelegate,RefreshDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ShoppingCartFooterView *bottomView;

@property (nonatomic, strong) NSMutableArray *dataItem;

@property (nonatomic, strong) RefreshView *topRefreshView;

@property (nonatomic, assign) BOOL reloading;

@property (nonatomic, assign) CGFloat primaryOffsetY;

@end

@implementation ShoppingCartController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"购物车";
    [self initAndLayoutUI];
    _dataItem = [[NSMutableArray alloc] init];
    [self getShoppingList];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshCartList:)
                                                 name:RefreshShoppingCartNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarItem.badgeValue = nil;
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    delegate.shopcartCount = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.001)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footerView;
}

- (void)initAndLayoutUI {
    _bottomView = [[ShoppingCartFooterView alloc] init];
    _bottomView.backgroundColor = kColor(235, 233, 233, 1);
    _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    _bottomView.delegate = self;
    [_bottomView.finishButton addTarget:self action:@selector(orderConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bottomView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bottomView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bottomView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bottomView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bottomView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:60.f]];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self setHeaderAndFooterView];
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
                                                             toItem:_bottomView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    _topRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, -80, self.view.bounds.size.width, 80)];
    _topRefreshView.direction = PullFromTop;
    _topRefreshView.delegate = self;
    [_tableView addSubview:_topRefreshView];
}

#pragma mark - Data

- (void)getShoppingList {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getShoppingCartWithToken:delegate.token userID:delegate.userID finished:^(BOOL success, NSData *response) {
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
                    [hud hide:YES];
                    [self parseDataWithDictionary:object];
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
        [self refreshViewFinishedLoadingWithDirection:PullFromTop];
    }];
}

- (void)parseDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    [_dataItem removeAllObjects];
    [self getSummaryPrice];
    NSArray *cartList = [dict objectForKey:@"result"];
    for (int i = 0; i < [cartList count]; i++) {
        NSDictionary *dict = [cartList objectAtIndex:i];
        ShoppingCartModel *cart = [[ShoppingCartModel alloc] initWithParseDictionary:dict];
        [_dataItem addObject:cart];
    }
    [_tableView reloadData];
}

//计算总价
- (void)getSummaryPrice {
    CGFloat summaryPrice = 0.f;
    for (ShoppingCartModel *model in _dataItem) {
        if (model.isSelected) {
            summaryPrice += (model.cartPrice + model.channelCost) * model.cartCount;
        }
    }
    _bottomView.totalLabel.text = [NSString stringWithFormat:@"合计：￥%.2f",summaryPrice];
}

#pragma mark - Action

- (IBAction)orderConfirm:(id)sender {
    NSMutableArray *selectedOrder = [[NSMutableArray alloc] init];
    for (ShoppingCartModel *model in _dataItem) {
        if (model.isSelected) {
            [selectedOrder addObject:model];
        }
    }
    if ([selectedOrder count] <= 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请至少选择一件商品";
        return;
    }
    ShoppingCartOrderController *orderC = [[ShoppingCartOrderController alloc] init];
    orderC.shoppingCartItem = selectedOrder;
    orderC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderC animated:YES];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_dataItem count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingCartCell *cell = nil;
    ShoppingCartModel *cart = [_dataItem objectAtIndex:indexPath.section];
    if (!cart.isEditing) {
        cell = [tableView dequeueReusableCellWithIdentifier:shoppingCartIdentifier_normal];
        if (cell == nil) {
            cell = [[ShoppingCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shoppingCartIdentifier_normal];
        }
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:shoppingCartIdentifier_edit];
        if (cell == nil) {
            cell = [[ShoppingCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shoppingCartIdentifier_edit];
        }
    }
    cell.delegate = self;
    [cell setShoppingCartData:cart];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kShoppingCartCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShoppingCartCell *cell = (ShoppingCartCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell selectedOrder:nil];
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
}

- (BOOL)refreshViewIsLoading:(RefreshView *)view {
    return _reloading;
}

- (void)refreshViewDidEndTrackingForRefresh:(RefreshView *)view {
    [self refreshViewReloadData];
    //loading...
    [self getShoppingList];
}


#pragma mark - UIScrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _primaryOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView) {
        CGPoint newPoint = scrollView.contentOffset;
        if (_primaryOffsetY < newPoint.y) {

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
        }
        else {
            //下拉
            [_topRefreshView refreshViewDidEndDragging:scrollView];
        }
    }
}

#pragma mark - ShoppingCartDelegate

- (void)selectRowForCell {
    //计算总价
    [self getSummaryPrice];
    
    int selectedCount = 0;
    for (ShoppingCartModel *model in _dataItem) {
        if (model.isSelected) {
            selectedCount++;
        }
    }
    if (selectedCount == [_dataItem count]) {
        [_bottomView setSelectedStatus:YES];
    }
    else {
        [_bottomView setSelectedStatus:NO];
    }
}

- (void)editOrderForCell:(ShoppingCartCell *)cell {
    cell.cartData.isEditing = !cell.cartData.isEditing;
    NSArray *indexPaths = [NSArray arrayWithObjects:
                           [_tableView indexPathForCell:cell],
                           nil];
    [_tableView beginUpdates];
    [_tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableView endUpdates];
}

- (void)minusCountForCell:(ShoppingCartCell *)cell {
    [self updateShoppingCartWithCart:cell.cartData
                            newCount:[cell.numberField.text intValue]];
}

- (void)addCountForCell:(ShoppingCartCell *)cell {
    [self updateShoppingCartWithCart:cell.cartData
                            newCount:[cell.numberField.text intValue]];
}

- (void)deleteOrderForCell:(ShoppingCartCell *)cell {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface deleteShoppingCartWithToken:delegate.token cartID:cell.cartData.cartID finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"删除成功";
                    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
                    [_dataItem removeObjectAtIndex:indexPath.section];
                    [_tableView beginUpdates];
                    [_tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
                    [_tableView endUpdates];
                    [self getSummaryPrice];
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

- (void)updateShoppingCartWithCart:(ShoppingCartModel *)cart
                          newCount:(int)count {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface updateShoppingCartWithToken:delegate.token cartID:cart.cartID count:count finished:^(BOOL success, NSData *response) {
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
                    [hud hide:YES];
                    cart.cartCount = count;
                    [self getSummaryPrice];
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

#pragma mark - SelectedShopCartDelegate

- (void)selectedAllShoppingCart:(BOOL)isSelected {
    for (ShoppingCartModel *model in _dataItem) {
        model.isSelected = isSelected;
    }
    [_tableView reloadData];
    [self getSummaryPrice];
}

#pragma mark - Notification 

- (void)refreshCartList:(NSNotification *)notification {
    [self getShoppingList];
}

@end
