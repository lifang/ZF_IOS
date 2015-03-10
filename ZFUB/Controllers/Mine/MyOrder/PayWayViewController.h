//
//  PayWayViewController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"

//订单和维修记录可跳转此类

@interface PayWayViewController : CommonViewController

@property (nonatomic, strong) NSString *totalPrice;

@property (nonatomic, strong) NSString *orderID;

@end
