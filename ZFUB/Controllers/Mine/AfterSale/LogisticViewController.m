//
//  LogisticViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "LogisticViewController.h"
#import "AppDelegate.h"
#import "CSDetailViewController.h"
#import "CustomerServiceController.h"

@interface LogisticViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *companyField;
@property (nonatomic, strong) UITextField *numberField;

@end

@implementation LogisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"物流信息";
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
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
    [submitBtn addTarget:self action:@selector(submitLogistic:) forControlEvents:UIControlEventTouchUpInside];
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
    
    _companyField = [[UITextField alloc] init];
    _companyField.delegate = self;
    _companyField.placeholder = @"请输入物流信息";
    _companyField.textAlignment = NSTextAlignmentRight;
    _companyField.font = [UIFont systemFontOfSize:15.f];
    _companyField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _numberField = [[UITextField alloc] init];
    _numberField.delegate = self;
    _numberField.placeholder = @"请输入物流单号";
    _numberField.textAlignment = NSTextAlignmentRight;
    _numberField.font = [UIFont systemFontOfSize:15.f];
    _numberField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    CGRect rect = CGRectMake(80, 0, kScreenWidth - 90, cell.bounds.size.height);
    switch (indexPath.row) {
        case 0: {
            cell.textLabel.text = @"物流公司";
            _companyField.frame = rect;
            [cell.contentView addSubview:_companyField];
        }
            break;
        case 1: {
            cell.textLabel.text = @"物流单号";
            _numberField.frame = rect;
            [cell.contentView addSubview:_numberField];
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Request

- (void)submitLogisticInfo {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface csLogisticWithToken:delegate.token userID:delegate.userID csID:_csID csType:_csType logisticCompany:_companyField.text logisticNumber:_numberField.text finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
                    hud.labelText = @"提交物流信息成功";
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshCSListNotification object:nil];
                    UIViewController *csListC = nil;
                    for (UIViewController *controller in self.navigationController.childViewControllers) {
                        if ([controller isKindOfClass:[CustomerServiceController class]]) {
                            csListC = controller;
                            break;
                        }
                    }
                    if (csListC) {
                        [self.navigationController popToViewController:csListC animated:YES];
                    }
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

- (IBAction)submitLogistic:(id)sender {
    if (!_companyField.text || [_companyField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入物流公司";
        return;
    }
    if (!_numberField.text || [_numberField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入物流单号";
        return;
    }
    [self submitLogisticInfo];
}

@end
