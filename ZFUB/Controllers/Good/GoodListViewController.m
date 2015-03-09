//
//  GoodListViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/24.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "GoodListViewController.h"
#import "SearchViewController.h"
#import "FilterViewController.h"
#import "NavigationBarAttr.h"
#import "ZFSearchBar.h"
#import "GoodsCell.h"
#import "SortView.h"
#import "RefreshView.h"
#import "NetworkInterface.h"
#import "GoodListModel.h"
#import "AppDelegate.h"
#import "TreeDataHandle.h"
#import "GoodDetailViewController.h"

@interface GoodListViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,SortViewDelegate,RefreshDelegate,SearchDelegate>

@property (nonatomic, strong) ZFSearchBar *searchBar;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) SortView *sortView;

@property (nonatomic, strong) NSMutableArray *dataItem;

@property (nonatomic, strong) RefreshView *topRefreshView;

@property (nonatomic, strong) RefreshView *bottomRefreshView;

@property (nonatomic, assign) BOOL reloading;

@property (nonatomic, assign) CGFloat primaryOffsetY;

@property (nonatomic, assign) int page;

/*搜索字段*/

@property (nonatomic, assign) OrderFilter filterType;  //排序类型
///保存用户选择的筛选条件
@property (nonatomic, strong) NSMutableDictionary *filterDict;
@property (nonatomic, strong) NSString *keyword;      //关键字

@end

@implementation GoodListViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initAndLayoutUI];
    _dataItem = [[NSMutableArray alloc] init];
    _filterDict = [[NSMutableDictionary alloc] init];
    [self setOriginalQuery];
    [self firstLoadData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateGoodList)
                                                 name:UpdateGoodListNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
    //导航栏
    [self initNavigationBarView];
    
    [self initContentView];
}

