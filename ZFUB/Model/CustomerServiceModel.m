//
//  CustomerServiceModel.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CustomerServiceModel.h"

@implementation CustomerServiceModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _csID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        _terminalNum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"terminal_num"]];
        _applyNum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"apply_num"]];
        _status = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        _createTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"create_time"]];
    }
    return self;
}

- (NSString *)getCellIdentifier {
    int index = [_status intValue];
    NSString *cellIdentifier = nil;
    switch (index) {
        case CSStatusFirst:
            cellIdentifier = firstStatusIdentifier;
            break;
        case CSStatusSecond:
            cellIdentifier = secondStatusIdentifier;
            break;
        case CSStatusThird:
            cellIdentifier = thirdStatusIdentifier;
            break;
        case CSStatusForth:
            cellIdentifier = forthStatusIdentifier;
            break;
        case CSStatusFifth:
            cellIdentifier = fifthStatusIdentifier;
            break;
        default:
            break;
    }
    return cellIdentifier;
}

- (NSString *)getCSNumberPrefixWithCSType:(CSType)csType {
    NSString *prefix = nil;
    switch (csType) {
        case CSTypeRepair:
            prefix = @"维修编号：";
            break;
        case CSTypeReturn:
            prefix = @"退货编号：";
            break;
        case CSTypeCancel:
            prefix = @"注销编号：";
            break;
        case CSTypeChange:
            prefix = @"换货编号";
            break;
        case CSTypeUpdate:
            prefix = @"更新资料编号：";
            break;
        case CSTypeLease:
            prefix = @"租赁退还编号：";
            break;
        default:
            break;
    }
    return prefix;
}

@end
