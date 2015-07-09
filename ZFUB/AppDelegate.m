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
#import <AlipaySDK/AlipaySDK.h>

#import "MobClick.h"
#import "APService.h"
#import "BPush.h"
#import "MessageDetailController.h"

#import "UserArchiveHelper.h"

@interface AppDelegate ()<BPushDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation AppDelegate

+ (AppDelegate *)shareAppDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //判断是不是第一次启动应用
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        NSLog(@"第一次启动");
        [self showGuideViewController];
    }
    else
    {
        [self gotoMain];
        
    }
    [self fillingUser];
//    _cityID = @"1";
//    _userID = @"108";
    _cityID = kDefaultCityID;
//    _token = @"123";
    
    //友盟
    // [MobClick startWithAppkey:@"5514cefefd98c59e51000561" reportPolicy:BATCH   channelId:@"App Store"];
    //  友盟的方法本身是异步执行，所以不需要再异步调用
    [self umengTrack];
    
    
    // iOS8 下需要使⽤用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound
        | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    // 在 App 启动时注册百度云推送服务,需要提供 Apikey
    //**********************************
    [BPush registerChannel:launchOptions apiKey:kBaiduAPIKey pushMode:BPushModeDevelopment isDebug:NO];
    // 设置 BPush 的回调
    [BPush setDelegate:self];
    // App 是⽤用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"!!!!%@",userInfo);
        [BPush handleNotification:userInfo];
        [self showNotificationViewWithInfo:userInfo pushLaunch:YES];
    }
    return YES;
}

-(void)showGuideViewController
{

    [NSThread sleepForTimeInterval:3.0];//延长3秒
    
    float wide=[[UIScreen mainScreen] bounds].size.width;
    float high=[[UIScreen mainScreen] bounds].size.height;
    
    
    NSArray *arr=[NSArray arrayWithObjects:@"useriphone1",@"useriphone2",@"useriphone3",@"useriphone4", nil];
    //数组内存放的是我要显示的假引导页面图片
    _scrollView=[[UIScrollView alloc] initWithFrame:self.window.bounds];
    _scrollView.contentSize=CGSizeMake(wide*arr.count, high);
    _scrollView.pagingEnabled=YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor=[UIColor whiteColor];
    //[_GuideView addSubview:scrollView];
    [self.window addSubview:_scrollView];
    for (int i=0; i<arr.count; i++) {
        UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(i*wide, 0, wide, high)];
        img.image=[UIImage imageNamed:arr[i]];
        [_scrollView addSubview:img];
    }
    
    UIButton *useBtn=[[UIButton alloc] init];
    useBtn.frame=CGRectMake(wide*3, 0, wide, high);
    useBtn.backgroundColor=[UIColor clearColor];
    [useBtn addTarget:self action:@selector(useBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:useBtn];


}
-(void)useBtnClick:(id)sender
{
    [_scrollView  removeFromSuperview];
    [self gotoMain];
    

}


-(void)gotoMain
{

    [NSThread sleepForTimeInterval:3.0];//延长3秒
    _rootController = [[RootViewController alloc] init];
    self.window.rootViewController = _rootController;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//   [self.window makeKeyAndVisible];


}

//友盟
- (void)umengTrack {
    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:NO];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

//百度推送*******************************************
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [BPush registerDeviceToken:deviceToken];
//    [BPush bindChannel];
}

// 当 DeviceToken 获取失败时,系统会回调此⽅方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:( NSError *)error {
    NSLog(@"DeviceToken 获取失败,原因:%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // App 收到推送通知
    [BPush handleNotification:userInfo];
    if (application.applicationState == UIApplicationStateActive) {
        //前台
        NSLog(@"active");
        self.messageCount ++;
        NSDictionary *messageDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithInt:self.messageCount],s_messageTab,
                                  nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:ShowColumnNotification object:nil userInfo:messageDict];
    }
    else {
        //后台
        NSLog(@"unactive");
        [self showNotificationViewWithInfo:userInfo pushLaunch:NO];
    }
    [application setApplicationIconBadgeNumber:0];

}

