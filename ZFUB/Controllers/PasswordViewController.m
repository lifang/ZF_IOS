//
//  PasswordViewController.m
//  ZFUB
//
//  Created by wufei on 15/5/11.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "PasswordViewController.h"
#import "SuccessRegisterViewController.h"
#import "NetworkInterface.h"
#import "MBProgressHUD.h"


@interface PasswordViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *phoneLB;

@property (nonatomic, strong) UITextField *pwdTF;

@property (nonatomic, strong) UITextField *confpwdTF;


@property (nonatomic, strong) UIButton *submitBtn;


@property (nonatomic, strong) UITapGestureRecognizer * TAP;

@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"填写登录密码";
   self.view.backgroundColor=[UIColor colorWithHexString:@"f4f3f3"];
    /*
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 20, 44);
    backBtn.titleLabel.font = IconFontWithSize(22);
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitle:@"\U0000e602" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
*/
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:kImageName(@"back.png")
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(backBtnPressed:)];
    self.navigationItem.leftBarButtonItem = leftItem;

    
    
    UILabel *LB=[[UILabel alloc ] init];
    LB.font=FONT16;
    LB.text=@"你的注册手机号";
    LB.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:LB];
    [LB makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(35);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(@25);
    }];
    
    _phoneLB=[[UILabel alloc ] init];
    _phoneLB.font=FONT16;
    _phoneLB.text=_phoneNumber;
    _phoneLB.textColor=[UIColor colorWithHexString:@"fd6a00"];
    _phoneLB.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_phoneLB];
    [_phoneLB makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(LB.bottom).offset(10);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(@25);
    }];
    
    
    
    _pwdTF = [[UITextField alloc] init];
    _pwdTF.delegate = self;
    _pwdTF.textAlignment = NSTextAlignmentLeft;
    _pwdTF.leftViewMode = UITextFieldViewModeAlways;
    _pwdTF.font = FONT15;
    _pwdTF.secureTextEntry=YES;
    _pwdTF.textColor = [UIColor colorWithHexString:@"b5b5b6"];
    UILabel *pwdLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 36)];
    [pwdLB setBackgroundColor:[UIColor clearColor]];
    pwdLB.font = FONT18;
    pwdLB.text = @"填写登录密码";
    pwdLB.textAlignment=NSTextAlignmentCenter;
    pwdLB.textColor = [UIColor colorWithHexString:@"666666"];
    _pwdTF.leftView = pwdLB;
    _pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwdTF.placeholder = @"6～20位数字与字母组成";
    _pwdTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _pwdTF.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:_pwdTF];
    [_pwdTF makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(_phoneLB.bottom).offset(20);
        make.height.equalTo(@50);
    }];
    
    UILabel * line1 = [[UILabel alloc] init];
    [line1 setBackgroundColor:[UIColor colorWithHexString:LineColor]];
    [self.view addSubview:line1];
    [line1 makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_pwdTF.top);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(@1);
    }];
    
    UILabel * line2 = [[UILabel alloc] init];
    [line2 setBackgroundColor:[UIColor colorWithHexString:LineColor]];
    [self.view addSubview:line2];
    [line2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pwdTF.bottom);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(@1);
    }];
    

    _confpwdTF = [[UITextField alloc] init];
    _confpwdTF.delegate = self;
    _confpwdTF.textAlignment = NSTextAlignmentLeft;
    _confpwdTF.leftViewMode = UITextFieldViewModeAlways;
    _confpwdTF.font = FONT15;
    _confpwdTF.secureTextEntry=YES;
    _confpwdTF.textColor = [UIColor colorWithHexString:@"b5b5b6"];
    UILabel *confpwdLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 36)];
    [confpwdLB setBackgroundColor:[UIColor clearColor]];
    confpwdLB.font = FONT18;
    confpwdLB.text = @"确认登录密码";
    confpwdLB.textAlignment=NSTextAlignmentCenter;
    confpwdLB.textColor = [UIColor colorWithHexString:@"666666"];
    _confpwdTF.leftView = confpwdLB;
    _confpwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _confpwdTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _confpwdTF.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:_confpwdTF];
    [_confpwdTF makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(_pwdTF.bottom).offset(1);
        make.height.equalTo(@50);
    }];
    
    UILabel * line3 = [[UILabel alloc] init];
    [line3 setBackgroundColor:[UIColor colorWithHexString:LineColor]];
    [self.view addSubview:line3];
    [line3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_confpwdTF.bottom);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(@1);
    }];
    
    
    _submitBtn = [[UIButton alloc] init];
    _submitBtn.translatesAutoresizingMaskIntoConstraints = NO;
    _submitBtn.layer.cornerRadius = 3;
    _submitBtn.layer.masksToBounds = YES;
    _submitBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_submitBtn setBackgroundImage:[UIImage imageNamed:@"orange.png"] forState:UIControlStateNormal];
    [_submitBtn addTarget:self action:@selector(submitBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitBtn];
    [_submitBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(_confpwdTF.bottom).offset(40);
        make.width.equalTo(@200);
        make.height.equalTo(@40);
    }];
    
    _TAP = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchPressed:)];
    [self.view addGestureRecognizer:_TAP];
    
}


