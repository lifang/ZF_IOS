//
//  MyOrderViewController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/7.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

typedef enum {
    OrderStatusNone = 0,
    OrderStatusUnPaid,    //未付款
    OrderStatusSending,   //已发货
    OrderStatusReview,    //已评价
    OrderStatusCancel,    //已取消
    OrderStatusClosed,    //交易关闭
    OrderStatusPaid,      //已付款
}OrderStatus;

#import "CommonViewController.h"

@interface MyOrderViewController : CommonViewController

@end
