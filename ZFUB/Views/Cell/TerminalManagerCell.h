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

//已开通状态一
static NSString *OpenedFirstStatusIdentifier = @"OpenedFirstStatusIdentifier";
//已开通状态二
static NSString *OpenedSecondStatusIdentifier = @"OpenedSecondStatusIdentifier";
//部分开通
static NSString *PartOpenedStatusIdentifier = @"PartOpenedStatusIdentifier";
//未开通状态一
static NSString *UnOpenedFirstStatusIdentifier = @"UnOpenedFirstStatusIdentifier";
//未开通状态二
static NSString *UnOpenedSecondStatusIdentifier = @"UnOpenedSecondStatusIdentifier";
//已注销
static NSString *CanceledStatusIdentifier = @"CanceledStatusIdentifier";
//已停用
static NSString *StoppedStatusIdentifier = @"StoppedStatusIdentifier";

@interface TerminalManagerCell : UITableViewCell

@property (nonatomic, assign) id<TerminalManagerDelegate>delegate;

@property (nonatomic, strong) UILabel *terminalLabel;

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) NSString *identifier;

@property (nonatomic, strong) UIImageView *arrowView;  //箭头

@property (nonatomic, strong) TerminalManagerModel *cellData;

- (void)setContentsWithData:(TerminalManagerModel *)data;

@end

@protocol TerminalManagerDelegate <NSObject>
//视频认证
- (void)terminalManagerVideoAuthWithData:(TerminalManagerModel *)model;
//找回POS密码
- (void)terminalManagerFindPasswordWithData:(TerminalManagerModel *)model;
//同步
- (void)terminalManagerSynchronizationWithData:(TerminalManagerModel *)model;
//申请开通
- (void)terminalManagerOpenApplyWithData:(TerminalManagerModel *)model;
//重新申请开通
- (void)terminalManagerOpenConfirmWithData:(TerminalManagerModel *)model;

@end
