//
//  OrderDetailCell.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/6.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderGoodModel.h"
#import "UIImageView+WebCache.h"

#define kOrderDetailCellHeight  90.f

@interface OrderDetailCell : UITableViewCell

@property (nonatomic, strong) UIImageView *pictureView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *openPriceLabel;

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UILabel *brandLabel;

@property (nonatomic, strong) UILabel *channelLabel;

- (void)setContentsWithData:(OrderGoodModel *)data;

@end
