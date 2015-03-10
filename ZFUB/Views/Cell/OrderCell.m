//
//  OrderCell.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "OrderCell.h"

static NSString *orderBtnStyleFirst = @"orderBtnStyleFirst";
static NSString *orderBtnStyleSecond = @"orderBtnStyleSecond";

typedef enum {
    BtnPositionLeft = 1,
    BtnPositionMiddle,
    BtnPositionRight,
}BtnPosition;

@implementation OrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _identifier = reuseIdentifier;
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
    CGFloat labelHeight = 18.f;

    CGFloat imageSize = 70.f;
    
    //订单编号
    _orderNoLabel = [[UILabel alloc] init];
    _orderNoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _orderNoLabel.backgroundColor = [UIColor clearColor];
    _orderNoLabel.textColor = kColor(117, 117, 117, 1);
    _orderNoLabel.font = [UIFont systemFontOfSize:8.f];
    [self.contentView addSubview:_orderNoLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_orderNoLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_orderNoLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_orderNoLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.45
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_orderNoLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = kColor(117, 117, 117, 1);
    _timeLabel.font = [UIFont systemFontOfSize:8.f];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_orderNoLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.35
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //状态
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.textColor = kColor(117, 117, 117, 1);
    _statusLabel.textAlignment = NSTextAlignmentRight;
    _statusLabel.font = [UIFont systemFontOfSize:11.f];
    [self.contentView addSubview:_statusLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_statusLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_statusLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_statusLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_timeLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:20.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_statusLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //划线
    UIImageView *firstLine = [[UIImageView alloc] init];
    firstLine.image = kImageName(@"gray.png");
    firstLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:firstLine];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_orderNoLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:1.0]];
    
    //图片
    _pictureView = [[UIImageView alloc] init];
    _pictureView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_pictureView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_orderNoLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:20.f]];
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
    [self layoutGoodLabel:_nameLabel WithTopView:_orderNoLabel topSpace:5.f alignment:NSTextAlignmentLeft];
    //价格
    _priceLabel = [[UILabel alloc] init];
    [self layoutGoodLabel:_priceLabel WithTopView:_nameLabel topSpace:0.f alignment:NSTextAlignmentRight];
    //数量
    _numberLabel = [[UILabel alloc] init];
    [self layoutGoodLabel:_numberLabel WithTopView:_priceLabel topSpace:0.f alignment:NSTextAlignmentRight];
    //型号
    _brandLabel = [[UILabel alloc] init];
    [self layoutGoodLabel:_brandLabel WithTopView:_numberLabel topSpace:0.f alignment:NSTextAlignmentLeft];
    //支付通道
    _channelLabel = [[UILabel alloc] init];
    [self layoutGoodLabel:_channelLabel WithTopView:_brandLabel topSpace:0.f alignment:NSTextAlignmentLeft];
    
    //划线
    UIImageView *secondLine = [[UIImageView alloc] init];
    secondLine.image = kImageName(@"gray.png");
    secondLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:secondLine];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:1.0]];
    //共计
    _totalCountLabel = [[UILabel alloc] init];
    _totalCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _totalCountLabel.backgroundColor = [UIColor clearColor];
    _totalCountLabel.font = [UIFont systemFontOfSize:10.f];
    _totalCountLabel.textColor = kColor(117, 117, 117, 1);
    [self.contentView addSubview:_totalCountLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_totalCountLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:secondLine
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_totalCountLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_totalCountLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.3
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_totalCountLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //配送费
    _deliveryFeeLabel = [[UILabel alloc] init];
    _deliveryFeeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _deliveryFeeLabel.backgroundColor = [UIColor clearColor];
    _deliveryFeeLabel.font = [UIFont systemFontOfSize:10.f];
    _deliveryFeeLabel.textColor = kColor(117, 117, 117, 1);
    [self.contentView addSubview:_deliveryFeeLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_deliveryFeeLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:secondLine
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_deliveryFeeLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_totalCountLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_deliveryFeeLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.3
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_deliveryFeeLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //实付
    _payLabel = [[UILabel alloc] init];
    _payLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _payLabel.backgroundColor = [UIColor clearColor];
    _payLabel.font = [UIFont systemFontOfSize:12.f];
    _payLabel.textColor = kColor(117, 117, 117, 1);
    _payLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_payLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_payLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:secondLine
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_payLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_payLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.4
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_payLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    [self setContentForReuseIdentifier];
}

- (void)setContentForReuseIdentifier {
    if ([_identifier isEqualToString:otherIdentifier]) {
        return;
    }
    else if ([_identifier isEqualToString:unPaidIdentifier]) {
        //未付款
        [self addLine];
        UIButton *cancelBtn = [self buttonWithTitle:@"取消订单" action:@selector(cancelOrder:) style:orderBtnStyleFirst];
        [self.contentView addSubview:cancelBtn];
        [self layoutButton:cancelBtn location:BtnPositionLeft];
        
        UIButton *payBtn = [self buttonWithTitle:@"付款" action:@selector(payOrder:) style:orderBtnStyleSecond];
        [self.contentView addSubview:payBtn];
        [self layoutButton:payBtn location:BtnPositionRight];
    }
    else if ([_identifier isEqualToString:sendingIdentifier]) {
        //已发货
        [self addLine];
        UIButton *reviewBtn = [self buttonWithTitle:@"评价" action:@selector(reviewOrder:) style:orderBtnStyleSecond];
        [self.contentView addSubview:reviewBtn];
        [self layoutButton:reviewBtn location:BtnPositionMiddle];
    }
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

- (void)layoutButton:(UIButton *)button location:(BtnPosition)position {
    CGFloat middleSpace = 5.f;
    CGFloat btnWidth = (kScreenWidth - 8 * middleSpace) / 2;
    CGFloat btnHeight = 36.f;
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_totalCountLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:middleSpace + 1]];
    switch (position) {
        case BtnPositionLeft: {
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0
                                                                          constant:middleSpace * 2]];
        }
            break;
        case BtnPositionRight: {
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0
                                                                          constant:-middleSpace * 2]];
        }
            break;
        case BtnPositionMiddle: {
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0
                                                                          constant:0.f]];
        }
            break;
        default:
            break;
    }
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:btnWidth]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:btnHeight]];
}

