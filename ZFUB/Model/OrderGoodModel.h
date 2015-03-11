//
//  OrderGoodModel.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderGoodModel : NSObject

@property (nonatomic, strong) NSString *goodName;

@property (nonatomic, strong) NSString *goodBrand;

@property (nonatomic, assign) CGFloat goodPrice;

@property (nonatomic, strong) NSString *goodChannel;

@property (nonatomic, strong) NSString *goodID;

@property (nonatomic, strong) NSString *goodNumber;

@property (nonatomic, strong) NSString *goodPicture;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
