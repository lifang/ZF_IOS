//
//  GoodDetialModel.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/7.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChannelModel.h"

@interface GoodDetialModel : NSObject

@property (nonatomic, strong) NSString *goodName;

@property (nonatomic, strong) NSString *detailName;

@property (nonatomic, strong) NSString *goodBrand;

@property (nonatomic, strong) NSString *goodModel;

@property (nonatomic, strong) NSString *goodCategory;

@property (nonatomic, strong) NSString *goodComment;

@property (nonatomic, strong) NSString *goodMaterial;

@property (nonatomic, strong) NSString *goodBattery;

@property (nonatomic, strong) NSString *goodSignWay;

@property (nonatomic, strong) NSString *goodEncryptWay;

@property (nonatomic, strong) NSString *goodSaleNumber;

@property (nonatomic, strong) NSString *goodPrice;

@property (nonatomic, assign) BOOL canRent;

@property (nonatomic, strong) NSMutableArray *goodImageList;

@property (nonatomic, strong) ChannelModel *defaultChannel;

@property (nonatomic, strong) NSMutableArray *channelItem;

//厂家信息
@property (nonatomic, strong) NSString *factoryName;

@property (nonatomic ,strong) NSString *factoryWebsite;

@property (nonatomic, strong) NSString *factorySummary;

@property (nonatomic, strong) NSString *factoryImagePath;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
