//
//  SuccessRegisterViewController.m
//  ZFUB
//
//  Created by wufei on 15/5/11.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "SuccessRegisterViewController.h"

@interface SuccessRegisterViewController ()

@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation SuccessRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"注册成功";
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(nodo:)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    /*
    UILabel *LB=[[UILabel alloc ] init];
    LB.font=FONT18;
    LB.text=@"恭喜你注册成功";
    LB.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:LB];
    [LB makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(35);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(@25);
    }];
     */
    
    UITextField *TF=[[UITextField alloc] init];
    TF.text=@"恭喜你注册成功";
    TF.font=FONT22;
    TF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 36)];
    UIImageView *IMV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    IMV.image = [UIImage imageNamed:@"check_y"];
    [View addSubview:IMV];
    TF.leftView = View;
    TF.leftViewMode = UITextFieldViewModeAlways;
    TF.userInteractionEnabled=NO;
    [self.view addSubview:TF];
    [TF makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(35);
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(@250);
        make.height.equalTo(@40);
    }];
    
    
    UILabel *secondLB = [[UILabel alloc] init];
    [secondLB setBackgroundColor:[UIColor clearColor]];
    secondLB.font = FONT15;
    secondLB.text=@"华尔街金融平台欢迎您的加入";
    secondLB.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:secondLB];
    [secondLB makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(TF.bottom).offset(25);
        make.left.equalTo(self.view.left).offset(5);
        make.right.equalTo(self.view.right).offset(-5);
    }];
    
    UILabel *otherLB = [[UILabel alloc] init];
    [otherLB setBackgroundColor:[UIColor clearColor]];
    otherLB.font = FONT15;
    otherLB.text=@"最优最新的POS终端资源供您挑选";
    otherLB.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:otherLB];
    [otherLB makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondLB.bottom).offset(5);
        make.left.equalTo(self.view.left).offset(5);
        make.right.equalTo(self.view.right).offset(-5);
    }];
    
    
    UILabel *thirdLB = [[UILabel alloc] init];
    [thirdLB setBackgroundColor:[UIColor clearColor]];
    thirdLB.font = FONT15;
   thirdLB.text=@"现在就来选购吧！";
    thirdLB.textAlignment=NSTextAlignmentCenter;
    thirdLB.lineBreakMode = NSLineBreakByCharWrapping;
    [self.view addSubview:thirdLB];
    [thirdLB makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(otherLB.bottom).offset(30);
        make.left.equalTo(self.view.left).offset(50);
        make.right.equalTo(self.view.right).offset(-50);
    }];
    
    
    
    _loginBtn = [[UIButton alloc] init];
    _loginBtn.translatesAutoresizingMaskIntoConstraints = NO;
    _loginBtn.layer.cornerRadius = 3;
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.titleLabel.font = FONT18;
    [_loginBtn setTitle:@"马上登录" forState:UIControlStateNormal];
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"orange.png"] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(loginBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    [_loginBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(thirdLB.bottom).offset(50);
        make.width.equalTo(@200);
        make.height.equalTo(@50);
    }];
    
}

-(void)nodo:(id)sender
{


}

-(void)loginBtnPressed:(id)sender
{
    
   [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
