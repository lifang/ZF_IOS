//
//  CustomerServiceHandle.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkInterface.h"
#import "CustomerServiceModel.h"

@interface CustomerServiceHandle : NSObject

+ (NSString *)titleForCSType:(CSType)csType;
+ (NSString *)titleForDetailWithCSType:(CSType)csType;

+ (NSString *)getStatusStringWithCSType:(CSType)csType
                                 status:(NSString *)status;

@end
