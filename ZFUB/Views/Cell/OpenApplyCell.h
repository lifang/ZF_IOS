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

//重新申请开通
static NSString *unOpenedApplyFirstIdentifier = @"unOpenedApplyFirstIdentifier";
//申请开通 视频认证弹出提示
static NSString *unOpenedApplySecondIdentifier = @"unOpenedApplySecondIdentifier";
static NSString *partOpenedApplyIdentifier = @"partOpenedApplyIdentifier";

@interface OpenApplyCell : UITableViewCell

@property (nonatomic, assign) id<OpenApplyCellDelegate>delegate;

@property (nonatomic, strong) UILabel *terminalLabel;

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) NSString *identifier;

@property (nonatomic, strong) TerminalManagerModel *cellData;

- (void)setContentsWithData:(TerminalManagerModel *)data;

- (void)setContentForReuseIdentifierWithVideoAuth:(BOOL)_hasVideoAuth;

@end

@protocol OpenApplyCellDelegate <NSObject>

//申请开通
- (void)openApplyWithData:(TerminalManagerModel *)model identifier:(NSString *)identifier;
//视频认证
- (void)videoAuthWithData:(TerminalManagerModel *)model identifier:(NSString *)identifier;
//重新申请开通
- (void)reopenApplyWithData:(TerminalManagerModel *)model identifier:(NSString *)identifier;

@end