- (void)initNavigationBarView {
    _searchBar = [[ZFSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    _searchBar.inputField.clearButtonMode = UITextFieldViewModeNever;
    _searchBar.delegate = self;
    self.navigationItem.titleView = _searchBar;
    
    UIButton *shoppingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shoppingButton.frame = CGRectMake(0, 0, 24, 24);
    [shoppingButton setBackgroundImage:kImageName(@"good_right1.png") forState:UIControlStateNormal];
    [shoppingButton addTarget:self action:@selector(goShoppingCart:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterButton.frame = CGRectMake(0, 0, 24, 24);
    [filterButton setBackgroundImage:kImageName(@"good_right2.png") forState:UIControlStateNormal];
    [filterButton addTarget:self action:@selector(filterGoods:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置间距
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    spaceItem.width = -5;
    UIBarButtonItem *shoppingItem = [[UIBarButtonItem alloc] initWithCustomView:shoppingButton];
    UIBarButtonItem *filterItem = [[UIBarButtonItem alloc] initWithCustomView:filterButton];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:spaceItem,shoppingItem,filterItem, nil];
}

- (void)setHeaderAndFooterView {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footerView;
}

- (void)initContentView {
    NSArray *nameArray = [NSArray arrayWithObjects:
                      @"默认排序",
                      @"销量优先",
                      @"价格降序",
                      @"评分最高",
                      nil];
    _sortView = [[SortView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    _sortView.delegate = self;
    [_sortView setItems:nameArray];
    [self.view addSubview:_sortView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self setHeaderAndFooterView];
    [self.view addSubview:_tableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_sortView
                                                          attribute:NSLayoutAttributeBottom
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

#pragma mark - Data

//搜索条件初始化
- (void)setOriginalQuery {
    _filterType = OrderFilterDefault;
    _keyword = nil;
    TreeNodeModel *original = [[TreeNodeModel alloc] initWithDirectoryName:@"全部"
                                                                  children:nil
                                                                    nodeID:kNoneFilterID];
    NSMutableArray *item = [[NSMutableArray alloc] initWithObjects:original, nil];
    //所有条件可多选，value为数组
    [_filterDict setObject:item forKey:s_brands];
    [_filterDict setObject:item forKey:s_category];
    [_filterDict setObject:item forKey:s_channel];
    [_filterDict setObject:item forKey:s_card];
    [_filterDict setObject:item forKey:s_trade];
    [_filterDict setObject:item forKey:s_slip];
    [_filterDict setObject:item forKey:s_date];
    //值
    [_filterDict setObject:[NSNumber numberWithBool:NO] forKey:s_rent];
    [_filterDict setObject:[NSNumber numberWithFloat:0] forKey:s_maxPrice];
    [_filterDict setObject:[NSNumber numberWithFloat:0] forKey:s_minPrice];
}

//根据字典中选中条件获取请求需要的数组
- (NSArray *)filterForKey:(NSString *)key {
    NSArray *filterItem = [_filterDict objectForKey:key];
    for (TreeNodeModel *node in filterItem) {
        //若筛选条件包含全部，数组返回nil
        if ([node.nodeID isEqualToString:kNoneFilterID]) {
            return nil;
        }
    }
    NSMutableArray *IDItem = [[NSMutableArray alloc] init];
    for (TreeNodeModel *node in filterItem) {
        [IDItem addObject:[NSNumber numberWithInt:[node.nodeID intValue]]];
    }
    return IDItem;
}

- (void)firstLoadData {
    _page = 1;
    [self downloadDataWithPage:_page isMore:NO];
}

- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    //****************筛选条件***************
    NSArray *brandItem = [self filterForKey:s_brands];
    NSArray *catrgoryItem = [self filterForKey:s_category];
    NSArray *channelItem = [self filterForKey:s_channel];
    NSArray *cardItem = [self filterForKey:s_card];
    NSArray *tradeItem = [self filterForKey:s_trade];
    NSArray *slipItem = [self filterForKey:s_slip];
    NSArray *dateItem = [self filterForKey:s_date];
    BOOL isRent = [[_filterDict objectForKey:s_rent] boolValue];
    CGFloat maxPrice = [[_filterDict objectForKey:s_maxPrice] floatValue];
    CGFloat minPrice = [[_filterDict objectForKey:s_minPrice] floatValue];
    //***************************************
    [NetworkInterface getGoodListWithCityID:delegate.cityID sortType:_filterType brandID:brandItem category:catrgoryItem channelID:channelItem payCardID:cardItem tradeID:tradeItem slipID:slipItem date:dateItem maxPrice:maxPrice minPrice:minPrice keyword:_keyword onlyRent:isRent page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
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
                        [_dataItem removeAllObjects];
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
        if (!isMore) {
            [self refreshViewFinishedLoadingWithDirection:PullFromTop];
        }
        else {
            [self refreshViewFinishedLoadingWithDirection:PullFromBottom];
        }
    }];
}

- (void)parseDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *goodList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    for (int i = 0; i < [goodList count]; i++) {
        GoodListModel *good = [[GoodListModel alloc] initWithParseDictionary:[goodList objectAtIndex:i]];
        [_dataItem addObject:good];
    }
    [_tableView reloadData];
}

#pragma mark - Action

- (IBAction)goShoppingCart:(id)sender {
    [self.tabBarController setSelectedIndex:1];
}

- (IBAction)filterGoods:(id)sender {
    FilterViewController *filterC = [[FilterViewController alloc] init];
    filterC.filterDict = _filterDict;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:filterC];
    [NavigationBarAttr setNavigationBarStyle:nav];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Notification

- (void)updateGoodList {
    [self firstLoadData];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataItem count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Goods";
    GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[GoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    GoodListModel *good = [_dataItem objectAtIndex:indexPath.row];
    [cell.pictureView sd_setImageWithURL:[NSURL URLWithString:good.goodImagePath]
                        placeholderImage:kImageName(@"test1.png")];
    cell.titleLabel.text = good.goodName;
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",good.goodPrice];
    cell.salesVolumeLabel.text = [NSString stringWithFormat:@"已售%@",good.goodSaleNumber];
    cell.brandLabel.text = [NSString stringWithFormat:@"品牌型号   %@%@",good.goodBrand,good.goodModel];
    cell.channelLabel.text = [NSString stringWithFormat:@"支付通道   %@",good.goodChannel];
    if (good.isRent) {
        cell.attrView.hidden = NO;
    }
    else {
        cell.attrView.hidden = YES;
    }
    
    return cell;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kGoodCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoodListModel *good = [_dataItem objectAtIndex:indexPath.row];
    GoodDetailViewController *detailC = [[GoodDetailViewController alloc] init];
    detailC.goodID = good.goodID;
    [self.navigationController pushViewController:detailC animated:YES];
}

#pragma mark - UISearchBar

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    SearchViewController *searchC = [[SearchViewController alloc] init];
    searchC.delegate = self;
    searchC.keyword = _keyword;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchC];
    [NavigationBarAttr setNavigationBarStyle:nav];
    [self presentViewController:nav animated:NO completion:nil];
    return NO;
}

#pragma mark - SortViewDelegate

- (void)changeValueWithIndex:(NSInteger)index {
    switch (index) {
        case SortDefault:
            _filterType = OrderFilterDefault;
            break;
        case SortSales:
            _filterType = OrderFilterSales;
            break;
        case SortPriceDown:
            _filterType = OrderFilterPriceDown;
            break;
        case SortPriceUp:
            _filterType = OrderFilterPriceUp;
            break;
        case SortScore:
            _filterType = OrderFilterScore;
            break;
        default:
            break;
    }
    [self firstLoadData];
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

#pragma mark - SearchDelegate

- (void)getSearchKeyword:(NSString *)keyword {
    _keyword = keyword;
    _searchBar.text = _keyword;
    [self firstLoadData];
}

@end
