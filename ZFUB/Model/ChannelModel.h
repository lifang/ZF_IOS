//
//  ChannelModel.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/7.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    GoodRateNone = 0,
    GoodRateDate,      //资金服务费
    GoodRateStand,     //刷卡交易标准手续费
    GoodRateOther,     //其它交易费率
}GoodRateType;

@interface GoodRateModel : NSObject

@property (nonatomic, strong) NSString *rateID;

@property (nonatomic, strong) NSString *rateName;

@property (nonatomic, strong) NSString *ratePercent;

@property (nonatomic, strong) NSString *rateDescription;

- (id)initWithParseDictionary:(NSDictionary *)dict
                     rateType:(GoodRateType)type;

@end

@interface ChannelModel : NSObject
//支付通道id
@property (nonatomic, strong) NSString *channelID;
//支付通道name
@property (nonatomic, strong) NSString *channelName;
//申请开通条件
@property (nonatomic, strong) NSString *openRequirement;
//支付通道开通费用
@property (nonatomic, assign) CGFloat openCost;
//支付通道支持区域
@property (nonatomic, strong) NSMutableArray *supportAreaItem;
//资金服务费
@property (nonatomic, strong) NSMutableArray *dateRateItem;
//标准手续费
@property (nonatomic, strong) NSMutableArray *standRateItem;
//其它交易费
@property (nonatomic, strong) NSMutableArray *otherRateItem;

@property (nonatomic, assign) BOOL canCanceled;

//是否已经加载过详情
@property (nonatomic, assign) BOOL isAlreadyLoad;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
