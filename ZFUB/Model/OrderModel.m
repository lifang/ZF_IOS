//
//  OrderModel.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _orderID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_id"]];
        if ([dict objectForKey:@"order_number"]) {
            _orderNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_number"]];
        }
        if ([dict objectForKey:@"order_status"]) {
            _orderStatus = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_status"]];
        }
        if ([dict objectForKey:@"order_createTime"]) {
            _orderTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_createTime"]];
        }
        if ([dict objectForKey:@"order_totalNum"]) {
            _orderTotalNum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_totalNum"]];
        }
        if ([dict objectForKey:@"order_totalPrice"]) {
            _orderTotalPrice = [[dict objectForKey:@"order_totalPrice"] floatValue] / 100;
        }
        if ([dict objectForKey:@"order_psf"]) {
            _orderDeliverFee = [[dict objectForKey:@"order_psf"] floatValue] / 100;
        }
        id object = [dict objectForKey:@"order_goodsList"];
        if (object && [object isKindOfClass:[NSArray class]]) {
            if ([object count] > 0) {
                id firstObject = [object objectAtIndex:0];
                if ([firstObject isKindOfClass:[NSDictionary class]]) {
                    _orderGood = [[OrderGoodModel alloc] initWithParseDictionary:firstObject];
                }
            }
        }
    }
    return self;
}

- (NSString *)getCellIdentifier {
    NSString *cellIdentifier = nil;
    switch ([_orderStatus intValue]) {
        case OrderStatusUnPaid:
            cellIdentifier = unPaidIdentifier;
            break;
        case OrderStatusSending:
            //现在列表不显示评价按钮 
            cellIdentifier = otherIdentifier;
            break;
        default:
            cellIdentifier = otherIdentifier;
            break;
    }
    return cellIdentifier;
}

- (NSString *)getStatusString {
    NSString *status = nil;
    switch ([_orderStatus intValue]) {
        case OrderStatusUnPaid:
            status = @"未付款";
            break;
        case OrderStatusSending:
            status = @"已发货";
            break;
        case OrderStatusReview:
            status = @"已评价";
            break;
        case OrderStatusCancel:
            status = @"已取消";
            break;
        case OrderStatusClosed:
            status = @"交易关闭";
            break;
        case OrderStatusPaid:
            status = @"已付款";
            break;
        default:
            break;
    }
    return status;
}

@end
