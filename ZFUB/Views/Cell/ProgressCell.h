//
//  ProgressCell.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/17.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressModel.h"

#define kProgressPrimaryHeight 40.f

@interface ProgressCell : UITableViewCell

@property (nonatomic, strong) UILabel *terminalLabel;

@property (nonatomic, strong) UILabel *tipLabel;

- (void)setContentsWithData:(ProgressModel *)model;

@end
