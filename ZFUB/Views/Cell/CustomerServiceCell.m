//
//  CustomerServiceCell.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CustomerServiceCell.h"

static NSString *btnStyleFirst = @"btnStyleFirst";
static NSString *btnStyleSecond = @"btnStyleSecond";

typedef enum {
    BtnLeft = 1,
    BtnRight,
    BtnMiddle,
}BtnLocation;

@implementation CustomerServiceCell

- (id)initWithCSType:(CSType)csType reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        _identifier = reuseIdentifier;
        _csType = csType;
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
//    CGFloat topSpace = 10.f;
    CGFloat leftSpace = 10.f;
    CGFloat labelHeight = 18.f;
    
    //售后编号
    _csNumberLabel = [[UILabel alloc] init];
    _csNumberLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _csNumberLabel.backgroundColor = [UIColor clearColor];
    _csNumberLabel.textColor = kColor(117, 117, 117, 1);
    _csNumberLabel.font = [UIFont systemFontOfSize:10.f];
    [self.contentView addSubview:_csNumberLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_csNumberLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_csNumberLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_csNumberLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.5
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_csNumberLabel
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
    _timeLabel.font = [UIFont systemFontOfSize:10.f];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.5
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
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
                                                                    toItem:_csNumberLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:10.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-10.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:1.0]];

    //终端号标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:12.f];
    titleLabel.text = @"终端号";
    [self.contentView addSubview:titleLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:firstLine
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:1.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.5
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //状态标题
    UILabel *statusTitleLabel = [[UILabel alloc] init];
    statusTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    statusTitleLabel.backgroundColor = [UIColor clearColor];
    statusTitleLabel.font = [UIFont systemFontOfSize:12.f];
    statusTitleLabel.text = @"状态";
    [self.contentView addSubview:statusTitleLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:statusTitleLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:firstLine
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:statusTitleLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:titleLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:statusTitleLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.5
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:statusTitleLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //终端号
    _terminalLabel = [[UILabel alloc] init];
    _terminalLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _terminalLabel.backgroundColor = [UIColor clearColor];
    _terminalLabel.font = [UIFont boldSystemFontOfSize:14.f];
    [self.contentView addSubview:_terminalLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_terminalLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:titleLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_terminalLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_terminalLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.5
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_terminalLabel
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
    _statusLabel.font = [UIFont boldSystemFontOfSize:14.f];
    [self.contentView addSubview:_statusLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_statusLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:statusTitleLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_statusLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_terminalLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_statusLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.5
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_statusLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //箭头
    UIImageView *arrowView = [[UIImageView alloc] init];
    arrowView.translatesAutoresizingMaskIntoConstraints = NO;
    arrowView.image = kImageName(@"arrow_right.png");
    [self.contentView addSubview:arrowView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:arrowView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:36.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:arrowView
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-10.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:arrowView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:8.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:arrowView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:15.f]];
    [self setContentForReuseIdentifier];
}

- (void)setContentForReuseIdentifier {
    switch (_csType) {
        case CSTypeRepair: {
            //维修记录
            if ([_identifier isEqualToString:thirdStatusIdentifier] ||
                [_identifier isEqualToString:forthStatusIdentifier] ||
                [_identifier isEqualToString:fifthStatusIdentifier]) {
                //维修中、处理完成、已取消无操作
                return;
            }
            else if ([_identifier isEqualToString:firstStatusIdentifier]) {
                //未付款 取消申请 付款
                [self addLine];
                UIButton *cancelBtn = [self buttonWithTitle:@"取消申请" action:@selector(repairCancel:) style:btnStyleFirst];
                UIButton *payBtn = [self buttonWithTitle:@"付款" action:@selector(repairPay:) style:btnStyleSecond];
                [self.contentView addSubview:cancelBtn];
                [self.contentView addSubview:payBtn];
                [self layoutButton:cancelBtn location:BtnLeft];
                [self layoutButton:payBtn location:BtnRight];
            }
            else if ([_identifier isEqualToString:secondStatusIdentifier]) {
                //待发回 提交物流信息
                [self addLine];
                UIButton *sendBtn = [self buttonWithTitle:@"提交物流信息" action:@selector(repairSend:) style:btnStyleSecond];
                [self.contentView addSubview:sendBtn];
                [self layoutButton:sendBtn location:BtnMiddle];
            }
        }
            break;
        case CSTypeReturn: {
            //退货记录
            if ([_identifier isEqualToString:forthStatusIdentifier] ||
                [_identifier isEqualToString:fifthStatusIdentifier]) {
                //处理完成、已取消无操作
                return;
            }
            else if ([_identifier isEqualToString:firstStatusIdentifier]) {
                //待处理
                [self addLine];
                UIButton *cancelBtn = [self buttonWithTitle:@"取消申请" action:@selector(returnCancel:) style:btnStyleFirst];
                [self.contentView addSubview:cancelBtn];
                [self layoutButton:cancelBtn location:BtnMiddle];
            }
            else if ([_identifier isEqualToString:secondStatusIdentifier]) {
                //退货中
                [self addLine];
                UIButton *sendBtn = [self buttonWithTitle:@"提交物流信息" action:@selector(returnSend:) style:btnStyleSecond];
                [self.contentView addSubview:sendBtn];
                [self layoutButton:sendBtn location:BtnMiddle];
            }
        }
            break;
        case CSTypeCancel: {
            //注销记录
            if ([_identifier isEqualToString:secondStatusIdentifier] ||
                [_identifier isEqualToString:forthStatusIdentifier]) {
                //处理中、处理完成无操作
                return;
            }
            else if ([_identifier isEqualToString:firstStatusIdentifier]) {
                //待处理
                [self addLine];
                UIButton *cancelBtn = [self buttonWithTitle:@"取消申请" action:@selector(cancelCancel:) style:btnStyleFirst];
                [self.contentView addSubview:cancelBtn];
                [self layoutButton:cancelBtn location:BtnMiddle];
            }
            else if ([_identifier isEqualToString:fifthStatusIdentifier]) {
                //已取消
                [self addLine];
                UIButton *sendBtn = [self buttonWithTitle:@"重新提交注销" action:@selector(cancelSubmit:) style:btnStyleSecond];
                [self.contentView addSubview:sendBtn];
                [self layoutButton:sendBtn location:BtnMiddle];
            }
        }
            break;
        case CSTypeChange: {
            //换货记录
            if ([_identifier isEqualToString:forthStatusIdentifier] ||
                [_identifier isEqualToString:fifthStatusIdentifier]) {
                //处理完成、已取消无操作
                return;
            }
            else if ([_identifier isEqualToString:firstStatusIdentifier]) {
                //待处理
                [self addLine];
                UIButton *cancelBtn = [self buttonWithTitle:@"取消申请" action:@selector(changeCancel:) style:btnStyleFirst];
                [self.contentView addSubview:cancelBtn];
                [self layoutButton:cancelBtn location:BtnMiddle];
            }
            else if ([_identifier isEqualToString:secondStatusIdentifier]) {
                //换货中
                [self addLine];
                UIButton *sendBtn = [self buttonWithTitle:@"提交物流信息" action:@selector(changeSend:) style:btnStyleSecond];
                [self.contentView addSubview:sendBtn];
                [self layoutButton:sendBtn location:BtnMiddle];
            }
        }
            break;
        case CSTypeUpdate: {
            //更新资料记录
            if ([_identifier isEqualToString:secondStatusIdentifier] ||
                [_identifier isEqualToString:forthStatusIdentifier] ||
                [_identifier isEqualToString:fifthStatusIdentifier]) {
                //处理中、处理完成、已取消无操作
                return;
            }
            else if ([_identifier isEqualToString:firstStatusIdentifier]) {
                //待处理
                [self addLine];
                UIButton *cancelBtn = [self buttonWithTitle:@"取消申请" action:@selector(updateCancel:) style:btnStyleFirst];
                [self.contentView addSubview:cancelBtn];
                [self layoutButton:cancelBtn location:BtnMiddle];
            }
        }
            break;
        case CSTypeLease: {
            //租赁退还记录
            if ([_identifier isEqualToString:forthStatusIdentifier] ||
                [_identifier isEqualToString:fifthStatusIdentifier]) {
                //处理完成、已取消无操作
                return;
            }
            else if ([_identifier isEqualToString:firstStatusIdentifier]) {
                //待处理
                UIButton *cancelBtn = [self buttonWithTitle:@"取消申请" action:@selector(rentCancel:) style:btnStyleFirst];
                [self.contentView addSubview:cancelBtn];
                [self layoutButton:cancelBtn location:BtnMiddle];
            }
            else if ([_identifier isEqualToString:secondStatusIdentifier]) {
                [self addLine];
                UIButton *sendBtn = [self buttonWithTitle:@"提交物流信息" action:@selector(rentSend:) style:btnStyleSecond];
                [self.contentView addSubview:sendBtn];
                [self layoutButton:sendBtn location:BtnMiddle];
            }
        }
            break;
        default:
            break;
    }
}

- (void)layoutButton:(UIButton *)button location:(BtnLocation)location {
    CGFloat middleSpace = 10.f;
    CGFloat btnWidth = (kScreenWidth - 4 * middleSpace) / 2;
    CGFloat btnHeight = 36.f;
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_terminalLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:middleSpace * 2]];
    switch (location) {
        case BtnLeft: {
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0
                                                                          constant:middleSpace]];
        }
            break;
        case BtnRight: {
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0
                                                                          constant:-middleSpace]];
        }
            break;
        case BtnMiddle: {
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

- (void)addLine {
    UIImageView *line = [[UIImageView alloc] init];
    line.image = kImageName(@"gray.png");
    line.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:line];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_terminalLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:10.f]];
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

