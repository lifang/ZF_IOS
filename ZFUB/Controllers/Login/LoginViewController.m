//
//  LoginViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/6.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "LoginViewController.h"
#import "FindPasswordViewController.h"
#import "RegisterViewController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "UserArchiveHelper.h"

#import "NewRegisterViewController.h"
#import "BPush.h"



@interface LoginViewController ()<UITextFieldDelegate>

//@property (nonatomic, strong) UITextField *usernameField;

//@property (nonatomic, strong) UITextField *passwordField;

@property (nonatomic, strong) UITextField *userTF;

@property (nonatomic, strong) UITextField *pwdTF;

@property (nonatomic, strong) UITapGestureRecognizer * TAP;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    self.view.backgroundColor=[UIColor whiteColor];
   //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bk"]]];
    
    if (kDeviceVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    /*
     UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
     style:UIBarButtonItemStyleDone
     target:self
     action:@selector(goPervious:)];
     self.navigationItem.leftBarButtonItem = backItem;
     */
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:kImageName(@"back.png")
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(goPervious:)];
    self.navigationItem.leftBarButtonItem = leftItem;

    [self initAndLayoutUI];
    CGFloat topHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    self.primaryPoint = CGPointMake(0, self.view.frame.origin.y + topHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self fillingUser];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidShow:)
                                                name:UIKeyboardDidShowNotification
                                              object:nil];
    //注册通知，监听键盘消失事件
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidHidden)
                                                name:UIKeyboardDidHideNotification
                                              object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - UI

- (void)initAndLayoutUI {
    CGFloat imageSize = 26.f;
    CGFloat leftSpace = 30.f;
    CGFloat rightSpace = 30.f;
    CGFloat textFieldHeight = 44.f;
    
    UIImageView *backgroundView = [[UIImageView alloc] init];
    backgroundView.image = kImageName(@"bkg");
    backgroundView.backgroundColor = [UIColor lightGrayColor];
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:backgroundView];
    [backgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    /*
    UIImageView *loginView = [[UIImageView alloc] init];
    loginView.image = kImageName(@"login_logo.png");
    loginView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:loginView];
    [loginView makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(self.view.mas_top).offset(80);
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(@(self.view.frame.size.width));
        make.bottom.equalTo(self.view.centerY).offset(-60);
        make.height.equalTo(@((self.view.frame.size.height)*0.24));

    }];
    */
    
    //用户名
    _userTF = [[UITextField alloc] init];
    _userTF.translatesAutoresizingMaskIntoConstraints = NO;
    _userTF.layer.cornerRadius=22;
    _userTF.layer.borderWidth=1.0;
    _userTF.layer.borderColor=[UIColor colorWithHexString:@"fd6a00"].CGColor;
    _userTF.layer.masksToBounds = YES;
    _userTF.delegate = self;
    NSMutableAttributedString *usernameString = [[NSMutableAttributedString alloc] initWithString:@"请输入手机/邮箱"];
    _userTF.attributedPlaceholder = usernameString;
    _userTF.font = [UIFont systemFontOfSize:15.f];
    UIView  *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, imageSize)];
    UIImageView *nameIMV = [[UIImageView alloc] initWithFrame:CGRectMake(16, 0, imageSize, imageSize)];
    nameIMV.image = [UIImage imageNamed:@"user_login"];
    [nameView addSubview:nameIMV];
    _userTF.leftView = nameView;
    _userTF.leftViewMode = UITextFieldViewModeAlways;
    _userTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:_userTF];
    [_userTF makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(leftSpace);
        make.right.equalTo(self.view.right).offset(-rightSpace);
        // make.top.equalTo(loginView.bottom).offset(15);
        make.centerY.equalTo(self.view.centerY);
        make.height.equalTo(@(textFieldHeight));
    }];
    
    //密码
    _pwdTF = [[UITextField alloc] init];
    _pwdTF.translatesAutoresizingMaskIntoConstraints = NO;
    _pwdTF.layer.cornerRadius=22;
    _pwdTF.layer.borderWidth=1.0;
    _pwdTF.layer.borderColor=[UIColor colorWithHexString:@"fd6a00"].CGColor;
    _pwdTF.layer.masksToBounds = YES;
    _pwdTF.delegate = self;
    NSMutableAttributedString *passwordString = [[NSMutableAttributedString alloc] initWithString:@"请输入密码"];
    _pwdTF.attributedPlaceholder = passwordString;
    _pwdTF.font = [UIFont systemFontOfSize:15.f];
    _pwdTF.secureTextEntry = YES;
    UIView *pwdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, imageSize)];
    UIImageView *pwdIMV = [[UIImageView alloc] initWithFrame:CGRectMake(16, 0, imageSize, imageSize)];
    pwdIMV.image = [UIImage imageNamed:@"pwd_lock"];
    [pwdView addSubview:pwdIMV];
    _pwdTF.leftView = pwdView;
    _pwdTF.leftViewMode = UITextFieldViewModeAlways;
    _pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwdTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:_pwdTF];
    [_pwdTF makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(leftSpace);
        make.right.equalTo(self.view.right).offset(-rightSpace);
        make.top.equalTo(_userTF.bottom).offset(15);
        make.height.equalTo(@(textFieldHeight));
    }];
    
    
    //登录
    UIButton *signInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signInBtn.translatesAutoresizingMaskIntoConstraints = NO;
    signInBtn.layer.cornerRadius = 20;
    signInBtn.layer.masksToBounds = YES;
    signInBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [signInBtn setTitle:@"登录" forState:UIControlStateNormal];
    [signInBtn setBackgroundImage:[UIImage imageNamed:@"sigIn"] forState:UIControlStateNormal];
    [signInBtn addTarget:self action:@selector(signIn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signInBtn];
    [signInBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(leftSpace);
        make.right.equalTo(self.view.right).offset(-rightSpace);
        make.top.equalTo(_pwdTF.bottom).offset(30);
        make.height.equalTo(@44);
    }];
    
    
    // CGFloat hight=(self.view.frame.size.height-signInBtn.frame.origin.y-signInBtn.frame.size.height)/2.0;
    CGFloat hight=self.view.frame.size.height/20.0;
    
    //忘记密码
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.translatesAutoresizingMaskIntoConstraints = NO;
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [forgetBtn setTitleColor:[UIColor colorWithHexString:@"464748"] forState:UIControlStateNormal];
    [forgetBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [forgetBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateHighlighted];
    [forgetBtn addTarget:self action:@selector(forgetPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    [forgetBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(35);
        // make.bottom.equalTo(self.view.bottom).offset(-48);
        make.bottom.equalTo(self.view.bottom).offset(-hight);
        make.width.equalTo(@60);
        make.height.equalTo(@32);
    }];
    
    
    
    //注册
    UIButton *signUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signUpBtn.translatesAutoresizingMaskIntoConstraints = NO;
    signUpBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [signUpBtn setTitleColor:[UIColor colorWithHexString:@"464748"] forState:UIControlStateNormal];
    [signUpBtn setTitle:@"注册" forState:UIControlStateNormal];
    [signUpBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateHighlighted];
    [signUpBtn addTarget:self action:@selector(signUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signUpBtn];
    [signUpBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.right).offset(-35);
        // make.bottom.equalTo(self.view.bottom).offset(-48);
        make.bottom.equalTo(self.view.bottom).offset(-hight);
        make.width.equalTo(@60);
        make.height.equalTo(@32);
    }];
    
    _TAP = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchPressed:)];
    [self.view addGestureRecognizer:_TAP];
    
    
}

