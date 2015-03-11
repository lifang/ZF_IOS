//
//  OrderModel.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

/*订单对象*/
#import <Foundation/Foundation.h>
#import "OrderGoodModel.h"

typedef enum {
    OrderStatusNone = 0,
    OrderStatusUnPaid,    //未付款
    OrderStatusPaid,      //已付款
    OrderStatusSending,   //已发货
    OrderStatusReview,    //已评价
    OrderStatusCancel,    //已取消
    OrderStatusClosed,    //交易关闭
}OrderStatus;

static NSString *unPaidIdentifier = @"unPaidIdentifier";
static NSString *sendingIdentifier = @"sendingIdentifier";
static NSString *otherIdentifier = @"otherIdentifier";

@interface OrderModel : NSObject

@property (nonatomic, strong) NSString *orderID;

@property (nonatomic, strong) NSString *orderTime;

@property (nonatomic, strong) NSString *orderStatus;

@property (nonatomic, strong) NSString *orderNumber;

@property (nonatomic, strong) NSString *orderTotalNum;

@property (nonatomic, assign) CGFloat orderTotalPrice;

@property (nonatomic, assign) CGFloat orderDeliverFee;  //配送费

@property (nonatomic, strong) OrderGoodModel *orderGood;

- (id)initWithParseDictionary:(NSDictionary *)dict;

- (NSString *)getCellIdentifier;

- (NSString *)getStatusString;

@end
