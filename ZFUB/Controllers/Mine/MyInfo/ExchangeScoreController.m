//
//  ExchangeScoreController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/2.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ExchangeScoreController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "RegularFormat.h"

@interface ExchangeScoreController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *totalScoreLabel;

@property (nonatomic, strong) UILabel *totalPriceLabel;


@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UITextField *moneyField;

@end

@implementation ExchangeScoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"兑换积分";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(submit:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    headerView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.tableHeaderView = headerView;
    
    _totalScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, kScreenWidth - 15, 20)];
    _totalScoreLabel.backgroundColor = [UIColor clearColor];
    _totalScoreLabel.font = [UIFont boldSystemFontOfSize:18.f];
    _totalScoreLabel.text = [NSString stringWithFormat:@"现有积分：%@",_totalScore];
    [headerView addSubview:_totalScoreLabel];
    
    _totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, kScreenWidth - 15, 20)];
    _totalPriceLabel.backgroundColor = [UIColor clearColor];
    _totalPriceLabel.font = [UIFont systemFontOfSize:14.f];
    _totalPriceLabel.text = [NSString stringWithFormat:@"最高可兑换手续费：￥%.2f",_totalPrice];
    [headerView addSubview:_totalPriceLabel];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(80, 20, kScreenWidth - 160, 40);
    submitBtn.layer.cornerRadius = 4;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"orange.png"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
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
    [self initSubViews];
}

- (void)initSubViews {
    _nameField = [[UITextField alloc] init];
    [self setAttrForTextField:_nameField placeholder:@"请输入姓名，20字符以内"];
    _phoneField = [[UITextField alloc] init];
    [self setAttrForTextField:_phoneField placeholder:@"请输入电话"];
    _moneyField = [[UITextField alloc] init];
    [self setAttrForTextField:_moneyField placeholder:@"请输入兑换金额"];
}

- (void)setAttrForTextField:(UITextField *)textField
                placeholder:(NSString *)placeHolder {
    textField.borderStyle = UITextBorderStyleNone;
    textField.backgroundColor = [UIColor clearColor];
    textField.textAlignment = NSTextAlignmentRight;
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:14.f];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.placeholder = placeHolder;
}

#pragma mark - Request

- (void)exchangeScore {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface exchangeScoreWithToken:delegate.token userID:delegate.userID handlerName:_nameField.text handlerPhoneNumber:_phoneField.text money:[_moneyField.text intValue] finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"兑换成功";
                    //兑换成功发送通知更新积分
                    [[NSNotificationCenter defaultCenter] postNotificationName:ExchangeScoreNotification object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - Action

- (IBAction)submit:(id)sender {
    if (!_nameField.text || [_nameField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写姓名";
        return;
    }
    if (!_phoneField.text || [_phoneField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写联系电话";
        return;
    }
    if (!_moneyField.text || [_moneyField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写兑换金额";
        return;
    }
    if ([RegularFormat stringLength:_nameField.text] > 20) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"姓名长度超过20字符";
        return;
    }
    if (!([RegularFormat isMobileNumber:_phoneField.text] || [RegularFormat isTelephoneNumber:_phoneField.text])) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写正确的电话";
        return;
    }
    if (![RegularFormat isInt:_moneyField.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"兑换金额必须为整数";
        return;
    }
    if ([_moneyField.text intValue] > _totalPrice) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"兑换金额超过最高限度";
        return;
    }
    int money = [_moneyField.text intValue];
    _moneyField.text = [NSString stringWithFormat:@"%d",money];
    [_nameField becomeFirstResponder];
    [_nameField resignFirstResponder];
    [self exchangeScore];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    NSString *titleString = nil;
    switch (indexPath.row) {
        case 0:
            //姓名
            _nameField.frame = CGRectMake(kScreenWidth / 2, 0, kScreenWidth / 2 - 10, cell.contentView.bounds.size.height);
            titleString = @"您的姓名";
            [cell.contentView addSubview:_nameField];
            break;
        case 1:
            //电话
            _phoneField.frame = CGRectMake(kScreenWidth / 2, 0, kScreenWidth / 2 - 10, cell.contentView.bounds.size.height);
            titleString = @"您的联系电话";
            [cell.contentView addSubview:_phoneField];
            break;
        case 2:
            //金额
            _moneyField.frame = CGRectMake(kScreenWidth / 2, 0, kScreenWidth / 2 - 10, cell.contentView.bounds.size.height);
            titleString = @"您要兑换的金额（￥）";
            [cell.contentView addSubview:_moneyField];
            break;
        default:
            break;
    }
    cell.textLabel.text = titleString;
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

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
