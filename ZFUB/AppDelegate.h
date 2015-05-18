//
//  AppDelegate.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/22.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

#define UMENG_APPKEY @"553deed667e58eda60000404"

#define kDefaultCityID  @"0"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) RootViewController *rootController;

@property (nonatomic, strong) NSString *cityID;

//登录后返回
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *username;  //用户名

//本地新增购物车数量
@property (nonatomic, assign) int shopcartCount;
//消息数量
@property (nonatomic, assign) int messageCount;

+ (AppDelegate *)shareAppDelegate;

- (void)loginOut;

@end

