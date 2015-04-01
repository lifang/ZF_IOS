//
//  OrderReviewController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/18.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "OrderCommentCell.h"
#import "ReviewModel.h"

@interface OrderReviewController : CommonViewController

@property (nonatomic, strong) NSArray *goodList;

@property (nonatomic, strong) NSString *orderID;

@end
