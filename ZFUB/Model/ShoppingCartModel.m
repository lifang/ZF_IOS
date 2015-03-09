
//
//  ShoppingCartModel.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/12.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ShoppingCartModel.h"

@implementation ShoppingCartModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _cartID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        _cartTitle = [NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
        _cartModel = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Model_number"]];
        _cartGoodID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"goodId"]];
        _cartChannel = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
        _cartCount = [[dict objectForKey:@"quantity"] intValue];
        _cartPrice = [[dict objectForKey:@"retail_price"] floatValue] / 100;
        _cartImagePath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"url_path"]];
        _channelCost = [[dict objectForKey:@"opening_cost"] floatValue] / 100;
    }
    return self;
}

@end
