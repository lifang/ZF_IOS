//
//  CustomerServiceCell.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerServiceHandle.h"

#define kCSCellShortHeight 65.f
#define kCSCellLongHeight  121.f

@protocol CSCellDelegate <NSObject>
//取消申请
- (void)CSCellCancelRecordWithData:(CustomerServiceModel *)model;
//物流
- (void)CSCellLogisticInfoWithData:(CustomerServiceModel *)model;
//注销
- (void)csCellSubmitInfoWithData:(CustomerServiceModel *)model;
//付款
- (void)csCellPayWithData:(CustomerServiceModel *)model;

@end

@interface CustomerServiceCell : UITableViewCell

@property (nonatomic, assign) id<CSCellDelegate>delegate;

@property (nonatomic, strong) UILabel *csNumberLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *terminalLabel;

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) NSString *identifier;

@property (nonatomic, assign) CSType csType;   //售后类型

@property (nonatomic, strong) CustomerServiceModel *cellData;

- (void)setContentsWithData:(CustomerServiceModel *)data;

- (id)initWithCSType:(CSType)csType
     reuseIdentifier:(NSString *)reuseIdentifier;

@end
