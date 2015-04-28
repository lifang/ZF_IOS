//
//  MyOrderViewController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/7.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"

//操作成功后刷新订单列表
static NSString *RefreshMyOrderListNotification = @"RefreshMyOrderListNotification";

@interface MyOrderViewController : CommonViewController

- (void)firstLoadData;

@end