- (UIButton *)buttonWithTitle:(NSString *)titleName
                       action:(SEL)action
                        style:(NSString *)style{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.layer.cornerRadius = 4;
    button.layer.masksToBounds = YES;
    if ([style isEqualToString:btnStyleFirst]) {
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

#pragma mark - Data

- (void)setContentsWithData:(CustomerServiceModel *)data {
    _cellData = data;
    self.terminalLabel.text = _cellData.terminalNum;
    self.timeLabel.text = _cellData.createTime;
    self.statusLabel.text = [CustomerServiceHandle getStatusStringWithCSType:_csType status:_cellData.status];
    NSString *prefix = [_cellData getCSNumberPrefixWithCSType:_csType];
    self.csNumberLabel.text = [NSString stringWithFormat:@"%@%@",prefix,_cellData.applyNum];
}

#pragma mark - Action

//维修
- (IBAction)repairCancel:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(CSCellCancelRecordWithData:)]) {
        [_delegate CSCellCancelRecordWithData:_cellData];
    }
}

- (IBAction)repairPay:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(csCellPayWithData:)]) {
        [_delegate csCellPayWithData:_cellData];
    }
}

- (IBAction)repairSend:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(CSCellLogisticInfoWithData:)]) {
        [_delegate CSCellLogisticInfoWithData:_cellData];
    }
}

