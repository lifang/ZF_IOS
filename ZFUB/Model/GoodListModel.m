//
//  GoodListModel.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/11.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "GoodListModel.h"

@implementation GoodListModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _goodID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        _goodName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Title"]];
        _goodBrand = [NSString stringWithFormat:@"%@",[dict objectForKey:@"good_brand"]];
        _goodModel = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Model_number"]];
        _goodChannel = [NSString stringWithFormat:@"%@",[dict objectForKey:@"pay_channe"]];
        _isRent = [[dict objectForKey:@"has_lease"] boolValue];
        _goodPrice = [[dict objectForKey:@"retail_price"] floatValue] / 100;
        _goodScore = [NSString stringWithFormat:@"%@",[dict objectForKey:@"total_score"]];
        _goodImagePath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"url_path"]];
        _goodSaleNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"volume_number"]];
    }
    return self;
}

@end
