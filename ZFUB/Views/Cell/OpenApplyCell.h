//
//  OpenApplyCell.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/2.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#define kOpenApplyCellHeight 112.f

#import <UIKit/UIKit.h>
#import "TerminalManagerModel.h"

@protocol OpenApplyCellDelegate;

static NSString *unOpenedApplyIdentifier = @"unOpenedApplyIdentifier";
static NSString *partOpenedApplyIdentifier = @"partOpenedApplyIdentifier";

@interface OpenApplyCell : UITableViewCell

@property (nonatomic, assign) id<OpenApplyCellDelegate>delegate;

@property (nonatomic, strong) UILabel *terminalLabel;

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) NSString *identifier;

@property (nonatomic, strong) TerminalManagerModel *cellData;

- (void)setContentsWithData:(TerminalManagerModel *)data;

@end

@protocol OpenApplyCellDelegate <NSObject>

//申请开通
- (void)openApplyWithData:(TerminalManagerModel *)model;
//视频认证
- (void)videoAuthWithData:(TerminalManagerModel *)model;
//重新申请开通
- (void)reopenApplyWithData:(TerminalManagerModel *)model;

@end
