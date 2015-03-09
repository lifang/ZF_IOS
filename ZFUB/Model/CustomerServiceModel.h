//
//  CustomerServiceModel.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

/*售后对象*/
#import <Foundation/Foundation.h>
#import "NetworkInterface.h"

//对应于枚举状态为1的样式  CustomerServiceCell
static NSString *firstStatusIdentifier = @"firstStatusIdentifier";
//2
static NSString *secondStatusIdentifier = @"secondStatusIdentifier";
//3
static NSString *thirdStatusIdentifier = @"thirdStatusIdentifier";
//4
static NSString *forthStatusIdentifier = @"forthStatusIdentifier";
//5
static NSString *fifthStatusIdentifier = @"fifthStatusIdentifier";

typedef enum {
    CSStatusNone = 0,
    CSStatusFirst,
    CSStatusSecond,
    CSStatusThird,
    CSStatusForth,
    CSStatusFifth,
}CSStatus;

typedef enum {
    RepairStatusNone = 0,
    RepairStatusUnpaid,      //未付款
    RepairStatusSendBack,    //待发回
    RepairStatusRepairing,   //维修中
    RepairStatusFinished,    //处理完成
    RepairStatusCanceled,    //已取消
}RepairStatus;    //维修状态

/*
typedef enum {
    ReturnStatusNone = 0,
    ReturnStatusPending,     //待处理
    ReturnStatusReturning,   //退货中
    ReturnStatusFinished = 4,    //处理完成
    ReturnStatusCanceled,    //已取消
}ReturnStatus;    //退货状态

typedef enum {
    CancelStatusNone = 0,
    CancelStatusPending,      //待处理
    CancelStatusHandling,     //处理中
    CancelStatusFinished = 4, //处理完成
    CancelStatusCanceled,     //已取消
}CancelStatus;    //注销状态

typedef enum {
    ChangeStatusNone = 0,
    ChangeStatusPending,     //待处理
    ChangeStatusHandling,    //处理中
    ChangeStatusFinished = 4,//处理完成
    ChangeStatusCanceled,    //已取消
}ChangeStatus;    //换货状态

typedef enum {
    UpdateStatusNone = 0,
    UpdateStatusPending,      //待处理
    UpdateStatusHandling,     //处理中
    UpdateStatusFinished = 4, //处理完成
    UpdateStatusCanceled,     //已取消
}UpdateStatus;    //更新资料状态

typedef enum {
    RentStatusNone = 0,
    RentStatusPending,        //待处理
    RentStatusHandling,       //退还中
    RentStatusFinished,       //处理完成
    RentStatusCanceled,       //已取消
}RentStatus;      //租赁退换状态
 */

@interface CustomerServiceModel : NSObject

@property (nonatomic, strong) NSString *csID;

@property (nonatomic, strong) NSString *terminalNum;

@property (nonatomic, strong) NSString *applyNum;

@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSString *createTime;

- (id)initWithParseDictionary:(NSDictionary *)dict;

- (NSString *)getCellIdentifier;

//编号
- (NSString *)getCSNumberPrefixWithCSType:(CSType)csType;

@end