#pragma mark - Data

- (void)login {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在登录...";
    [NetworkInterface loginWithUsername:_userTF.text password:_pwdTF.text isAlreadyEncrypt:NO finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                [hud hide:YES];
                int errorCode = [[object objectForKey:@"code"] intValue];
                if (errorCode == RequestFail) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                    message:[object objectForKey:@"message"]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                else if (errorCode == RequestSuccess) {
                    NSLog(@"%@",object);
                    [self parseLoginDataWithDictionary:object];
                }
            }
            else {
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
}

#pragma mark - Data

- (void)parseLoginDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *infoDict = [dict objectForKey:@"result"];
    NSString *token = @"123";
    NSString *userID = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"id"]];
    NSString *cityID = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"cityId"]];
    [self saveLoginUserWithUserID:userID cityID:cityID];
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    delegate.token = token;
    delegate.userID = userID;
    delegate.username = _userTF.text;
    //绑定推送
    [BPush bindChannel];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Action

- (void)goPervious:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signIn:(id)sender {
    if (!_userTF.text || [_userTF.text isEqualToString:@""] || !_pwdTF.text || [_pwdTF.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"用户名或密码不能为空!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self login];
}

- (void)forgetPassword:(id)sender {
    FindPasswordViewController *findC = [[FindPasswordViewController alloc] init];
    [self.navigationController pushViewController:findC animated:YES];
    // getbackCodeViewController *getbackCVC = [[getbackCodeViewController alloc] init];
    // [self.navigationController pushViewController:getbackCVC animated:YES];
}

- (void)signUp:(id)sender {
    
    // RegisterViewController *registerC = [[RegisterViewController alloc] init];
    NewRegisterViewController *registerC = [[NewRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerC animated:YES];
}

#pragma mark - 数据处理

//初始化完成后查找上次登录的用户
- (void)fillingUser {
    LoginUserModel *user = [UserArchiveHelper getLastestUser];
    if (user) {
        _userTF.text = user.username;
        _pwdTF.text = user.password;
    }
}

//保存登录用户
- (void)saveLoginUserWithUserID:(NSString *)userID
                         cityID:(NSString *)cityID {
    LoginUserModel *user = [[LoginUserModel alloc] init];
    user.username = _userTF.text;
    user.password = _pwdTF.text;
    user.userID = userID;
    user.cityID = cityID;
    [UserArchiveHelper savePasswordForUser:user];
}


-(void) touchPressed:(UITapGestureRecognizer *)t
{
    //CGPoint point  = [t locationInView:self.view];
    
    
    [BaseApi EndEditing];
    
}


#pragma mark - UITextField

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.editingField = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.editingField = nil;
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 键盘

- (void)handleKeyboardDidShow:(NSNotification *)paramNotification {
    //获取键盘高度
    CGRect keyboardRect = [[[paramNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect fieldRect = [[self.editingField superview] convertRect:self.editingField.frame toView:self.view];
    CGFloat topHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat offsetY = keyboardRect.size.height - (kScreenHeight - topHeight - fieldRect.origin.y - fieldRect.size.height);
    if (offsetY > 0 && self.offset == 0) {
        self.offset = offsetY;
        [UIView animateWithDuration:0.3f animations:^{
            self.view.frame = CGRectMake(self.primaryPoint.x, self.primaryPoint.y - offsetY, self.view.bounds.size.width, self.view.bounds.size.height);
        }];
    }
}

- (void)handleKeyboardDidHidden {
    if (self.offset != 0) {
        self.offset = 0;
        [UIView animateWithDuration:0.3f animations:^{
            self.view.frame = CGRectMake(self.primaryPoint.x, self.primaryPoint.y, self.view.bounds.size.width, self.view.bounds.size.height);
        }];
    }
}


/*
#pragma mark - UI

- (void)initAndLayoutUI {
    CGFloat imageSize = 26.f;
    CGFloat leftSpace = 30.f;
    CGFloat rightSpace = 30.f;
    CGFloat textFieldHeight = 44.f;
    
    UIImageView *backgroundView = [[UIImageView alloc] init];
    backgroundView.image = kImageName(@"login_back.png");
    backgroundView.backgroundColor = [UIColor lightGrayColor];
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:backgroundView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.f]];
    
    UIImageView *loginView = [[UIImageView alloc] init];
    loginView.image = kImageName(@"login_logo.png");
    loginView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:loginView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loginView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:80.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loginView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loginView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:180.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loginView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:0.0
                                                           constant:80.f]];
    NSDictionary *textDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIColor whiteColor],NSForegroundColorAttributeName,
                              nil];
    //用户名
    _usernameField = [[UITextField alloc] init];
    _usernameField.translatesAutoresizingMaskIntoConstraints = NO;
    _usernameField.borderStyle = UITextBorderStyleNone;
    _usernameField.background = kImageName(@"login_textback.png");
    _usernameField.delegate = self;
    NSMutableAttributedString *usernameString = [[NSMutableAttributedString alloc] initWithString:@"请输入手机/邮箱"];
    [usernameString addAttributes:textDict range:NSMakeRange(0, [usernameString length])];
    _usernameField.attributedPlaceholder = usernameString;
    _usernameField.font = [UIFont systemFontOfSize:15.f];
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, imageSize)];
    UIImageView *nameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 0, imageSize, imageSize)];
    nameImageView.image = [UIImage imageNamed:@"login_user.png"];
    [nameView addSubview:nameImageView];
    _usernameField.leftView = nameView;
    _usernameField.leftViewMode = UITextFieldViewModeAlways;
    _usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _usernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:_usernameField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_usernameField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_usernameField
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_usernameField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:loginView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:15.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_usernameField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:textFieldHeight]];
    //密码
    _passwordField = [[UITextField alloc] init];
    _passwordField.translatesAutoresizingMaskIntoConstraints = NO;
    _passwordField.borderStyle = UITextBorderStyleNone;
    _passwordField.background = kImageName(@"login_textback.png");
    _passwordField.delegate = self;
    NSMutableAttributedString *passwordString = [[NSMutableAttributedString alloc] initWithString:@"请输入密码"];
    [passwordString addAttributes:textDict range:NSMakeRange(0, [passwordString length])];
    _passwordField.attributedPlaceholder = passwordString;
    _passwordField.font = [UIFont systemFontOfSize:15.f];
    _passwordField.secureTextEntry = YES;
    UIView *passwordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, imageSize)];
    UIImageView *passwordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 0, imageSize, imageSize)];
    passwordImageView.image = [UIImage imageNamed:@"login_pwd.png"];
    [passwordView addSubview:passwordImageView];
    _passwordField.leftView = passwordView;
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:_passwordField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_passwordField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_passwordField
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_passwordField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_usernameField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:5]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_passwordField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:textFieldHeight]];
    //登录
    UIButton *signInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signInBtn.translatesAutoresizingMaskIntoConstraints = NO;
    signInBtn.layer.cornerRadius = 4;
    signInBtn.layer.masksToBounds = YES;
    signInBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [signInBtn setTitle:@"登录" forState:UIControlStateNormal];
    [signInBtn setBackgroundImage:[UIImage imageNamed:@"orange.png"] forState:UIControlStateNormal];
    [signInBtn addTarget:self action:@selector(signIn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signInBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:signInBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_passwordField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:30]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:signInBtn
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:signInBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:160.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:signInBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:0.0
                                                           constant:40]];
    //忘记密码
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.translatesAutoresizingMaskIntoConstraints = NO;
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [forgetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [forgetBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [forgetBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateHighlighted];
    [forgetBtn addTarget:self action:@selector(forgetPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:forgetBtn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:35.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:forgetBtn
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:-35.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:forgetBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:60]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:forgetBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:0.0
                                                           constant:32]];
    //注册
    UIButton *signUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signUpBtn.translatesAutoresizingMaskIntoConstraints = NO;
    signUpBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [signUpBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [signUpBtn setTitle:@"注册" forState:UIControlStateNormal];
    [signUpBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateHighlighted];
    [signUpBtn addTarget:self action:@selector(signUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signUpBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:signUpBtn
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-35.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:signUpBtn
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:-35.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:signUpBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:60]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:signUpBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:0.0
                                                           constant:32.f]];

}

#pragma mark - Data

- (void)login {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在登录...";
    [NetworkInterface loginWithUsername:_usernameField.text password:_passwordField.text isAlreadyEncrypt:NO finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                [hud hide:YES];
                int errorCode = [[object objectForKey:@"code"] intValue];
                if (errorCode == RequestFail) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                    message:[object objectForKey:@"message"]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                else if (errorCode == RequestSuccess) {
                    NSLog(@"%@",object);
                    [self parseLoginDataWithDictionary:object];
                }
            }
            else {
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
}

#pragma mark - Data

- (void)parseLoginDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *infoDict = [dict objectForKey:@"result"];
    NSString *token = @"123";
    NSString *userID = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"id"]];
    NSString *cityID = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"cityId"]];
    [self saveLoginUserWithUserID:userID cityID:cityID];
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    delegate.username = _usernameField.text;
    delegate.token = token;
    delegate.userID = userID;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Action

- (IBAction)goPervious:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signIn:(id)sender {
    if (!_usernameField.text || [_usernameField.text isEqualToString:@""] || !_passwordField.text || [_passwordField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"用户名或密码不能为空!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self login];
}

- (IBAction)forgetPassword:(id)sender {
    FindPasswordViewController *findC = [[FindPasswordViewController alloc] init];
    [self.navigationController pushViewController:findC animated:YES];
}

- (IBAction)signUp:(id)sender {
    RegisterViewController *registerC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerC animated:YES];
}

#pragma mark - 数据处理

//初始化完成后查找上次登录的用户
- (void)fillingUser {
    LoginUserModel *user = [UserArchiveHelper getLastestUser];
    if (user) {
        _usernameField.text = user.username;
        _passwordField.text = user.password;
    }
}

//保存登录用户
- (void)saveLoginUserWithUserID:(NSString *)userID
                         cityID:(NSString *)cityID {
    LoginUserModel *user = [[LoginUserModel alloc] init];
    user.username = _usernameField.text;
    user.password = _passwordField.text;
    user.userID = userID;
    user.cityID = cityID;
    [UserArchiveHelper savePasswordForUser:user];
}

#pragma mark - UITextField

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.editingField = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.editingField = nil;
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 键盘

- (void)handleKeyboardDidShow:(NSNotification *)paramNotification {
    //获取键盘高度
    CGRect keyboardRect = [[[paramNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect fieldRect = [[self.editingField superview] convertRect:self.editingField.frame toView:self.view];
    CGFloat topHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat offsetY = keyboardRect.size.height - (kScreenHeight - topHeight - fieldRect.origin.y - fieldRect.size.height);
    if (offsetY > 0 && self.offset == 0) {
        self.offset = offsetY;
        [UIView animateWithDuration:0.3f animations:^{
            self.view.frame = CGRectMake(self.primaryPoint.x, self.primaryPoint.y - offsetY, self.view.bounds.size.width, self.view.bounds.size.height);
        }];
    }
}

- (void)handleKeyboardDidHidden {
    if (self.offset != 0) {
        self.offset = 0;
        [UIView animateWithDuration:0.3f animations:^{
            self.view.frame = CGRectMake(self.primaryPoint.x, self.primaryPoint.y, self.view.bounds.size.width, self.view.bounds.size.height);
        }];
    }
}
*/

@end
