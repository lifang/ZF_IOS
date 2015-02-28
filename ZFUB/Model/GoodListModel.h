//
//  GoodListModel.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/11.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodListModel : NSObject
///商品ID
@property (nonatomic, strong) NSString *goodID;
///商品名
@property (nonatomic, strong) NSString *goodName;
///商品品牌
@property (nonatomic, strong) NSString *goodBrand;
///商品型号
@property (nonatomic, strong) NSString *goodModel;
///商品支付通道
@property (nonatomic, strong) NSString *goodChannel;
///是否可租赁
@property (nonatomic, assign) BOOL isRent;
///商品价格
@property (nonatomic, assign) CGFloat goodPrice;
///商品评分
@property (nonatomic, strong) NSString *goodScore;
///商品图片URL
@property (nonatomic, strong) NSString *goodImagePath;
///商品已售数量
@property (nonatomic, strong) NSString *goodSaleNumber;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
