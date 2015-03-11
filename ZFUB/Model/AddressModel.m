//
//  AddressModel.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _addressID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"receiver"]) {
            _addressReceiver = [NSString stringWithFormat:@"%@",[dict objectForKey:@"receiver"]];
        }
        if ([dict objectForKey:@"address"]) {
            _address = [NSString stringWithFormat:@"%@",[dict objectForKey:@"address"]];
        }
        if ([dict objectForKey:@"moblephone"]) {
            _addressPhone = [NSString stringWithFormat:@"%@",[dict objectForKey:@"moblephone"]];
        }
        if ([dict objectForKey:@"isDefault"]) {
            _isDefault = [NSString stringWithFormat:@"%@",[dict objectForKey:@"isDefault"]];
        }
        if ([dict objectForKey:@"cityId"]) {
            _cityID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"cityId"]];
        }
        if ([dict objectForKey:@"zipCode"]) {
            _zipCode = [NSString stringWithFormat:@"%@",[dict objectForKey:@"zipCode"]];
        }
    }
    return self;
}

@end
