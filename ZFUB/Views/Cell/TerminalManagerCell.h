//
//  TerminalManagerCell.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/27.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//


#define kTMShortCellHeight  56.f
#define kTMMiddleCellHeight 76.f
#define kTMLongCellHeight   104.f

#import <UIKit/UIKit.h>
#import "TerminalManagerModel.h"

@protocol TerminalManagerDelegate;

static NSString *TMMiddleHeightIdentifier = @"TMMiddleHeightIdentifier";
static NSString *TMShortHeightIdentifier = @"TMShortHeightIdentifier";
static NSString *TMLongHeightIdentifier = @"TMLongHeightIdentifier";

@interface TerminalManagerCell : UITableViewCell

@property (nonatomic, assign) id<TerminalManagerDelegate>delegate;

@property (nonatomic, strong) UILabel *terminalLabel;

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) NSString *identifier;

@property (nonatomic, strong) UIImageView *arrowView;  //箭头

@property (nonatomic, strong) TerminalManagerModel *cellData;

- (void)setContentForReuseIdentifierWithTerminalModel:(TerminalManagerModel *)model;

@end

@protocol TerminalManagerDelegate <NSObject>
//视频认证  是否需要提示
- (void)terminalManagerVideoAuthWithData:(TerminalManagerModel *)model needNotice:(BOOL)needNotice;
//找回POS密码
- (void)terminalManagerFindPasswordWithData:(TerminalManagerModel *)model;
//同步
- (void)terminalManagerSynchronizationWithData:(TerminalManagerModel *)model;
//申请开通
- (void)terminalManagerOpenApplyWithData:(TerminalManagerModel *)model;
//重新申请开通
- (void)terminalManagerOpenConfirmWithData:(TerminalManagerModel *)model needNotice:(BOOL)needNotice;

@end
