//
//  AddTerminalController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/28.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "AddTerminalController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "InstitutionModel.h"
#import "InstitutionSelectedController.h"
#import "RegularFormat.h"

@interface AddTerminalController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,InstitutionSelectedDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *organzationField;

@property (nonatomic, strong) UITextField *terminalField;

@property (nonatomic, strong) UITextField *merchantField;

@property (nonatomic,strong) NSMutableArray *institutionItems;  //收单机构

@property (nonatomic, strong) InstitutionModel *selectedModel;

@end

@implementation AddTerminalController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加其它终端";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(submitTerminal:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    _institutionItems = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
    [self downloadAcceptInstitutionData];
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
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(80, 20, kScreenWidth - 160, 40);
    submitBtn.layer.cornerRadius = 4;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"orange.png"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitTerminal:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitBtn];
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
    //输入框
    CGFloat offsetX = 20.0f;
    //收单机构
    _organzationField = [[UITextField alloc] init];
    _organzationField.borderStyle = UITextBorderStyleNone;
    _organzationField.backgroundColor = [UIColor clearColor];
    _organzationField.delegate = self;
    _organzationField.placeholder = @"指定收单机构";
    _organzationField.userInteractionEnabled = NO;
    _organzationField.font = [UIFont systemFontOfSize:15.f];
    UIView *organView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, offsetX, offsetX)];
    _organzationField.leftView = organView;
    _organzationField.leftViewMode = UITextFieldViewModeAlways;
    _organzationField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _organzationField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //终端号
    _terminalField = [[UITextField alloc] init];
    _terminalField.borderStyle = UITextBorderStyleNone;
    _terminalField.backgroundColor = [UIColor clearColor];
    _terminalField.delegate = self;
    _terminalField.placeholder = @"填入终端号";
    _terminalField.font = [UIFont systemFontOfSize:15.f];
    UIView *terminalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, offsetX, offsetX)];
    _terminalField.leftView = terminalView;
    _terminalField.leftViewMode = UITextFieldViewModeAlways;
    _terminalField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _terminalField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //商户
    _merchantField = [[UITextField alloc] init];
    _merchantField.borderStyle = UITextBorderStyleNone;
    _merchantField.backgroundColor = [UIColor clearColor];
    _merchantField.delegate = self;
    _merchantField.placeholder = @"填入商户名称";
    _merchantField.font = [UIFont systemFontOfSize:15.f];
    UIView *merView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, offsetX, offsetX)];
    _merchantField.leftView = merView;
    _merchantField.leftViewMode = UITextFieldViewModeAlways;
    _merchantField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _merchantField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

#pragma mark - Request
//获取收单机构
- (void)downloadAcceptInstitutionData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getCollectionChannelWithToken:delegate.token finished:^(BOOL success, NSData *response) {
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
                    [self parseInstitutionDataWithDictionary:object];
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

- (void)addTerminal {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface addTerminalWithToken:delegate.token userID:delegate.userID institutionID:_selectedModel.ID terminalNumber:_terminalField.text merchantName:_merchantField.text finished:^(BOOL success, NSData *response) {
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
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                    message:@"添加成功"
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
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
//收单机构
- (void)parseInstitutionDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *institutionList = [dict objectForKey:@"result"];
    for (int i = 0; i < [institutionList count]; i++) {
        InstitutionModel *model = [[InstitutionModel alloc] initWithParseDictionary:[institutionList objectAtIndex:i]];
        [_institutionItems addObject:model];
    }
}

#pragma mark - Action

- (IBAction)submitTerminal:(id)sender {
    if (!_selectedModel) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择收单机构";
        return;
    }
    if (!_terminalField.text || [_terminalField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写终端号";
        return;
    }
    if (!_merchantField.text || [_merchantField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写商户名称";
        return;
    }
    if ([RegularFormat stringLength:_merchantField.text] > 20) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"商户名称超过20个字符";
        return;
    }
    [self addTerminal];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    switch (indexPath.section) {
        case 0: {
            //收单机构
            _organzationField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.contentView addSubview:_organzationField];
        }
            break;
        case 1: {
            //终端号
            _terminalField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
            [cell.contentView addSubview:_terminalField];
        }
            break;
        case 2: {
            //商户
            _merchantField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
            [cell.contentView addSubview:_merchantField];
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return 2.f;
    }
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        InstitutionSelectedController *selectedC = [[InstitutionSelectedController alloc] init];
        selectedC.institutionItems = _institutionItems;
        selectedC.delegate = self;
        [self.navigationController pushViewController:selectedC animated:YES];
    }
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - InstitutionSelectedDelegate

- (void)getSelectedInstitution:(InstitutionModel *)model {
    _selectedModel = model;
    _organzationField.text = _selectedModel.name;
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
