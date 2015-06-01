//
//  HomeViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/23.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "HomeViewController.h"
#import "LocationButton.h"
#import "PollingView.h"
#import "ModuleView.h"
#import "MineViewController.h"
#import "GoodListViewController.h"
#import "DealFlowViewController.h"
#import "TerminalManagerController.h"
#import "OpenApplyController.h"
#import "SystemMessageController.h"
#import "NetworkInterface.h"
#import "HomeImageModel.h"
#import "LocationViewController.h"
#import "ContactUsController.h"
#import "AppDelegate.h"
#import "ChannelWebsiteController.h"
#import "UserArchiveHelper.h"
#import "WaitingViewController.h"

@interface HomeViewController ()<LocationDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) PollingView *pollingView;

@property (nonatomic, strong) NSMutableArray *pictureItem;

@property (nonatomic, strong) LocationButton *locationBtn;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) NSString *updateURL;

@end

@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initAndLayoutUI];
    self.view.backgroundColor = [UIColor whiteColor];
    _pictureItem = [[NSMutableArray alloc] init];
    [self loadHomeImageList];
    [self getUserLocation];
//    [self fillingUser];
    
    [self checkVersion];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[kImageName(@"home_back.png")
                                                                 resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 43, 0)]
                                                  forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[kImageName(@"orange.png")
                                                                 resizableImageWithCapInsets:UIEdgeInsetsMake(21, 1, 21, 1)]
                                                  forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - UI

- (void)initAndLayoutUI {
    //导航栏
    [self initNavigationView];
    //轮询图片
    [self initPollingView];
    //模块按钮
    [self initModuleView];
}

//********导航栏*********
- (void)initNavigationView {
    [self.navigationController.navigationBar setBackgroundImage:[kImageName(@"home_back.png")
                                                                 resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 43, 0)]
                                                  forBarMetrics:UIBarMetricsDefault];
    
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 96, 26)];
    topView.image = kImageName(@"home_logo.png");
    self.navigationItem.titleView = topView;
    
    UIImageView *itemImageView = [[UIImageView alloc] initWithImage:kImageName(@"home_right.png")];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:itemImageView];
    rightItem.tintColor = kColor(165, 139, 106, 1);
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //设置间距
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    spaceItem.width = -8;
    _locationBtn = [[LocationButton alloc] initWithFrame:CGRectMake(0, 0, kLocationButtonWidth, 40)];
    [_locationBtn addTarget:self action:@selector(selectLocation:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_locationBtn];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:spaceItem, leftItem, nil];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                 style:UIBarButtonItemStyleDone
                                                                target:nil
                                                                action:nil];
    self.navigationItem.backBarButtonItem = backItem;
}

//********轮询图片*******
- (void)initPollingView {
    //图片比例 40:17
    _pollingView = [[PollingView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 17 / 40)];
    [self.view addSubview:_pollingView];
}

