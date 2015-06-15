//
//  getCodeViewController.m
//  ZFUB
//
//  Created by wufei on 15/5/11.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "getCodeViewController.h"
#import "MBProgressHUD.h"
#import "NetworkInterface.h"
#import "ebankProtocolViewController.h"
#import "PasswordViewController.h"
#import "MobClick.h"


@interface getCodeViewController ()<UITextFieldDelegate>


@property (nonatomic, strong) UILabel *phoneLB;

@property (nonatomic, strong) UITextField *codeTF;

//@property (nonatomic, strong) UILabel *timeLB;

@property (nonatomic, strong) UIButton *timeBtn;

@property (nonatomic, strong) UIButton *submitBtn;

@property (nonatomic, strong) UILabel *emailLB;

@property (nonatomic, strong) UITapGestureRecognizer * TAP;



@end

@implementation getCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"填写手机验证码";
    self.view.backgroundColor=[UIColor colorWithHexString:@"f4f3f3"];
   // [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"layout_bg"]]];
    
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
    LB.font=FONT14;
    LB.text=@"我们已经发送验证码短信到";
    LB.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:LB];
    [LB makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(50);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(@25);
    }];
    
    _phoneLB=[[UILabel alloc ] init];
    _phoneLB.font=FONT14;
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
    
    
    
    _codeTF = [[UITextField alloc] init];
    _codeTF.delegate = self;
    _codeTF.keyboardType = UIKeyboardTypeNumberPad;
    _codeTF.textAlignment = NSTextAlignmentCenter;
    _codeTF.leftViewMode = UITextFieldViewModeAlways;
    _codeTF.font = FONT18;
    _codeTF.textColor = [UIColor colorWithHexString:@"333333"];
    _codeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _codeTF.placeholder = @"请输入验证码";
    _codeTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _codeTF.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _codeTF.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_codeTF];
    [_codeTF makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(_phoneLB.bottom).offset(20);
        make.height.equalTo(@50);
    }];
    
    UILabel * line1 = [[UILabel alloc] init];
    [line1 setBackgroundColor:[UIColor colorWithHexString:LineColor]];
    [self.view addSubview:line1];
    [line1 makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_codeTF.top);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(@1);
    }];
    
    UILabel * line2 = [[UILabel alloc] init];
    [line2 setBackgroundColor:[UIColor colorWithHexString:LineColor]];
    [self.view addSubview:line2];
    [line2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_codeTF.bottom);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(@1);
    }];
    
  
    
    _timeBtn = [[UIButton alloc] init];
    _timeBtn.translatesAutoresizingMaskIntoConstraints = NO;
    _timeBtn.titleLabel.font = FONT14;
    [_timeBtn setTitle:@"接受短信大约需要120秒" forState:UIControlStateNormal];
    [_timeBtn addTarget:self action:@selector(timeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_timeBtn];
    [_timeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(_codeTF.bottom).offset(20);
        make.width.equalTo(@300);
        make.height.equalTo(@40);
    }];
    
    _submitBtn = [[UIButton alloc] init];
    _submitBtn.translatesAutoresizingMaskIntoConstraints = NO;
    _submitBtn.layer.cornerRadius = 10;
    _submitBtn.layer.masksToBounds = YES;
    _submitBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_submitBtn setBackgroundImage:[UIImage imageNamed:@"orange.png"] forState:UIControlStateNormal];
    [_submitBtn addTarget:self action:@selector(submitBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitBtn];
    [_submitBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(_timeBtn.bottom).offset(50);
        make.width.equalTo(@200);
        make.height.equalTo(@40);
    }];
    
    UILabel *proLB=[[UILabel alloc] init];
    proLB.font=FONT14;
    proLB.textColor=[UIColor colorWithHexString:@"a9a9a9"];
    proLB.textAlignment=NSTextAlignmentCenter;
    proLB.text=@"轻触上面的“提交”按钮注册完成，即代表您同意";
    [self.view addSubview:proLB];
    [proLB makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(_submitBtn.bottom).offset(30);
       // make.width.equalTo(@300);
        //make.height.equalTo(@40);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
    }];
    
    UIButton *proBtn=[[UIButton alloc] init];
    proBtn.titleLabel.font = FONT14;
    [proBtn setTitleColor:[UIColor colorWithHexString:@"a9a9a9"] forState:UIControlStateNormal];
    [proBtn setTitle:@"《华尔街金融平台用户协议》" forState:UIControlStateNormal];
    [proBtn addTarget:self action:@selector(proBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:proBtn];
    [proBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(proLB.bottom).offset(5);
        make.width.equalTo(@200);
        make.height.equalTo(@40);
    }];

    /*
    _emailLB=[[UILabel alloc] init];
    _emailLB.font=FONT14;
    _emailLB.text=@"使用邮箱地址注册";
    [self.view addSubview:_emailLB];
    [_emailLB makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.bottom.equalTo(self.view.bottom).offset(50);
        make.width.equalTo(@200);
        make.height.equalTo(@40);
    }];
    */
    
    _TAP = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchPressed:)];
    [self.view addGestureRecognizer:_TAP];
    
     //[self sendMobileValidate];
     [self TimeCountStart];
    
}


