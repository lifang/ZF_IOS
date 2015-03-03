//
//  ScoreCell.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/2.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#define kScoreCellHeight 64.f

#import <UIKit/UIKit.h>
#import "ScoreModel.h"

@interface ScoreCell : UITableViewCell

@property (nonatomic, strong) UILabel *scoreLabel;

@property (nonatomic, strong) UILabel *orderNumberLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *priceLabel;

- (void)setContentsWithData:(ScoreModel *)data;

@end