- (void)initModuleView {
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat statusBarHeight = kDeviceVersion >= 7.0 ? [[UIApplication sharedApplication] statusBarFrame].size.height : 0;
    CGFloat tabbarHeight = self.tabBarController.tabBar.bounds.size.height;
    CGFloat spaceHeight = kScreenHeight - navHeight - statusBarHeight - tabbarHeight - _pollingView.bounds.size.height;
    
    CGFloat moduleHeight = (spaceHeight - kLineHeight * 2) / 3;        //高度
    CGFloat moduleFirstWidth = (kScreenWidth - kLineHeight) / 2;       //第一排宽度
    CGFloat moduleSecondWidth = (kScreenWidth - kLineHeight * 2) / 3;  //后两排宽度
    
    NSArray *nameArray = [NSArray arrayWithObjects:
                          @"选择POS机",
                          @"开通认证",
                          @"终端管理",
                          @"交易流水",
                          @"我要贷款",
                          @"我要理财",
                          @"系统公告",
                          @"联系我们",
                          nil];
    
    CGFloat originY = _pollingView.frame.origin.y + _pollingView.frame.size.height;
    CGRect rect = CGRectMake(0, 0, moduleFirstWidth, moduleHeight);
    for (int i = 0; i < [nameArray count]; i++) {
        if (i < 2) {
            //第一排
            rect.origin.x = (moduleFirstWidth + kLineHeight) * i;
            rect.origin.y = originY;
            rect.size.width = moduleFirstWidth;
        }
        else if (i < 5) {
            //第二排
            rect.origin.x = (moduleSecondWidth + kLineHeight) * (i - 2);
            rect.origin.y = originY + moduleHeight + kLineHeight;
            rect.size.width = moduleSecondWidth;
        }
        else {
            //第三排
            rect.origin.x = (moduleSecondWidth + kLineHeight) * (i - 5);
            rect.origin.y = originY + (moduleHeight + kLineHeight) * 2;
            rect.size.width = moduleSecondWidth;
        }
        ModuleView *moduleView = [ModuleView buttonWithType:UIButtonTypeCustom];
        moduleView.backgroundColor = [UIColor whiteColor];
        moduleView.frame = rect;
        moduleView.tag = i + 1;
        NSString *titleName = [nameArray objectAtIndex:i];
        NSString *imageName = [NSString stringWithFormat:@"module%d.png",i + 1];
        [moduleView setTitleName:titleName imageName:imageName];
        [moduleView addTarget:self action:@selector(moduleSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:moduleView];
    }
    //划线
    CGFloat borderSpace = 10.f;
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(moduleFirstWidth, _pollingView.frame.origin.y + _pollingView.frame.size.height + borderSpace, kLineHeight, moduleHeight - borderSpace)];
    firstLine.backgroundColor = kColor(226, 225, 225, 1);
    [self.view addSubview:firstLine];
    
    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(borderSpace, _pollingView.frame.origin.y + _pollingView.frame.size.height + moduleHeight, kScreenWidth - borderSpace * 2 , kLineHeight)];
    secondLine.backgroundColor = kColor(226, 225, 225, 1);
    [self.view addSubview:secondLine];
    
    UIView *thirdLine = [[UIView alloc] initWithFrame:CGRectMake(borderSpace, _pollingView.frame.origin.y + _pollingView.frame.size.height + moduleHeight * 2 + kLineHeight, kScreenWidth - borderSpace * 2 , kLineHeight)];
    thirdLine.backgroundColor = kColor(226, 225, 225, 1);
    [self.view addSubview:thirdLine];
    
    UIView *forthLine = [[UIView alloc] initWithFrame:CGRectMake(moduleSecondWidth, _pollingView.frame.origin.y + _pollingView.frame.size.height + moduleHeight, kLineHeight , moduleHeight * 2 + kLineHeight - borderSpace)];
    forthLine.backgroundColor = kColor(226, 225, 225, 1);
    [self.view addSubview:forthLine];
    
    UIView *fifthLine = [[UIView alloc] initWithFrame:CGRectMake(moduleSecondWidth * 2 + kLineHeight, _pollingView.frame.origin.y + _pollingView.frame.size.height + moduleHeight, kLineHeight , moduleHeight * 2 + kLineHeight - borderSpace)];
    fifthLine.backgroundColor = kColor(226, 225, 225, 1);
    [self.view addSubview:fifthLine];
}

#pragma mark - Request

- (void)loadHomeImageList {
    [NetworkInterface getHomeImageListFinished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",[object objectForKey:@"code"]];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [self parseImageDataWithDict:object];
                }
            }
        }
    }];
}

#pragma mark - Data

- (void)parseImageDataWithDict:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *imageList = [dict objectForKey:@"result"];
    [_pictureItem removeAllObjects];
    for (int i = 0; i < [imageList count]; i++) {
        id imageDict = [imageList objectAtIndex:i];
        if ([imageDict isKindOfClass:[NSDictionary class]]) {
            HomeImageModel *model = [[HomeImageModel alloc] initWithParseDictionary:imageDict];
            [_pictureItem addObject:model];
        }
    }
    NSMutableArray *urlList = [[NSMutableArray alloc] init];
    for (HomeImageModel *model in _pictureItem) {
        [urlList addObject:model.pictureURL];
    }
    [_pollingView downloadImageWithURLs:urlList target:self action:@selector(tapPicture:) scaleImage:YES];
}

#pragma mark - Action

