//
//  OrderGoodModel.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "OrderGoodModel.h"

@implementation OrderGoodModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _goodID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"good_id"]];
        if ([dict objectForKey:@"good_name"]) {
            _goodName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"good_name"]];
        }
        if ([dict objectForKey:@"good_brand"]) {
            _goodBrand = [NSString stringWithFormat:@"%@",[dict objectForKey:@"good_brand"]];
        }
        if ([dict objectForKey:@"good_price"]) {
            _goodPrice = [[dict objectForKey:@"good_price"] floatValue] / 100;
        }
        else if ([dict objectForKey:@"good_actualprice"]) {
            _goodPrice = [[dict objectForKey:@"good_actualprice"] floatValue] / 100;
        }
        if ([dict objectForKey:@"good_channel"]) {
            _goodChannel = [NSString stringWithFormat:@"%@",[dict objectForKey:@"good_channel"]];
        }
        if ([dict objectForKey:@"good_num"]) {
            _goodNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"good_num"]];
        }
        if ([dict objectForKey:@"good_logo"]) {
            _goodPicture = [NSString stringWithFormat:@"%@",[dict objectForKey:@"good_logo"]];
        }
        if ([dict objectForKey:@"good_opening_cost"]) {
            _openCost = [[dict objectForKey:@"good_opening_cost"] floatValue] /100;
        }
    }
    return self;
}

@end
