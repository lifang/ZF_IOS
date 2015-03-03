//
//  ScoreModel.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/2.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ScoreModel.h"

@implementation ScoreModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _orderNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_number"]];
        _payedTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"payedAt"]];
        _score = [NSString stringWithFormat:@"%@",[dict objectForKey:@"quantity"]];
        _scoreType = [NSString stringWithFormat:@"%@",[dict objectForKey:@"types"]];
        _actualPrice = [NSString stringWithFormat:@"%@",[dict objectForKey:@"actual_price"]];
    }
    return self;
}

- (NSString *)tipsString {
    NSString *tips = nil;
    switch ([_scoreType intValue]) {
        case ScoreGain:
            tips = @"获得  +";
            break;
        case ScoreExpend:
            tips = @"支出  -";
            break;
        default:
            break;
    }
    return tips;
}

@end
