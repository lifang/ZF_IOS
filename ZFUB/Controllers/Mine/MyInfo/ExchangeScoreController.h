//
//  ExchangeScoreController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/2.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"

static NSString *ExchangeScoreNotification = @"ExchangeScoreNotification";

@interface ExchangeScoreController : CommonViewController

@property (nonatomic, strong) NSString *totalScore;

@property (nonatomic, assign) CGFloat totalPrice;

@end