- (IBAction)moduleSelected:(id)sender {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    ModuleView *moduleView = (ModuleView *)sender;
    switch (moduleView.tag) {
        case ModuleBuyPOS: {
            //选择POS机
            GoodListViewController *listC = [[GoodListViewController alloc] init];
            listC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:listC animated:YES];
        }
            break;
        case ModuleAuthentication: {
            //开通认证
            if (!delegate.userID || [delegate.userID isEqualToString:@""]) {
                [self showLoginViewController];
                return;
            }
            OpenApplyController *applyC = [[OpenApplyController alloc] init];
            applyC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:applyC animated:YES];
        }
            break;
        case ModuleManageTerminal: {
            //终端管理
            if (!delegate.userID || [delegate.userID isEqualToString:@""]) {
                [self showLoginViewController];
                return;
            }
            TerminalManagerController *managerC = [[TerminalManagerController alloc] init];
            managerC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:managerC animated:YES];
        }
            break;
        case ModuletDealFlow: {
            //交易流水
            if (!delegate.userID || [delegate.userID isEqualToString:@""]) {
                [self showLoginViewController];
                return;
            }
            DealFlowViewController *dealFlowC = [[DealFlowViewController alloc] init];
            dealFlowC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:dealFlowC animated:YES];
        }
            break;
        case ModuleLoan: {
            //我要贷款
            WaitingViewController *waitC = [[WaitingViewController alloc] init];
            waitC.hidesBottomBarWhenPushed = YES;
            waitC.title = @"我要贷款";
            [self.navigationController pushViewController:waitC animated:YES];
        }
            break;
        case ModuleFinancial: {
            //我要理财
            WaitingViewController *waitC = [[WaitingViewController alloc] init];
            waitC.hidesBottomBarWhenPushed = YES;
            waitC.title = @"我要理财";
            [self.navigationController pushViewController:waitC animated:YES];
        }
            break;
        case ModuleSystemAnnouncement: {
            //系统公告
            SystemMessageController *systemC = [[SystemMessageController alloc] init];
            systemC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:systemC animated:YES];
        }
            break;
        case ModuleContact: {
            //联系我们
            ContactUsController *contactC = [[ContactUsController alloc] init];
            contactC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:contactC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (IBAction)selectLocation:(id)sender {
    LocationViewController *locationC = [[LocationViewController alloc] init];
    locationC.delegate = self;
    locationC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:locationC animated:YES];
}

- (void)tapPicture:(UITapGestureRecognizer *)tap {
//    UIImageView *imageView = (UIImageView *)[tap view];
//    NSInteger index = imageView.tag - 1;
//    ChannelWebsiteController *websiteC = [[ChannelWebsiteController alloc] init];
//    if (index >= 0 && index < [_pictureItem count]) {
//        HomeImageModel *imageModel = [_pictureItem objectAtIndex:index];
//        websiteC.title = @"详情";
//        websiteC.urlString = imageModel.websiteURL;
//        websiteC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:websiteC animated:YES];
//    }
}

#pragma mark - 数据处理

//初始化完成后查找上次登录的用户
- (void)fillingUser {
    LoginUserModel *user = [UserArchiveHelper getLastestUser];
    if (user) {
        AppDelegate *delegate = [AppDelegate shareAppDelegate];
        delegate.userID = user.userID;
        delegate.username = user.username;
        if (user.cityID && ![user.cityID isEqualToString:@""]) {
            delegate.cityID = user.cityID;
        }
    }
}

#pragma mark - 定位

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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            if ([placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks lastObject];
                NSString *cityName = placemark.locality;
                [self getCurrentCityInfoWithCityName:cityName];
                [_locationManager stopUpdatingLocation];
            }
        }
    }];
}

- (void)getCurrentCityInfoWithCityName:(NSString *)cityName {
    NSLog(@"location = %@",cityName);
    CityModel *currentCity = nil;
    for (CityModel *model in [CityHandle shareCityList]) {
        if ([cityName rangeOfString:model.cityName].length != 0) {
            currentCity = model;
            break;
        }
    }
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    if (currentCity) {
        _locationBtn.nameLabel.text = currentCity.cityName;
        delegate.cityID = currentCity.cityID;
    }
    else {
        _locationBtn.nameLabel.text = @"定位失败";
        delegate.cityID = kDefaultCityID;
    }
}

- (void)getSelectedLocation:(CityModel *)selectedCity {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    if (selectedCity) {
        _locationBtn.nameLabel.text = selectedCity.cityName;
        delegate.cityID = selectedCity.cityID;
    }
    else {
        _locationBtn.nameLabel.text = @"定位失败";
        delegate.cityID = kDefaultCityID;
    }
}


#pragma mark - Request

- (void)checkVersion {
   
    [NetworkInterface checkVersionFinished:^(BOOL success, NSData *response) {
       
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                int errorCode = [[object objectForKey:@"code"] intValue];
                if (errorCode == RequestSuccess) {
                    NSLog(@"shuju:%@",object);
                    id infoDict = [object objectForKey:@"result"];
                    if ([infoDict isKindOfClass:[NSDictionary class]]) {
                        int serviceVersion = [[infoDict objectForKey:@"versions"] intValue];
                        _updateURL = [infoDict objectForKey:@"down_url"];
                        NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
                        
                        NSLog(@"local:%@",localVersion);
                        if (serviceVersion > [localVersion intValue]) {
                            
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                                message:@"发现新版本，是否前往下载？"
                                                                               delegate:self
                                                                      cancelButtonTitle:@"取消"
                                                                      otherButtonTitles:@"前往下载", nil];
                            [alertView show];
                        }
                        
                    }
                }
            }
        }
    }];
}


#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_updateURL]];
    }
}


@end
