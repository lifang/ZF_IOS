//
//  LocationViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/11.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "LocationViewController.h"
#import "CitySearchController.h"

@interface CitySearchBar : UISearchBar

@end

@implementation CitySearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

- (void)initUI {
    if (kDeviceVersion >= 7.0) {
        self.barTintColor = kColor(255, 102, 36, 1);
        self.tintColor = [UIColor whiteColor];
    }
    else {
        self.tintColor = kColor(255, 102, 36, 1);
    }
    
    CGRect rect = self.bounds;
    rect.origin.y -= 20;
    rect.size.height += 20;
    rect.size.width = kScreenWidth;
    UIImageView *backView = [[UIImageView alloc] initWithFrame:rect];
    backView.image = kImageName(@"orange.png");
    [self insertSubview:backView atIndex:1];
    //设置光标
    [self setCursor];
}

- (void)setCursor {
    NSArray *subviews = nil;
    if (kDeviceVersion >= 7.0) {
        subviews = [[self.subviews objectAtIndex:0] subviews];
    }
    else {
        subviews = self.subviews;
    }
    for (UIView *view in subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            if (kDeviceVersion >= 7.0) {
                view.tintColor = kColor(66, 107, 242, 1);
            }
        }
    }
}

@end

@interface LocationViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) CitySearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray *resultArray;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) CityModel *currentCity;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"城市选择";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                               target:self
                                                                               action:@selector(searchCity:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    _resultArray = [[NSMutableArray alloc] init];
    [self initAndLauoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 18 * kScaling)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footerView;
}

- (void)initAndLauoutUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.sectionIndexColor = [UIColor grayColor];
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
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
    _searchBar = [[CitySearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"关键字";
    _searchBar.hidden = YES;
    [self.view addSubview:_searchBar];
    _searchController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchController.delegate = self;
    _searchController.searchResultsTableView.delegate = self;
    _searchController.searchResultsTableView.dataSource = self;
    
    [self getUserLocation];
}

- (void)getUserLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; //控制定位精度,越高耗电量越大。
        _locationManager.distanceFilter = 100; //控制定位服务更新频率。单位是“米”
        [_locationManager startUpdatingLocation];
        //在ios 8.0下要授权
        if (kDeviceVersion >= 8.0)
            [_locationManager requestWhenInUseAuthorization];
    }
}

#pragma mark - Data

- (void)getCurrentCityInfoWithCityName:(NSString *)cityName {
    for (CityModel *model in [CityHandle shareCityList]) {
        if ([cityName containsString:model.cityName]) {
            _currentCity = model;
            break;
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [_tableView beginUpdates];
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableView endUpdates];
}

#pragma mark - Action

- (IBAction)searchCity:(id)sender {
    _searchBar.hidden = NO;
    [_searchBar becomeFirstResponder];
}

- (void)searchResult {
    if (!_searchController.searchResultsTableView.delegate) {
        _searchController.searchResultsTableView.delegate = self;
        _searchController.searchResultsTableView.dataSource = self;
    }
    [_resultArray removeAllObjects];
    for (CityModel *city in [CityHandle shareCityList]) {
        if ([city.cityName containsString:_searchBar.text]) {
            [_resultArray addObject:city];
        }
    }
    [_searchController.searchResultsTableView reloadData];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _searchBar.hidden = YES;
    [_searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchResult];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchResult];
}

#pragma mark - UISearchDisplayDelegate

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    _searchBar.hidden = YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    [tableView setContentInset:UIEdgeInsetsZero];
    [tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _tableView) {
        return [[CityHandle shareIndexList] count] + 1;
    }
    else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableView) {
        if (section == 0) {
            return 1;
        }
        else {
            return [[[CityHandle shareSectionCityList] objectAtIndex:section - 1] count];
        }
    }
    else {
        return [_resultArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableView) {
        static NSString *cellIdentifier = @"CityIdentifier";
        UITableViewCell *cell = nil;
        if (indexPath.section == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            UILabel *currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, cell.bounds.size.height)];
            currentLabel.backgroundColor = [UIColor clearColor];
            currentLabel.font = [UIFont systemFontOfSize:14.f];
            currentLabel.text = @"当前";
            [cell.contentView addSubview:currentLabel];
            UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, cell.bounds.size.height)];
            cityLabel.backgroundColor = [UIColor clearColor];
            cityLabel.font = [UIFont systemFontOfSize:16.f];
            if (_currentCity) {
                cityLabel.text = _currentCity.cityName;
            }
            else {
                cityLabel.text = @"定位失败";
            }
            [cell.contentView addSubview:cityLabel];
            return cell;
        }
        else {
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            CityModel *city = [[[CityHandle shareSectionCityList] objectAtIndex:indexPath.section - 1] objectAtIndex:indexPath.row];
            cell.textLabel.text = city.cityName;
        }
        return cell;
    }
    else {
        static NSString *searchIdentifier = @"searchIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchIdentifier];
        }
        CityModel *city = [_resultArray objectAtIndex:indexPath.row];
        cell.textLabel.text = city.cityName;
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == _tableView) {
        if (section == 0) {
            return nil;
        }
        return [[CityHandle shareIndexList] objectAtIndex:section - 1];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == _tableView) {
        return [CityHandle shareIndexList];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CityModel *selectedCity = nil;
    if (tableView == _tableView) {
        if (indexPath.section != 0) {
            selectedCity = [[[CityHandle shareSectionCityList] objectAtIndex:indexPath.section - 1] objectAtIndex:indexPath.row];
        }
        else {
            selectedCity = _currentCity;
        }
    }
    else {
        [_searchController setActive:NO animated:YES];
        selectedCity = [_resultArray objectAtIndex:indexPath.row];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(getSelectedLocation:)]) {
        [_delegate getSelectedLocation:selectedCity];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 定位

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            if ([placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks lastObject];
                NSString *cityName = placemark.locality;
                [self getCurrentCityInfoWithCityName:cityName];
            }
        }
    }];
}



@end
