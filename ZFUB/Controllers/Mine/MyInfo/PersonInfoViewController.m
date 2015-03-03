//
//  PersonInfoViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/24.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "ModifyPasswordViewController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "UserModel.h"
#import "CityHandle.h"
#import "EditPersonInfoController.h"
#import "ScoreViewController.h"

static NSInteger s_firstSectionCount = 5;    ///第一分组列数
static NSInteger s_secondSectionCount = 1;   ///第二分组列数
static NSInteger s_thirdSectionCount = 1;    ///第三分组列数

@interface PersonInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *itemNames;    //我的信息模块名称

@property (nonatomic, strong) UserModel *userInfo;

@end

@implementation PersonInfoViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的信息";
    
    //初始化静态数据
    [self initStaticData];
    [self initAndLauoutUI];
    
    //加载用户数据
    [self getUserInfo];
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserInfo:) name:EditUserInfoNotification object:nil];
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

#pragma mark - Request 

- (void)getUserInfo {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getUserInfoWithToken:delegate.token userID:delegate.userID finished:^(BOOL success, NSData *response) {
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
                    [self parseUserDataWithDictionary:object];
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

- (void)initStaticData {
    _itemNames = [NSArray arrayWithObjects:
                  @"姓名",
                  @"手机",
                  @"邮箱",
                  @"所在地",
                  @"我的积分",
                  @"地址管理",
                  @"修改密码",
                  nil];
}

- (void)parseUserDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *infoDict = [dict objectForKey:@"result"];
    _userInfo = [[UserModel alloc] initWithParseDictionary:infoDict];
    [_tableView reloadData];
}

#pragma mark - Action

- (IBAction)signOut:(id)sender {
    
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = s_firstSectionCount;
            break;
        case 1:
            row = s_secondSectionCount;
            break;
        case 2:
            row = s_thirdSectionCount;
            break;
        default:
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"My Info";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    NSString *titleName = nil;
    NSString *imageName = nil;
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row <= [_itemNames count]) {
                titleName = [_itemNames objectAtIndex:indexPath.row];
                imageName = [NSString stringWithFormat:@"myinfo%ld.png",indexPath.row + 1];
            }
            NSString *detailInfo = nil;
            switch (indexPath.row) {
                case 0:
                    detailInfo = _userInfo.userName;
                    break;
                case 1:
                    detailInfo = _userInfo.phoneNumber;
                    break;
                case 2:
                    detailInfo = _userInfo.email;
                    break;
                case 3:
                    detailInfo = [CityHandle getCityNameWithCityID:_userInfo.cityID];
                    break;
                case 4:
                    detailInfo = _userInfo.userScore;
                    break;
                default:
                    break;
            }
            cell.detailTextLabel.text = detailInfo;
        }
            break;
        case 1: {
            if (indexPath.row + s_firstSectionCount <= [_itemNames count]) {
                titleName = [_itemNames objectAtIndex:indexPath.row + s_firstSectionCount];
                imageName = [NSString stringWithFormat:@"myinfo%ld.png",indexPath.row + s_firstSectionCount + 1];
                cell.detailTextLabel.text = nil;
            }
        }
            break;
        case 2: {
            if (indexPath.row + s_firstSectionCount + s_thirdSectionCount <= [_itemNames count]) {
                titleName = [_itemNames objectAtIndex:indexPath.row + s_firstSectionCount + s_secondSectionCount];
                imageName = [NSString stringWithFormat:@"myinfo%ld.png",indexPath.row + s_firstSectionCount + s_secondSectionCount + 1];
                cell.detailTextLabel.text = nil;
            }
        }
            break;
        default:
            break;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
    cell.textLabel.text = titleName;
    cell.imageView.image = kImageName(imageName);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 15.f;
    }
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 15.f;
    }
    return 10.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    //姓名
                    EditPersonInfoController *editC = [[EditPersonInfoController alloc] init];
                    editC.modifyType = ModifyUsername;
                    editC.userInfo = _userInfo;
                    [self.navigationController pushViewController:editC animated:YES];
                }
                    break;
                case 1: {
                    //手机
                    EditPersonInfoController *editC = [[EditPersonInfoController alloc] init];
                    editC.modifyType = ModifyPhoneNumber;
                    editC.userInfo = _userInfo;
                    [self.navigationController pushViewController:editC animated:YES];
                }
                    break;
                case 2: {
                    //邮箱
                    EditPersonInfoController *editC = [[EditPersonInfoController alloc] init];
                    editC.modifyType = ModifyEmail;
                    editC.userInfo = _userInfo;
                    [self.navigationController pushViewController:editC animated:YES];
                }
                    break;
                case 3: {
                    //所在地
                }
                    break;
                case 4: {
                    //我的积分
                    ScoreViewController *scoreC = [[ScoreViewController alloc] init];
                    [self.navigationController pushViewController:scoreC animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: {
            //地址管理
        }
            break;
        case 2: {
            //修改密码
            if (indexPath.row == 0) {
                ModifyPasswordViewController *modifyC = [[ModifyPasswordViewController alloc] init];
                [self.navigationController pushViewController:modifyC animated:YES];
            }
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

#pragma mark - NSNotification

- (void)refreshUserInfo:(NSNotification *)notification {
    [_tableView reloadData];
}

@end
