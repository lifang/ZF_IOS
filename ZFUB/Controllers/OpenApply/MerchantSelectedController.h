//
//  MerchantSelectedController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/11.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "MerchantModel.h"
#import "MerchantDetailModel.h"

@protocol ApplyMerchantSelectedDelegate <NSObject>

- (void)getSelectedMerchant:(MerchantDetailModel *)model;

@end

@interface MerchantSelectedController : CommonViewController

@property (nonatomic, assign) id<ApplyMerchantSelectedDelegate>delegate;

@property (nonatomic, strong) NSArray *merchantItems;

@end
