//
//  CityHandle.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityModel.h"

@interface CityHandle : NSObject

+ (NSArray *)tableViewIndex;
+ (NSArray *)dataForSection;

+ (NSArray *)shareProvinceList;  //省份数组

//根据城市id获取城市名
+ (NSString *)getCityNameWithCityID:(NSString *)cityID;

@end
