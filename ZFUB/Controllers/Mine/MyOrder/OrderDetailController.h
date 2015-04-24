//
//  OrderDetailController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/6.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "PayWayViewController.h"

//操作成功后刷新订单列表
static NSString *RefreshMyOrderListNotification = @"RefreshMyOrderListNotification";

@interface OrderDetailController : CommonViewController

@property (nonatomic, strong) NSString *orderID;

@property (nonatomic, strong) NSString *goodName;

@property (nonatomic, assign) PayWayFromType fromType;

@end
