//
//  MineViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/23.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "MineViewController.h"
#import "MyOrderViewController.h"
#import "AfterSaleViewController.h"
#import "PersonInfoViewController.h"
#import "MyMerchantViewController.h"
#import "ProgressCheckViewController.h"
#import "SettingViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *itemNames;    //我的子模块名称

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:kImageName(@"setting.png")
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(goSetting:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //初始化静态数据
    [self initStaticData];
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
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *signOut = [UIButton buttonWithType:UIButtonTypeCustom];
    signOut.frame = CGRectMake(80, 20, kScreenWidth - 160, 40);
    signOut.layer.cornerRadius = 4;
    signOut.layer.masksToBounds = YES;
    signOut.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [signOut setTitle:@"退出登录" forState:UIControlStateNormal];
    [signOut setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
    [signOut addTarget:self action:@selector(signOut:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:signOut];
    _tableView.tableFooterView = footerView;
}

- (void)initAndLauoutUI {
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
    
}

#pragma mark - Data

- (void)initStaticData {
    _itemNames = [NSArray arrayWithObjects:
                  @"我的订单",
                  @"售后记录",
                  @"我的信息",
                  @"我的商户",
                  @"申请进度查询",
                  nil];
}

#pragma mark - Action

- (IBAction)goSetting:(id)sender {
    SettingViewController *settingC = [[SettingViewController alloc] init];
    settingC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingC animated:YES];
}

- (IBAction)signOut:(id)sender {
    [[AppDelegate shareAppDelegate] loginOut];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud hide:YES afterDelay:1.f];
    hud.labelText = @"正在退出...";
    [self performSelector:@selector(signOutAfterDelay) withObject:nil afterDelay:1.f];
}

- (void)signOutAfterDelay {
    [self.tabBarController setSelectedIndex:0];
//    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Mine";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.row <= [_itemNames count]) {
        NSString *image = [NSString stringWithFormat:@"mine%ld.png",indexPath.row + 1];
        cell.textLabel.font = [UIFont systemFontOfSize:16.f];
        cell.textLabel.text = [_itemNames objectAtIndex:indexPath.row];
        cell.imageView.image = kImageName(image);
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {
            //我的订单
            MyOrderViewController *orderC = [[MyOrderViewController alloc] init];
            orderC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:orderC animated:YES];
        }
            break;
        case 1: {
            //售后记录
            AfterSaleViewController *afterC = [[AfterSaleViewController alloc] init];
            afterC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:afterC animated:YES];
        }
            break;
        case 2: {
            //我的信息
            PersonInfoViewController *personC = [[PersonInfoViewController alloc] init];
            personC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:personC animated:YES];
        }
            break;
        case 3: {
            //我的商户
            MyMerchantViewController *merchantC = [[MyMerchantViewController alloc] init];
            merchantC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:merchantC animated:YES];
        }
            break;
        case 4: {
            //申请进度查询
            ProgressCheckViewController *progressC = [[ProgressCheckViewController alloc] init];
            progressC.hidesBottomBarWhenPushed = YES;
            [self. navigationController pushViewController:progressC animated:YES];
        }
            break;
        default:
            break;
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

@end
