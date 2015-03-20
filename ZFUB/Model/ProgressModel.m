//
//  ProgressModel.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/17.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ProgressModel.h"

@implementation OpenTypeModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"trade_value"]) {
            _value = [NSString stringWithFormat:@"%@",[dict objectForKey:@"trade_value"]];
        }
        if ([dict objectForKey:@"status"]) {
            _status = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        }
    }
    return self;
}

@end

@implementation ProgressModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"serial_num"]) {
            _terminalNum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"serial_num"]];
        }
        id openStatus = [dict objectForKey:@"openStatus"];
        if ([openStatus isKindOfClass:[NSArray class]]) {
            _openList = [[NSMutableArray alloc] init];
            for (int i = 0; i < [openStatus count]; i++) {
                id openDict = [openStatus objectAtIndex:i];
                if ([openDict isKindOfClass:[NSDictionary class]]) {
                    OpenTypeModel *model = [[OpenTypeModel alloc] initWithParseDictionary:openDict];
                    [_openList addObject:model];
                }
            }
        }
    }
    return self;
}

@end
