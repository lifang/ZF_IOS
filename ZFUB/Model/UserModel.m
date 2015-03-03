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
        _cityID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"city_id"]];
        _phoneNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"phone"]];
        _email = [NSString stringWithFormat:@"%@",[dict objectForKey:@"email"]];
        _userName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
        _userScore = [NSString stringWithFormat:@"%@",[dict objectForKey:@"integral"]];
    }
    return self;
}

@end
