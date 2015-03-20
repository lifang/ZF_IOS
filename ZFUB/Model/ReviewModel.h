//
//  ReviewModel.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/18.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReviewModel : NSObject

@property (nonatomic, strong) NSString *goodName;

@property (nonatomic, strong) NSString *goodBrand;

@property (nonatomic, strong) NSString *goodChannel;

@property (nonatomic, strong) NSString *goodID;

@property (nonatomic, strong) NSString *goodPicture;

@property (nonatomic, assign) int score;

@property (nonatomic, strong) NSString *review;

@end