-(void)backBtnPressed:(id)sender
{
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"验证码短信可能略有延迟"
                              message:[NSString stringWithFormat:@"确定返回并重新开始注册"]
                              delegate:nil
                              cancelButtonTitle:@"返回"
                              otherButtonTitles:@"等待", nil];
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

-(void)timeBtnPressed:(id)sender
{
    [self sendMobileValidate];
    //[self TimeCountStart];
}

-(void)proBtnPressed:(id)sender
{
    ebankProtocolViewController *ebankPVC=[[ebankProtocolViewController alloc] init];
    ebankPVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:ebankPVC animated:YES];

    
    
}

-(void)submitBtnPressed:(id)sender
{
    if (!_codeTF.text|| [_codeTF.text isEqualToString:@""]) {

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.customView = [[UIImageView alloc] init];
    hud.mode = MBProgressHUDModeCustomView;
    [hud hide:YES afterDelay:1.f];
    hud.labelText = @"验证码不能为空";
    return;
    }
    
    if (![_codeTF.text isEqualToString:_codeNumber]) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"验证码不正确";
        return;
    }
    
    
    PasswordViewController *pwdVC=[[PasswordViewController alloc] init];
    pwdVC.phoneNumber=_phoneNumber;
    pwdVC.codeNumber=_codeTF.text;
    pwdVC.cityId=_cityId;
    pwdVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:pwdVC animated:YES];

}


-(void) touchPressed:(UITapGestureRecognizer *)t
{
    CGPoint point  = [t locationInView:self.view];

    if (CGRectContainsPoint(_emailLB.frame, point)) {
       // NewEmailRegisterViewController *EmailRVC=[[NewEmailRegisterViewController alloc] init];
       // EmailRVC.hidesBottomBarWhenPushed=YES;
       // [self.navigationController pushViewController:EmailRVC animated:YES];
        
    }
    else
    {
    [BaseApi EndEditing];
        
    }
    
}


//倒计时
- (void)TimeCountStart {
    __block int timeout = 120; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){
            //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //UI更新
                _timeBtn.userInteractionEnabled = YES;
                [_timeBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
                [_timeBtn setTitleColor:[UIColor colorWithHexString:@"fd6a00"] forState:UIControlStateNormal];

            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                _timeBtn.userInteractionEnabled = NO;
                NSString *title = [NSString stringWithFormat:@"接受短信大约需要%d秒",timeout];
                [_timeBtn setTitleColor:[UIColor colorWithHexString:@"a9a9a9"] forState:UIControlStateNormal];
                [_timeBtn setTitle:title forState:UIControlStateNormal];
                
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}




#pragma mark - Data

//重新获取验证密码
- (void)sendMobileValidate {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在发送...";
    [NetworkInterface getRegisterValidateCodeWithMobileNumber:_phoneNumber finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == RequestSuccess) {
                    [hud setHidden:YES];
                    _codeNumber = [object objectForKey:@"result"];
                    [self TimeCountStart];
                    
                }
                else {
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                    //[self.navigationController popViewControllerAnimated:YES];
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



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"PageOne"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PageOne"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
