//
//  UserModel.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/2.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"city_id"]) {
            _cityID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"city_id"]];
        }
        if ([dict objectForKey:@"phone"]) {
            _phoneNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"phone"]];
        }
        if ([dict objectForKey:@"email"]) {
            _email = [NSString stringWithFormat:@"%@",[dict objectForKey:@"email"]];
        }
        if ([dict objectForKey:@"name"]) {
            _userName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
        }
        if ([dict objectForKey:@"integral"]) {
            _userScore = [NSString stringWithFormat:@"%@",[dict objectForKey:@"integral"]];
        }
    }
    return self;
}

@end