-(void)backBtnPressed:(id)sender
{
    
    // 使用一个UIAlertView来显示用户选中的列表项
   UIAlertView *alertView = [[UIAlertView alloc]
                  initWithTitle:@"不填写登录密码将无法在app上登录"
                  message:[NSString stringWithFormat:@"是否取消注册"]
                  delegate:nil
                  cancelButtonTitle:@"取消注册"
                  otherButtonTitles:@"继续填写", nil];
    alertView.delegate = self;
    [alertView show];
    
    

}

- (void)willPresentAlertView:(UIAlertView *)alertView {
    // 遍历 UIAlertView 所包含的所有控件
    for (UIView *tempView in alertView.subviews) {
        
        if ([tempView isKindOfClass:[UILabel class]]) {
            // 当该控件为一个 UILabel 时
            UILabel *tempLabel = (UILabel *) tempView;
            
            if ([tempLabel.text isEqualToString:alertView.message]) {
                // 调整字体大小
                [tempLabel setFont:[UIFont systemFontOfSize:18.0]];
            }
            if ([tempLabel.text isEqualToString:alertView.title]) {
               
                // 调整字体大小
                [tempLabel setFont:[UIFont systemFontOfSize:14.0]];
            }
        }
    }
}


-(void)submitBtnPressed:(id)sender
{
    
   
    if (!_pwdTF.text || [_pwdTF.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"密码不能位空";
        return;
        
    }
    if ([_pwdTF.text length] < 6) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"密码长度不能少于6位!";
        return;
    }
    if ([_pwdTF.text length] > 20) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"密码长度不能大于20位!";
        return;
    }
    if (![_pwdTF.text isEqualToString:_confpwdTF.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"两次密码不一致!";
        return;
    }

    [self registerWithMobile];



}



-(void) touchPressed:(UITapGestureRecognizer *)t
{
   // CGPoint point  = [t locationInView:self.view];
  
    [BaseApi EndEditing];
        
    
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0)
    {
        //[self.navigationController popViewControllerAnimated:YES];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
}



- (void)registerWithMobile {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在提交...";
    [NetworkInterface registerWithActivation:_codeNumber username:_phoneNumber userPassword:_pwdTF.text cityID:_cityId isEmailRegister:NO finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                [hud hide:YES];
                int errorCode = [[object objectForKey:@"code"] intValue];
                if (errorCode == RequestFail) {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    hud.customView = [[UIImageView alloc] init];
                    hud.mode = MBProgressHUDModeCustomView;
                    [hud hide:YES afterDelay:1.f];
                    hud.labelText = @"注册失败!";
             
                }
                else if (errorCode == RequestSuccess) {
                    NSLog(@"success = %@",[object objectForKey:@"message"]);
                    SuccessRegisterViewController *successRVC=[[SuccessRegisterViewController alloc] init];
                    successRVC.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:successRVC animated:YES];
              
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


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
