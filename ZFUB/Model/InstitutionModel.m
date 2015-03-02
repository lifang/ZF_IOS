//
//  InstitutionModel.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/28.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "InstitutionModel.h"

@implementation InstitutionModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        _name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
    }
    return self;
}

@end
