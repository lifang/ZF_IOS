//
//  CustomerServiceHandle.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CustomerServiceHandle.h"

@implementation CustomerServiceHandle

+ (NSString *)titleForCSType:(CSType)csType {
    NSString *title = nil;
    switch (csType) {
        case CSTypeRepair:
            title = @"维修记录";
            break;
        case CSTypeReturn:
            title = @"退货记录";
            break;
        case CSTypeCancel:
            title = @"注销记录";
            break;
        case CSTypeChange:
            title = @"换货记录";
            break;
        case CSTypeUpdate:
            title = @"更新资料记录";
            break;
        case CSTypeLease:
            title = @"租赁退还记录";
            break;
        default:
            break;
    }
    return title;
}

+ (NSString *)titleForDetailWithCSType:(CSType)csType {
    NSString *title = nil;
    switch (csType) {
        case CSTypeRepair:
            title = @"维修详情";
            break;
        case CSTypeReturn:
            title = @"退货详情";
            break;
        case CSTypeCancel:
            title = @"注销详情";
            break;
        case CSTypeChange:
            title = @"换货详情";
            break;
        case CSTypeUpdate:
            title = @"更新资料详情";
            break;
        case CSTypeLease:
            title = @"租赁退还详情";
            break;
        default:
            break;
    }
    return title;
}

+ (NSString *)getStatusStringWithCSType:(CSType)csType
                                 status:(NSString *)status {
    NSString *statuString = nil;
    switch (csType) {
        case CSTypeRepair:
            statuString = [[self class] repairStatusStringWithStauts:status];
            break;
        case CSTypeReturn:
            statuString = [[self class] returnStatusStringWithStauts:status];
            break;
        case CSTypeCancel:
            statuString = [[self class] cancelStatusStringWithStauts:status];
            break;
        case CSTypeChange:
            statuString = [[self class] changeStatusStringWithStauts:status];
            break;
        case CSTypeUpdate:
            statuString = [[self class] updateStatusStringWithStauts:status];
            break;
        case CSTypeLease:
            statuString = [[self class] rentStatusStringWithStauts:status];
            break;
        default:
            break;
    }
    return statuString;
}

+ (NSString *)repairStatusStringWithStauts:(NSString *)statusString {
    NSString *status = nil;
    switch ([statusString intValue]) {
        case CSStatusFirst:
            status = @"未付款";
            break;
        case CSStatusSecond:
            status = @"待发回";
            break;
        case CSStatusThird:
            status = @"维修中";
            break;
        case CSStatusForth:
            status = @"处理完成";
            break;
        case CSStatusFifth:
            status = @"已取消";
            break;
        default:
            break;
    }
    return status;
}

+ (NSString *)returnStatusStringWithStauts:(NSString *)statusString {
    NSString *status = nil;
    switch ([statusString intValue]) {
        case CSStatusFirst:
            status = @"待处理";
            break;
        case CSStatusSecond:
            status = @"退货中";
            break;
        case CSStatusThird:
            break;
        case CSStatusForth:
            status = @"处理完成";
            break;
        case CSStatusFifth:
            status = @"已取消";
            break;
        default:
            break;
    }
    return status;
}

+ (NSString *)cancelStatusStringWithStauts:(NSString *)statusString {
    NSString *status = nil;
    switch ([statusString intValue]) {
        case CSStatusFirst:
            status = @"待处理";
            break;
        case CSStatusSecond:
            status = @"处理中";
            break;
        case CSStatusThird:
            break;
        case CSStatusForth:
            status = @"处理完成";
            break;
        case CSStatusFifth:
            status = @"已取消";
            break;
        default:
            break;
    }
    return status;
}

+ (NSString *)changeStatusStringWithStauts:(NSString *)statusString {
    NSString *status = nil;
    switch ([statusString intValue]) {
        case CSStatusFirst:
            status = @"待处理";
            break;
        case CSStatusSecond:
            status = @"换货中";
            break;
        case CSStatusThird:
            break;
        case CSStatusForth:
            status = @"处理完成";
            break;
        case CSStatusFifth:
            status = @"已取消";
            break;
        default:
            break;
    }
    return status;
}

+ (NSString *)updateStatusStringWithStauts:(NSString *)statusString {
    NSString *status = nil;
    switch ([statusString intValue]) {
        case CSStatusFirst:
            status = @"待处理";
            break;
        case CSStatusSecond:
            status = @"处理中";
            break;
        case CSStatusThird:
            break;
        case CSStatusForth:
            status = @"处理完成";
            break;
        case CSStatusFifth:
            status = @"已取消";
            break;
        default:
            break;
    }
    return status;
}

+ (NSString *)rentStatusStringWithStauts:(NSString *)statusString {
    NSString *status = nil;
    switch ([statusString intValue]) {
        case CSStatusFirst:
            status = @"待处理";
            break;
        case CSStatusSecond:
            status = @"退还中";
            break;
        case CSStatusThird:
            break;
        case CSStatusForth:
            status = @"处理完成";
            break;
        case CSStatusFifth:
            status = @"已取消";
            break;
        default:
            break;
    }
    return status;
}

@end
