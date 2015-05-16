//
//  RootViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/23.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "RootViewController.h"

#import "HomeViewController.h"
#import "ShoppingCartController.h"
#import "MessageViewController.h"
#import "MineViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "NavigationBarAttr.h"


@interface RootViewController ()

@property (nonatomic, strong) ShoppingCartController *shoppingC;
@property (nonatomic, strong) MessageViewController *messageC;

@end

@implementation RootViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initControllers];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showColumnCount:)
                                                 name:ShowColumnNotification
                                               object:nil];

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Controllers

- (void)initControllers {
    self.delegate = self;
    HomeViewController *homeC = [[HomeViewController alloc] init];
    homeC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页"
                                                     image:kImageName(@"tabbar1.png")
                                             selectedImage:kImageName(@"tabbar1_selected.png")];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeC];
    
    _shoppingC = [[ShoppingCartController alloc] init];
    _shoppingC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"购物车"
                                                         image:kImageName(@"tabbar2.png")
                                                 selectedImage:kImageName(@"tabbar2_selected.png")];
    UINavigationController *shoppingNav = [[UINavigationController alloc] initWithRootViewController:_shoppingC];
    
    _messageC = [[MessageViewController alloc] init];
    _messageC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的消息"
                                                        image:kImageName(@"tabbar3.png")
                                                selectedImage:kImageName(@"tabbar3_selected.png")];
    UINavigationController *messageNav = [[UINavigationController alloc] initWithRootViewController:_messageC];
    
    MineViewController *mineC = [[MineViewController alloc] init];
    mineC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的"
                                                     image:kImageName(@"tabbar4.png")
                                             selectedImage:kImageName(@"tabbar4_selected.png")];
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:mineC];
    
    [NavigationBarAttr setNavigationBarStyle:homeNav];
    [NavigationBarAttr setNavigationBarStyle:shoppingNav];
    [NavigationBarAttr setNavigationBarStyle:messageNav];
    [NavigationBarAttr setNavigationBarStyle:mineNav];
    
    self.tabBar.tintColor = kColor(255, 102, 36, 1);
    self.tabBar.selectionIndicatorImage = kImageName(@"tabbar_line.png");
    self.viewControllers = [NSArray arrayWithObjects:homeNav,shoppingNav,messageNav,mineNav, nil];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    UIViewController *controller = [viewController.childViewControllers firstObject];
    if ([controller isMemberOfClass:[ShoppingCartController class]] ||
        [controller isMemberOfClass:[MessageViewController class]] ||
         [controller isMemberOfClass:[MineViewController class]]) {
        if (!delegate.userID || [delegate.userID isEqualToString:@""]) {
            LoginViewController *loginC = [[LoginViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginC];
            [NavigationBarAttr setNavigationBarStyle:nav];
            [self presentViewController:nav animated:YES completion:nil];
            return NO;
        }
        return YES;
    }
    return YES;
}

#pragma mark - NSNotification

- (void)showColumnCount:(NSNotification *)notification {
    int shopcartCount = [[notification.userInfo objectForKey:s_shopcart] intValue];
    int messageCount = [[notification.userInfo objectForKey:s_messageTab] intValue];
    if (shopcartCount > 0) {
        _shoppingC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",shopcartCount];
    }
    else {
        _messageC.tabBarItem.badgeValue = nil;
    }
    if (messageCount > 0) {
        _messageC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",messageCount];
    }
    else {
        _messageC.tabBarItem.badgeValue = nil;
    }
}

@end
