//
//  RentOrderViewController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/18.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "OrderConfirmController.h"
#import "GoodDetialModel.h"

@interface RentOrderViewController : OrderConfirmController

@property (nonatomic, strong) GoodDetialModel *goodDetail;

@end