//
//  AppDelegate.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/22.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "AppDelegate.h"
#import "NetworkInterface.h"
#import "TreeDataHandle.h"
#import "RegularFormat.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *)shareAppDelegate {
    return [UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    _rootController = [[RootViewController alloc] init];
    self.window.rootViewController = _rootController;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.window makeKeyAndVisible];
    _cityID = @"1";
    _userID = @"80";
    _token = @"123";
    [self testInterface];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)testInterface {
//    [NetworkInterface sendBuyIntentionWithName:@"我" phoneNumber:@"我我问" content:@"苏州苏州" finished:^(BOOL success, NSData *response) {
//        NSLog(@"!!!!!!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
//    }];
//    [NetworkInterface selectedChannelWithToken:_token finished:^(BOOL success, NSData *response) {
//        NSLog(@"%d,%@",success,[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
//    }];
//    [NetworkInterface selectedBankWithToken:_token finished:^(BOOL success, NSData *response) {
//        NSLog(@"%d,%@",success,[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
//    }];
//    [NetworkInterface selectedMerchantWithToken:_token merchantID:@"19" finished:^(BOOL success, NSData *response) {
//        NSLog(@"%d,%@",success,[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
//    }];
//    [NetworkInterface goodSearchInfoWithCityID:_cityID finished:^(BOOL success,NSData *response) {
//        NSLog(@"%d,%@",success,[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
//    }];
//    [NetworkInterface modifyUserInfoWithUserID:@"8" username:@"123" mobilePhone:@"123" email:@"123@qq.com" cityID:@"1" finished:^(BOOL success, NSData *response) {
//        NSLog(@"%d,%@",success,[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
////    }];
//    [NetworkInterface registerWithActivation:@"L1GDxr" username:@"13964915263" userPassword:@"123456" cityID:@"1" isEmailRegister:NO finished:^(BOOL success, NSData *response) {
//        NSLog(@"!!%d,%@",success,[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
//    }];
//    [NetworkInterface getGoodListWithCityID:@"1" sortType:OrderFilterNone brandID:nil category:nil channelID:nil payCardID:nil tradeID:nil slipID:nil date:nil maxPrice:-1 minPrice:-1 keyword:nil onlyRent:NO page:1 rows:10 finished:^(BOOL success, NSData *response) {
//        NSLog(@"%d,%@",success,[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
//    }];
//    [NetworkInterface getRegisterValidateCodeWithMobileNumber:@"1214" finished:^(BOOL success, NSData *response) {
//        NSLog(@"%d,%@",success,[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
//    }];
}

@end