- (UIButton *)buttonWithTitle:(NSString *)titleName
                       action:(SEL)action
                        style:(NSString *)style{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.layer.cornerRadius = 4;
    button.layer.masksToBounds = YES;
    if ([style isEqualToString:orderBtnStyleFirst]) {
        button.layer.borderWidth = 1.f;
        button.layer.borderColor = kColor(255, 102, 36, 1).CGColor;
        [button setTitleColor:kColor(255, 102, 36, 1) forState:UIControlStateNormal];
        [button setTitleColor:kColor(134, 56, 0, 1) forState:UIControlStateHighlighted];
    }
    else {
        [button setBackgroundImage:kImageName(@"orange.png") forState:UIControlStateNormal];
    }
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [button setTitle:titleName forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)addLine {
    UIImageView *line = [[UIImageView alloc] init];
    line.image = kImageName(@"gray.png");
    line.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:line];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_totalCountLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:10.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-10.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:1.0]];
}

#pragma mark - Data

- (void)setContentsWithData:(OrderModel *)data {
    _cellData = data;
    self.orderNoLabel.text = [NSString stringWithFormat:@"订单编号：%@",_cellData.orderNumber];
    self.timeLabel.text = _cellData.orderTime;
    self.statusLabel.text = [_cellData getStatusString];
    self.nameLabel.text = _cellData.orderGood.goodName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[_cellData.orderGood.goodPrice floatValue]];
    self.numberLabel.text = [NSString stringWithFormat:@"X %d",[_cellData.orderGood.goodNumber intValue]];
    self.brandLabel.text = [NSString stringWithFormat:@"品牌型号 %@",_cellData.orderGood.goodBrand];
    self.channelLabel.text = [NSString stringWithFormat:@"支付通道 %@",_cellData.orderGood.goodChannel];
    self.totalCountLabel.text = [NSString stringWithFormat:@"共计：%@件",_cellData.orderTotalNum];
    self.deliveryFeeLabel.text = [NSString stringWithFormat:@"配送费：￥%@",_cellData.orderDeliverFee];
    self.payLabel.text = [NSString stringWithFormat:@"实付：￥%@",_cellData.orderTotalPrice];
    [self.pictureView sd_setImageWithURL:_cellData.orderGood.goodPicture placeholderImage:kImageName(@"test1.png")];
}


#pragma mark - Action

- (IBAction)cancelOrder:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(orderCellCancelOrderForData:)]) {
        [_delegate orderCellCancelOrderForData:_cellData];
    }
}

- (IBAction)payOrder:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(orderCellPayOrderForData:)]) {
        [_delegate orderCellPayOrderForData:_cellData];
    }
}

- (IBAction)reviewOrder:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(orderCellCommentOrderForData:)]) {
        [_delegate orderCellCommentOrderForData:_cellData];
    }
}

@end
