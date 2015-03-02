//
//  TerminalDetailController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/28.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "TerminalDetailController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"

@interface TerminalDetailController ()

@end

@implementation TerminalDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"终端详情";
    [self downloadDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

#pragma mark - Request

- (void)downloadDetail {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getTerminalDetailWithToken:delegate.token tmID:@"1" finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
    }];
}

#pragma mark - Data

@end
