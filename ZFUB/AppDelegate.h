//
//  AppDelegate.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/22.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) RootViewController *rootController;

@property (nonatomic, strong) NSString *cityID;

//登录后返回
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *token;

+ (AppDelegate *)shareAppDelegate;

@end

