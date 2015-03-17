//
//  BuyOrderViewController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/13.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "OrderConfirmController.h"
#import "GoodDetialModel.h"

@interface BuyOrderViewController : OrderConfirmController

@property (nonatomic, strong) GoodDetialModel *goodDetail;

@end
