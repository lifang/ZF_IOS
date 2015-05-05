//
//  PayWayViewController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "UPPayPluginDelegate.h"

typedef enum {
    PayWayFromNone = 0,
    PayWayFromOrder,    //订单跳转
    PayWayFromCart,     //购物车跳转
    PayWayFromGood,     //商品跳转
    PayWayFromCS,       //售后跳转
}PayWayFromType;

//订单、购物车、商品详情、维修记录可跳转此类

@interface PayWayViewController : CommonViewController <UPPayPluginDelegate,UIAlertViewDelegate>

@property (nonatomic, assign) CGFloat totalPrice;

@property (nonatomic, strong) NSString *orderID;

@property (nonatomic, strong) NSString *goodName;

@property (nonatomic, assign) PayWayFromType fromType;  //跳转来源

@end
