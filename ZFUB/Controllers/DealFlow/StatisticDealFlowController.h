//
//  StatisticDealFlowController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/27.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "NetworkInterface.h"

@interface StatisticDealFlowController : CommonViewController

@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;

@property (nonatomic, assign) TradeType tradeType;
@property (nonatomic, strong) NSString *terminalNumber;

@end
