//
//  EditMerchantController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/5.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "EditMerchantController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"

@interface EditMerchantController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *editField;

@end

@implementation EditMerchantController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改信息";
    [self initAndLayoutUI];
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
    [submitBtn addTarget:self action:@selector(submitUserInfo:) forControlEvents:UIControlEventTouchUpInside];
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
    //输入框
    _editField = [[UITextField alloc] init];
    _editField.borderStyle = UITextBorderStyleNone;
    _editField.backgroundColor = [UIColor clearColor];
    _editField.delegate = self;
    _editField.font = [UIFont systemFontOfSize:15.f];
    UIView *editView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, offsetX, offsetX)];
    _editField.leftView = editView;
    _editField.leftViewMode = UITextFieldViewModeAlways;
    _editField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _editField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_editField becomeFirstResponder];
    [self setPrimaryData];
}

#pragma mark - Request

- (void)modifyUserInfo {
    MerchantDetailModel *modifyModel = [self newMerchantInfo];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface modifyMerchantWithToken:delegate.token merchantDetail:modifyModel finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"修改商户成功";
                    [self updateMerchant:modifyModel];
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:EditMerchantInfoNotification object:nil];
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

- (void)setPrimaryData {
    switch (_editType) {
        case MerchantEditName:
            _editField.text = _merchant.merchantName;
            break;
        case MerchantEditPersonName:
            _editField.text = _merchant.merchantPersonName;
            break;
        case MerchantEditPersonID:
            _editField.text = _merchant.merchantPersonID;
            break;
        case MerchantEditLicense:
            _editField.text = _merchant.merchantBusinessID;
            break;
        case MerchantEditTax:
            _editField.text = _merchant.merchantTaxID;
            break;
        case MerchantEditOrganization:
            _editField.text = _merchant.merchantOrganizationID;
            break;
        case MerchantEditBank:
            _editField.text = _merchant.merchantBank;
            break;
        case MerchantEditBankID:
            _editField.text = _merchant.merchantBankID;
        default:
            break;
    }
}

- (MerchantDetailModel *)newMerchantInfo {
    MerchantDetailModel *model = [[MerchantDetailModel alloc] init];
    model.merchantID = _merchant.merchantID;
    switch (_editType) {
        case MerchantEditName:
            model.merchantName = _editField.text;
            break;
        case MerchantEditPersonName:
            model.merchantPersonName = _editField.text;
            break;
        case MerchantEditPersonID:
            model.merchantPersonID = _editField.text;
            break;
        case MerchantEditLicense:
            model.merchantBusinessID = _editField.text;
            break;
        case MerchantEditTax:
            model.merchantTaxID = _editField.text;
            break;
        case MerchantEditOrganization:
            model.merchantOrganizationID = _editField.text;
            break;
        case MerchantEditBank:
            model.merchantBank = _editField.text;
            break;
        case MerchantEditBankID:
            model.merchantBankID = _editField.text;
        default:
            break;
    }
    return model;
}

- (void)updateMerchant:(MerchantDetailModel *)model {
    switch (_editType) {
        case MerchantEditName:
            _merchant.merchantName = model.merchantName;
            break;
        case MerchantEditPersonName:
            _merchant.merchantPersonName = model.merchantPersonName;
            break;
        case MerchantEditPersonID:
            _merchant.merchantPersonID = model.merchantPersonID;
            break;
        case MerchantEditLicense:
            _merchant.merchantBusinessID = model.merchantBusinessID;
            break;
        case MerchantEditTax:
            _merchant.merchantTaxID = model.merchantTaxID;
            break;
        case MerchantEditOrganization:
            _merchant.merchantOrganizationID = model.merchantOrganizationID;
            break;
        case MerchantEditBank:
            _merchant.merchantBank = model.merchantBank;
            break;
        case MerchantEditBankID:
            _merchant.merchantBankID = model.merchantBankID;
        default:
            break;
    }
}

#pragma mark - Action

- (IBAction)submitUserInfo:(id)sender {
    if (!_editField.text || [_editField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"修改信息不能为空";
        return;
    }
    [_editField becomeFirstResponder];
    [_editField resignFirstResponder];
    [self modifyUserInfo];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    switch (indexPath.section) {
        case 0: {
            //输入框
            _editField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
            [cell.contentView addSubview:_editField];
            break;
        }
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

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