//退货
- (IBAction)returnCancel:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(CSCellCancelRecordWithData:)]) {
        [_delegate CSCellCancelRecordWithData:_cellData];
    }
}

- (IBAction)returnSend:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(CSCellLogisticInfoWithData:)]) {
        [_delegate CSCellLogisticInfoWithData:_cellData];
    }
}

//注销
- (IBAction)cancelCancel:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(CSCellCancelRecordWithData:)]) {
        [_delegate CSCellCancelRecordWithData:_cellData];
    }
}

- (IBAction)cancelSubmit:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(csCellSubmitInfoWithData:)]) {
        [_delegate csCellSubmitInfoWithData:_cellData];
    }
}

//换货
- (IBAction)changeCancel:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(CSCellCancelRecordWithData:)]) {
        [_delegate CSCellCancelRecordWithData:_cellData];
    }
}

- (IBAction)changeSend:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(CSCellLogisticInfoWithData:)]) {
        [_delegate CSCellLogisticInfoWithData:_cellData];
    }
}

//更新
- (IBAction)updateCancel:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(CSCellCancelRecordWithData:)]) {
        [_delegate CSCellCancelRecordWithData:_cellData];
    }
}

//租赁退还
- (IBAction)rentCancel:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(CSCellCancelRecordWithData:)]) {
        [_delegate CSCellCancelRecordWithData:_cellData];
    }
}

- (IBAction)rentSend:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(CSCellLogisticInfoWithData:)]) {
        [_delegate CSCellLogisticInfoWithData:_cellData];
    }
}

@end
