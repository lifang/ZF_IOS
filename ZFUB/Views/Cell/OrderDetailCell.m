//
//  OrderDetailCell.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/6.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "OrderDetailCell.h"

@implementation OrderDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initAndLayoutUI];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UI

- (void)initAndLayoutUI {
    CGFloat topSpace = 10.f;
    CGFloat leftSpace = 20.f;
    CGFloat labelHeight = 14.f;
    
    CGFloat imageSize = 70.f;
    
    //图片
    _pictureView = [[UIImageView alloc] init];
    _pictureView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_pictureView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:imageSize]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:imageSize]];
    //商品名
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:12.f];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //价格
    _priceLabel = [[UILabel alloc] init];
    [self layoutGoodLabel:_priceLabel WithTopView:_nameLabel topSpace:0.f alignment:NSTextAlignmentRight];
    _priceLabel.textColor = kColor(255, 102, 36, 1);
    _priceLabel.font = [UIFont boldSystemFontOfSize:13.f];
    //数量
    _numberLabel = [[UILabel alloc] init];
    [self layoutGoodLabel:_numberLabel WithTopView:_priceLabel topSpace:0.f alignment:NSTextAlignmentRight];
    //型号
    _brandLabel = [[UILabel alloc] init];
    [self layoutGoodLabel:_brandLabel WithTopView:_numberLabel topSpace:0.f alignment:NSTextAlignmentLeft];
    //支付通道
    _channelLabel = [[UILabel alloc] init];
    [self layoutGoodLabel:_channelLabel WithTopView:_brandLabel topSpace:0.f alignment:NSTextAlignmentLeft];
}

- (void)layoutGoodLabel:(UILabel *)label
            WithTopView:(UIView *)topView
               topSpace:(CGFloat)space
              alignment:(NSTextAlignment)alignment {
    CGFloat leftSpace = 10.f;
    CGFloat labelHeight = 14.f;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12.f];
    label.textAlignment = alignment;
    [self.contentView addSubview:label];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:topView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:space]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:20.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    
}

#pragma mark - Data

- (void)setContentsWithData:(OrderGoodModel *)data {
    self.nameLabel.text = data.goodName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",data.goodPrice];
    self.numberLabel.text = [NSString stringWithFormat:@"X %d",[data.goodNumber intValue]];
    self.brandLabel.text = [NSString stringWithFormat:@"品牌型号 %@",data.goodBrand];
    self.channelLabel.text = [NSString stringWithFormat:@"支付通道 %@",data.goodChannel];
    [self.pictureView sd_setImageWithURL:data.goodPicture placeholderImage:kImageName(@"test1.png")];
}

@end
