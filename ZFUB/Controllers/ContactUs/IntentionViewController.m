//
//  IntentionViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/23.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "IntentionViewController.h"
#import "NetworkInterface.h"
#import "RegularFormat.h"

@interface IntentionViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UILabel *placeholderLabel;

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *phoneField;

@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation IntentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"填写购买意向单";
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
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(80, 20, kScreenWidth - 160, 40);
    submitBtn.layer.cornerRadius = 4;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"orange.png"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitComment:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitBtn];
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
    _textView = [[UITextView alloc] init];
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.font = [UIFont systemFontOfSize:16.f];
    
    _placeholderLabel = [[UILabel alloc] init];
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    _placeholderLabel.textColor = kColor(146, 146, 146, 1);
    _placeholderLabel.font = [UIFont systemFontOfSize:16.f];
    _placeholderLabel.text = @"需要我们提供什么";
    
    _nameField = [[UITextField alloc] init];
    _nameField.borderStyle = UITextBorderStyleNone;
    _nameField.textAlignment = NSTextAlignmentRight;
    _nameField.font = [UIFont systemFontOfSize:14.f];
    _nameField.delegate = self;
    _nameField.placeholder = @"先生/女士";
    _nameField.textColor = kColor(108, 108, 108, 1);
    _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    _phoneField = [[UITextField alloc] init];
    _phoneField.borderStyle = UITextBorderStyleNone;
    _phoneField.textAlignment = NSTextAlignmentRight;
    _phoneField.font = [UIFont systemFontOfSize:14.f];
    _phoneField.delegate = self;
    _phoneField.textColor = kColor(108, 108, 108, 1);
    _phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.backgroundColor = [UIColor clearColor];
    _tipLabel.textAlignment = NSTextAlignmentRight;
    _tipLabel.font = [UIFont systemFontOfSize:12.f];
    _tipLabel.text = @"最多填写200个汉字";
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 2;
            break;
        case 1:
            row = 1;
        default:
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    switch (indexPath.section) {
        case 0: {
            CGRect rect = CGRectMake(kScreenWidth - 170, (cell.frame.size.height - 30) / 2, 150, 30);
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            switch (indexPath.row) {
                case 0:
                    _nameField.frame = rect;
                    [cell.contentView addSubview:_nameField];
                    cell.textLabel.text = @"您的称呼";
                    break;
                case 1:
                    _phoneField.frame = rect;
                    [cell.contentView addSubview:_phoneField];
                    cell.textLabel.text = @"您的联系方式";
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: {
            _textView.frame = CGRectMake(0, 0, kScreenWidth, 180);
            _placeholderLabel.frame = CGRectMake(5, 7, kScreenWidth, 20.f);
            [cell.contentView addSubview:_textView];
            [cell.contentView addSubview:_placeholderLabel];
            
            _tipLabel.frame = CGRectMake(20 , 180, kScreenWidth - 30, 20);
            [cell.contentView addSubview:_tipLabel];
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 200.f;
    }
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Action

- (IBAction)submitComment:(id)sender {
    if (!_nameField.text || [_nameField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写姓名";
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
    if (!_phoneField.text || [_phoneField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写联系方式";
        return;
    }
    if (!([RegularFormat isMobileNumber:_phoneField.text] || [RegularFormat isTelephoneNumber:_phoneField.text])) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写正确的联系方式";
        return;
    }
    if (!_textView.text || [_textView.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入内容";
        return;
    }
    if ([_textView.text length] > 200) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"输入内容超过限制";
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface sendBuyIntentionWithName:_nameField.text phoneNumber:_phoneField.text content:_textView.text finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"提交成功";
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

#pragma mark - UITextView

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    else if ([textView.text length] + [text length] > 200 && ![text isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text length] == 0) {
        _placeholderLabel.text = @"需要我们提供什么";
    }
    else {
        _placeholderLabel.text = @"";
    }
    NSInteger number = 200 - [textView.text length];
    if (number < 0) {
        number = 0;
    }
    _tipLabel.text = [NSString stringWithFormat:@"最多填写%ld个文字", number];
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    int stringLength = [RegularFormat stringLength:textField.text] + [RegularFormat stringLength:string];
//    if (stringLength > 20 && ![string isEqualToString:@""]) {
//        return NO;
//    }
//    return YES;
//}

#pragma mark - 键盘

- (void)handleKeyboardDidShow:(NSNotification *)paramNotification {
    //获取键盘高度
    CGRect keyboardRect = [[[paramNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect fieldRect = [[_textView superview] convertRect:_textView.frame toView:self.view];
    CGFloat topHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat offsetY = keyboardRect.size.height + kOffsetKeyboard - (kScreenHeight - topHeight - fieldRect.origin.y - fieldRect.size.height);
    if (offsetY > 0 && self.offset == 0) {
        self.primaryPoint = self.tableView.contentOffset;
        self.offset = offsetY;
        [self.tableView setContentOffset:CGPointMake(0, self.primaryPoint.y + self.offset) animated:YES];
    }
}

- (void)handleKeyboardDidHidden {
    if (self.offset != 0) {
        [self.tableView setContentOffset:CGPointMake(0, self.primaryPoint.y) animated:YES];
        self.offset = 0;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (_textView.isFirstResponder) {
        self.offset = 0;
        [_textView resignFirstResponder];
    }
}

@end
