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
#import "AddressManagerController.h"
#import "ModifyViewController.h"

static NSInteger s_firstSectionCount = 6;    ///第一分组列数
static NSInteger s_secondSectionCount = 1;   ///第二分组列数
static NSInteger s_thirdSectionCount = 1;    ///第三分组列数

@interface PersonInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *itemNames;    //我的信息模块名称

@property (nonatomic, strong) UserModel *userInfo;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, strong) NSArray *cityArray;  //pickerView 第二列

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
    [self initPickerView];
}

- (void)initPickerView {
    //pickerView
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 44)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(pickerScrollOut)];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(modifyLocation:)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil
                                                                               action:nil];
    [_toolbar setItems:[NSArray arrayWithObjects:cancelItem,spaceItem,finishItem, nil]];
    [self.view addSubview:_toolbar];
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 216)];
    _pickerView.backgroundColor = kColor(244, 243, 243, 1);
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    [self.view addSubview:_pickerView];
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
            NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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

//修改所在地
- (void)modifyLocationWithCityID:(NSString *)cityID
                        cityName:(NSString *)cityName {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface modifyUserInfoWithToken:delegate.token userID:delegate.userID username:nil mobilePhone:nil email:nil cityID:cityID finished:^(BOOL success, NSData *response) {
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
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                    message:@"用户信息修改成功"
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
                    _userInfo.cityID = cityID;
                    [[NSNotificationCenter defaultCenter] postNotificationName:EditUserInfoNotification object:nil];
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
                  @"用户名",
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
    [_pickerView selectRow:[CityHandle getProvinceIndexWithCityID:_userInfo.cityID] inComponent:0 animated:NO];
    [_pickerView reloadAllComponents];
    [_pickerView selectRow:[CityHandle getCityIndexWithCityID:_userInfo.cityID] inComponent:1 animated:NO];
    [_tableView reloadData];
}

#pragma mark - Action

- (void)signOutAfterDelay {
    [self.tabBarController setSelectedIndex:0];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)signOut:(id)sender {
    [[AppDelegate shareAppDelegate] loginOut];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud hide:YES afterDelay:1.f];
    hud.labelText = @"正在退出...";
    [self performSelector:@selector(signOutAfterDelay) withObject:nil afterDelay:1.f];
}

- (IBAction)modifyLocation:(id)sender {
    [self pickerScrollOut];
    NSInteger index = [_pickerView selectedRowInComponent:1];
    NSString *cityID = [NSString stringWithFormat:@"%@",[[_cityArray objectAtIndex:index] objectForKey:@"id"]];
    NSString *cityName = [[_cityArray objectAtIndex:index] objectForKey:@"name"];
    [self modifyLocationWithCityID:cityID cityName:cityName];
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
                imageName = [NSString stringWithFormat:@"myinfo%ld.png",indexPath.row];
            }
            NSString *detailInfo = nil;
            switch (indexPath.row) {
                case 0: {
                    AppDelegate *delegate = [AppDelegate shareAppDelegate];
                    detailInfo = delegate.username;
                    break;
                }
                case 1:
                    detailInfo = _userInfo.userName;
                    break;
                case 2:
                    detailInfo = _userInfo.phoneNumber;
                    break;
                case 3:
                    detailInfo = _userInfo.email;
                    break;
                case 4:
                    detailInfo = [CityHandle getCityNameWithCityID:_userInfo.cityID];
                    break;
                case 5:
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
                imageName = [NSString stringWithFormat:@"myinfo%ld.png",indexPath.row + s_firstSectionCount];
                cell.detailTextLabel.text = nil;
            }
        }
            break;
        case 2: {
            if (indexPath.row + s_firstSectionCount + s_thirdSectionCount <= [_itemNames count]) {
                titleName = [_itemNames objectAtIndex:indexPath.row + s_firstSectionCount + s_secondSectionCount];
                imageName = [NSString stringWithFormat:@"myinfo%ld.png",indexPath.row + s_firstSectionCount + s_secondSectionCount];
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
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
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
                case 1: {
                    //姓名
                    EditPersonInfoController *editC = [[EditPersonInfoController alloc] init];
                    editC.modifyType = ModifyUsername;
                    editC.userInfo = _userInfo;
                    [self.navigationController pushViewController:editC animated:YES];
                }
                    break;
                case 2: {
                    //手机
                    ModifyViewController *editC = [[ModifyViewController alloc] init];
                    editC.editType = EditViewModify;
                    editC.type = ModifyUserMobile;
                    editC.userInfo = _userInfo;
                    [self.navigationController pushViewController:editC animated:YES];
                }
                    break;
                case 3: {
                    //邮箱
                    ModifyViewController *editC = [[ModifyViewController alloc] init];
                    editC.editType = EditViewModify;
                    editC.type = ModifyUserEmail;
                    editC.userInfo = _userInfo;
                    [self.navigationController pushViewController:editC animated:YES];
                }
                    break;
                case 4: {
                    //所在地
                    [self pickerScrollIn];
                }
                    break;
                case 5: {
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
            if (indexPath.row == 0) {
                AddressManagerController *addressC = [[AddressManagerController alloc] init];
                [self.navigationController pushViewController:addressC animated:YES];
            }
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

#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [[CityHandle shareProvinceList] count];
    }
    else {
        NSInteger provinceIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *provinceDict = [[CityHandle shareProvinceList] objectAtIndex:provinceIndex];
        _cityArray = [provinceDict objectForKey:@"cities"];
        return [_cityArray count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        //省
        NSDictionary *provinceDict = [[CityHandle shareProvinceList] objectAtIndex:row];
        return [provinceDict objectForKey:@"name"];
    }
    else {
        //市
        return [[_cityArray objectAtIndex:row] objectForKey:@"name"];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        //省
        [_pickerView reloadComponent:1];
    }
}

#pragma mark - UIPickerView

- (void)pickerScrollIn {
    [UIView animateWithDuration:.3f animations:^{
        _toolbar.frame = CGRectMake(0, kScreenHeight - 260, kScreenWidth, 44);
        _pickerView.frame = CGRectMake(0, kScreenHeight - 216, kScreenWidth, 216);
    }];
}

- (void)pickerScrollOut {
    [UIView animateWithDuration:.3f animations:^{
        _toolbar.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 44);
        _pickerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216);
    }];
}

@end
