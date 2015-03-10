//
//  LocationViewController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/11.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "CityHandle.h"

@protocol LocationDelegate <NSObject>

- (void)getSelectedLocation:(CityModel *)selectedCity;

@end

@interface LocationViewController : CommonViewController

@property (nonatomic, assign) BOOL needShowLocation;  //是否需要定位

@property (nonatomic, assign) id<LocationDelegate>delegate;

@end
