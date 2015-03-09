//
//  OrderCell.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
#import "UIImageView+WebCache.h"

#define kOrderShortCellHeight 122.f
#define kOrderLongCellHeight 169.f

@interface OrderCell : UITableViewCell

@property (nonatomic, strong) UILabel *orderNoLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) UIImageView *pictureView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UILabel *brandLabel;

@property (nonatomic, strong) UILabel *channelLabel;

@property (nonatomic, strong) UILabel *totalCountLabel;

@property (nonatomic, strong) UILabel *deliveryFeeLabel;

@property (nonatomic, strong) UILabel *payLabel;

@property (nonatomic, strong) NSString *identifier;

@property (nonatomic, strong) OrderModel *cellData;

- (void)setContentsWithData:(OrderModel *)data;

@end
