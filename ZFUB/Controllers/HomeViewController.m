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

@interface HomeViewController ()

@property (nonatomic, strong) PollingView *pollingView;

@end

@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initAndLayoutUI];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[kImageName(@"home_back.png")
                                                                 resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 43, 0)]
                                                  forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
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
    LocationButton *leftButton = [[LocationButton alloc] initWithFrame:CGRectMake(0, 0, kLocationButtonWidth, 40)];
    [leftButton addTarget:self action:@selector(selectLocation:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
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

#pragma mark - Action

- (IBAction)moduleSelected:(id)sender {
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
        }
            break;
        case ModuleManageTerminal: {
            //终端管理
            TerminalManagerController *managerC = [[TerminalManagerController alloc] init];
            managerC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:managerC animated:YES];
        }
            break;
        case ModuletDealFlow: {
            //交易流水
            DealFlowViewController *dealFlowC = [[DealFlowViewController alloc] init];
            dealFlowC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:dealFlowC animated:YES];
        }
            break;
        case ModuleLoan: {
            //我要贷款
        }
            break;
        case ModuleFinancial: {
            //我要理财
        }
            break;
        case ModuleSystemAnnouncement: {
            //系统公告
        }
            break;
        case ModuleContact: {
            //联系我们
        }
            break;
        default:
            break;
    }
}

- (IBAction)selectLocation:(id)sender {
    
}

- (void)tapPicture:(UITapGestureRecognizer *)tap {
    
}


@end
