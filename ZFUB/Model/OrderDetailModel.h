//
//  OrderDetailModel.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/6.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderGoodModel.h"
#import "OrderModel.h"
#import "RecordModel.h"

@interface OrderDetailModel : NSObject

@property (nonatomic, strong) NSString *orderStatus;         //订单状态

@property (nonatomic, assign) CGFloat orderTotalPrice;     //实付

@property (nonatomic, assign) CGFloat orderDeliveryFee;    //配送费

@property (nonatomic, strong) NSString *orderReceiver;       //收件人

@property (nonatomic, strong) NSString *orderReceiverPhone;  //收件人电话

@property (nonatomic, strong) NSString *orderAddress;        //收件人地址

@property (nonatomic, strong) NSString *orderComment;        //留言

@property (nonatomic, strong) NSString *orderInvoceType;     //发票类型

@property (nonatomic, strong) NSString *orderInvoceTitle;    //发票抬头

@property (nonatomic, strong) NSString *orderNumber;         //订单编号

@property (nonatomic, strong) NSString *orderPayType;        //支付方式

@property (nonatomic, strong) NSString *orderTime;           //订单日期

@property (nonatomic, strong) NSString *orderTotalNumber;    //总数量

@property (nonatomic, strong) NSString *logisticCompany;

@property (nonatomic, strong) NSString *logisticNumber;

@property (nonatomic, strong) NSString *terminals;

@property (nonatomic, assign) int needInvoice;

@property (nonatomic, strong) NSMutableArray *goodList;

@property (nonatomic, strong) NSMutableArray *recordList;

- (id)initWithParseDictionary:(NSDictionary *)dict;

- (NSString *)getStatusString;

@end
