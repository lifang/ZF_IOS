//
//  ScoreCell.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/2.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ScoreCell.h"

@implementation ScoreCell

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
    CGFloat topSpace = 5.f;
    CGFloat leftSpace = 10.f;
    CGFloat rightSpace = 5.f;
    CGFloat labelHeight = 18.f;
    CGFloat middleSpace = 0.f;
    //积分
    _scoreLabel = [[UILabel alloc] init];
    _scoreLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _scoreLabel.backgroundColor = [UIColor clearColor];
    _scoreLabel.textColor = kColor(55, 55, 55, 1);
    _scoreLabel.font = [UIFont systemFontOfSize:16.f];
    [self.contentView addSubview:_scoreLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_scoreLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_scoreLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_scoreLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.5
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_scoreLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:3 * labelHeight + 2 * middleSpace]];
    //订单编号
    _orderNumberLabel = [[UILabel alloc] init];
    _orderNumberLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _orderNumberLabel.backgroundColor = [UIColor clearColor];
    _orderNumberLabel.textColor = kColor(55, 55, 55, 1);
    _orderNumberLabel.font = [UIFont systemFontOfSize:10.f];
    
    [self.contentView addSubview:_orderNumberLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_orderNumberLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace + 8]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_orderNumberLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1
                                                                  constant:-rightSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_orderNumberLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.5
                                                                  constant:-rightSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_orderNumberLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //交易时间
    _timeLabel = [[UILabel alloc] init];
    [self setLabel:_timeLabel withTopView:_orderNumberLabel middleSpace:5.f];
//    //实付金额
//    _priceLabel = [[UILabel alloc] init];
//    [self setLabel:_priceLabel withTopView:_timeLabel middleSpace:middleSpace];
}

- (void)setLabel:(UILabel *)label
     withTopView:(UIView *)topView
     middleSpace:(CGFloat)space{
    CGFloat rightSpce = 2.f;
    CGFloat labelHeight = 18.f;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:10.f];
    label.textColor = kColor(55, 55, 55, 1);
    [self.contentView addSubview:label];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:topView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:space]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1
                                                                  constant:-rightSpce]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.5
                                                                  constant:-rightSpce]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0
                                                                  constant:labelHeight]];
}

#pragma mark - Data

- (void)setContentsWithData:(ScoreModel *)data {
    NSString *tipString = [data tipsString];
    _scoreLabel.text = [NSString stringWithFormat:@"%@%@分",tipString,data.score];
    _orderNumberLabel.text = [NSString stringWithFormat:@"订单编号：%@",data.orderNumber];
    _timeLabel.text = [NSString stringWithFormat:@"交易时间：%@",data.payedTime];
//    _priceLabel.text = [NSString stringWithFormat:@"实付金额：￥%@",data.actualPrice];
}

@end