//收到通知弹出到通知界面
- (void)showNotificationViewWithInfo:(NSDictionary *)userInfo pushLaunch:(BOOL)pushLaunch {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    NSString *messageID = @"";
    if ([userInfo objectForKey:@"msgId"] && ![[userInfo objectForKey:@"msgId"] isKindOfClass:[NSNull class]]) {
        messageID = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"msgId"]];
    }
    if (self.userID) {
        MessageDetailController *detailC = [[MessageDetailController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:detailC];
        detailC.messageID = messageID;
        detailC.isFromPush = YES;
        [NavigationBarAttr setNavigationBarStyle:nav];
        [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
    }
    else {
        LoginViewController *loginC = [[LoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginC];
        [NavigationBarAttr setNavigationBarStyle:nav];
        [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
    }
}

- (void)onMethod:(NSString*)method response:(NSDictionary *)data {
    NSLog(@"On method:%@", method);
    NSLog(@"data:%@", [data description]);
    NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
    if ([BPushRequestMethodBind isEqualToString:method]) {
        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        NSLog(@"tttt = %@,%@,%@,%d",appid ,userid, channelid,returnCode);
        if (returnCode == 0) {
            [self uploadPushChannel:channelid];
        }
  
    } else if ([BPushRequestMethodUnbind isEqualToString:method]) {

    }
    
}

//绑定成功向服务端提交信息
- (void)uploadPushChannel:(NSString *)channel {
    NSString *appInfo = [NSString stringWithFormat:@"%d%@",kAppChannel,channel];
    [NetworkInterface uploadPushInfoWithUserID:self.userID channelInfo:appInfo finished:^(BOOL success, NSData *response) {
        NSLog(@"!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
    }];
}

//***************************************************

//- (void)application:(UIApplication *)application  didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    // rootViewController.deviceTokenValueLabel.text =
//    [NSString stringWithFormat:@"%@", deviceToken];
//    // rootViewController.deviceTokenValueLabel.textColor =
//    // [UIColor colorWithRed:0.0 / 255
//    //              green:122.0 / 255
//    //                blue:255.0 / 255
//    //               alpha:1];
//    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
//    [APService registerDeviceToken:deviceToken];
//}
//
//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
//}
//
//#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
//- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:
//(UIUserNotificationSettings *)notificationSettings {
//    
//}
//
//- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier
//forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
//    
//}
//
//
//- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier
//forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
//    
//}
//#endif
//
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//    [APService handleRemoteNotification:userInfo];
//    NSLog(@"收到通知:%@", [self logDic:userInfo]);
//    //[rootViewController addNotificationCount];
//}
//
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//fetchCompletionHandler: (void (^)(UIBackgroundFetchResult))completionHandler {
//    // IOS 7 Support Required
//    [APService handleRemoteNotification:userInfo];
//    NSLog(@"收到通知:%@", [self logDic:userInfo]);
//    // [rootViewController addNotificationCount];
//    
//    completionHandler(UIBackgroundFetchResultNewData);
//}
//
//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
//    [APService showLocalNotificationAtFront:notification identifierKey:nil];
//}
//
//
//// log NSSet with UTF8
//// if not ,log will be \Uxxx
//- (NSString *)logDic:(NSDictionary *)dic {
//    if (![dic count]) {
//        return nil;
//    }
//    NSString *tempStr1 =
//    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
//                                                 withString:@"\\U"];
//    NSString *tempStr2 =
//    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
//    NSString *tempStr3 =
//    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
//    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *str =
//    [NSPropertyListSerialization propertyListFromData:tempData
//                                     mutabilityOption:NSPropertyListImmutable
//                                               format:NULL
//                                     errorDescription:NULL];
//    return str;
//}






- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    NSLog(@"%@",url);
    if ([url.host isEqualToString:@"safepay"]) {
        NSLog(@"!!!");
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            for (NSString *key in resultDic) {
                NSLog(@"%@->%@",key,[resultDic objectForKey:key]);
            }
        }];
    }
    return YES;
}

#pragma mark - 读取数据

//初始化完成后查找上次登录的用户
- (void)fillingUser {
    LoginUserModel *user = [UserArchiveHelper getLastestUser];
    if (user) {
        self.userID = user.userID;
        self.username = user.username;
        if (user.cityID && ![user.cityID isEqualToString:@""]) {
            self.cityID = user.cityID;
        }
    }
}

#pragma mark - 退出

- (void)loginOut {
    [BPush unbindChannel];
    self.userID = @"";
    self.cityID = kDefaultCityID;
    LoginUserModel *user = [UserArchiveHelper getLastestUser];
    if (user) {
        user.password = nil;
        user.cityID = @"";
        user.userID = @"";
        [UserArchiveHelper savePasswordForUser:user];
    }
}

@end
