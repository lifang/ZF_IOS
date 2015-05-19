//
//  ebankProtocolViewController.m
//  ZFUB
//
//  Created by wufei on 15/5/11.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ebankProtocolViewController.h"
#import "MobClick.h"

@interface ebankProtocolViewController ()


@property (nonatomic, strong) UIWebView *webView;


@end

@implementation ebankProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"用户协议";
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    
    UILabel *titleLB=[[UILabel alloc] init];
    titleLB.font = FONT15;
    titleLB.text=@"华尔街金融平台用户使用协议";
    [self.view addSubview:titleLB];
    [titleLB makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(20);
        make.left.equalTo(self.view.left).offset(20);
        make.right.equalTo(self.view.right).offset(-20);
    }];
    
    UILabel *timeLB=[[UILabel alloc] init];
    timeLB.font = FONT12;
    timeLB.text=@"版本生效时间：2015年5月1日";
    [self.view addSubview:timeLB];
    [timeLB makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLB.bottom).offset(30);
        make.left.equalTo(self.view.left).offset(20);
        make.right.equalTo(self.view.right).offset(-20);
    }];
    
    UILabel * line1 = [[UILabel alloc] init];
    //[line1 setBackgroundColor:[UIColor colorWithHexString:@""]];
    [line1 setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:line1];
    [line1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLB.bottom);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(@1);
    }];
    
    
    _webView = [[UIWebView alloc] init];
    [self.view addSubview:_webView];
    [_webView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(line1.bottom).offset(10);
        make.bottom.equalTo(self.view.mas_bottom);
    }];


    [self loadHTML];
   
    
}



#pragma mark 加载本地html文件
- (void)loadHTML
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ebankProtocol.html" ofType:nil];
    //NSURL *url = [NSURL fileURLWithPath:path];
   // NSLog(@"%@", [self mimeType:url]);
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    [self.webView loadData:data MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nil];
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
