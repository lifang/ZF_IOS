//
//  RepairDetailController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/4.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CSDetailViewController.h"
#import "PayWayViewController.h"

@interface RepairDetailController : CSDetailViewController

@property (nonatomic, strong) NSString *goodName;

@property (nonatomic, assign) PayWayFromType fromType;

@end
