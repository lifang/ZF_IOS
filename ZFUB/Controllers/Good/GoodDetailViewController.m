//
//  GoodDetailViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/26.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "GoodDetailViewController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"

@interface GoodDetailViewController ()

@property (nonatomic, strong) UIScrollView *mainScrollView;

@end

@implementation GoodDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self downloadGoodDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI


#pragma mark - Data

- (void)downloadGoodDetail {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getGoodDetailWithCityID:delegate.cityID goodID:_goodID finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
    }];
}

@end
