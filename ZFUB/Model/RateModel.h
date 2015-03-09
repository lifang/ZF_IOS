//
//  RateModel.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/6.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

/*终端管理 表格中的比率*/
#import <Foundation/Foundation.h>

typedef enum {
    RateStatusNone = 0,
    RateStatusOpened,
    RateStatusUnOpened,
}RateStatus;

@interface RateModel : NSObject

@property (nonatomic, strong) NSString *rateID;
@property (nonatomic, strong) NSString *rateName;
@property (nonatomic, strong) NSString *rateService;
@property (nonatomic, strong) NSString *rateTerminal;
@property (nonatomic, strong) NSString *rateBase;
@property (nonatomic, assign) RateStatus rateStatus;

- (id)initWithParseDictionary:(NSDictionary *)dict;

- (NSString *)statusString;

@end
