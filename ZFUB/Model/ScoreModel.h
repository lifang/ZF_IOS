//
//  ScoreModel.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/2.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

/*积分对象*/
#import <Foundation/Foundation.h>

typedef enum {
    ScoreNone = 0,
    ScoreGain,      //获得积分
    ScoreExpend,    //支出积分
}ScoreType;

@interface ScoreModel : NSObject

@property (nonatomic, strong) NSString *orderNumber;   //订单号

@property (nonatomic, strong) NSString *payedTime;     //交易时间

@property (nonatomic, strong) NSString *score;         //积分

@property (nonatomic, strong) NSString *scoreType;     //积分类型 1.收入 2.支出

@property (nonatomic, strong) NSString *actualPrice;   //实付金额

- (id)initWithParseDictionary:(NSDictionary *)dict;

- (NSString *)tipsString;  //获得、支出

@end
