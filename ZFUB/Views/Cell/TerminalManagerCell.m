//
//  TerminalManagerCell.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/27.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "TerminalManagerCell.h"

typedef enum {
    TMButtonFirst = 1,
    TMButtonSecond,
    TMButtonThird,
    TMButtonForth,
}TMButtonPosition;

@implementation TerminalManagerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier hasVideoAuth:(BOOL)hasVideoAuth {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _hasVideoAuth = hasVideoAuth;
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
    CGFloat topSpace = 10.f;
    CGFloat leftSpace = 10.f;
    CGFloat labelHeight = 18.f;
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
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace]];
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
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace]];
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
    _arrowView = [[UIImageView alloc] init];
    _arrowView.translatesAutoresizingMaskIntoConstraints = NO;
    _arrowView.image = kImageName(@"arrow_right.png");
    [self.contentView addSubview:_arrowView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_arrowView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:20.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_arrowView
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-10.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_arrowView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:8.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_arrowView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:15.f]];
    
    [self setContentForReuseIdentifier];
}

- (void)setContentForReuseIdentifier {
    CGFloat middleSpace = 10.f;
    CGFloat btnWidth = (kScreenWidth - 5 * middleSpace) / 4;
    CGFloat btnHeight = 28.f;
    //自助开通无法查看终端
    if ([_identifier isEqualToString:OpenedSecondStatusIdentifier]) {
        _arrowView.hidden = YES;
    }
    else {
        _arrowView.hidden = NO;
    }
    
    if ([_identifier isEqualToString:CanceledStatusIdentifier]) {
        //已注销
        return;
    }
    else if ([_identifier isEqualToString:OpenedSecondStatusIdentifier]) {
        //已开通 自助开通
        [self addLine];
        UILabel *infoLabel = [[UILabel alloc] init];
        infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.font = [UIFont systemFontOfSize:12.f];
        infoLabel.textColor = kColor(156, 155, 155, 1);
        infoLabel.text = @"- 自助开通终端 -";
        [self.contentView addSubview:infoLabel];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:infoLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_terminalLabel
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:10.f]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:infoLabel
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0
                                                                      constant:10.f]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:infoLabel
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0
                                                                      constant:-10.f]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:infoLabel
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:0.0
                                                                      constant:20.f]];
    }
    else if ([_identifier isEqualToString:OpenedFirstStatusIdentifier]) {
        //已开通
        [self addLine];
        UIButton *videoAuthBtn = [self buttonWithTitle:@"视频认证" action:@selector(videoAuth:)];
        UIButton *findPswBtn = [self buttonWithTitle:@"找回POS密码" action:@selector(findPassword:)];
        if (_hasVideoAuth) {
            [self layoutView:findPswBtn withPosition:TMButtonFirst totalCount:2];
            [self layoutView:videoAuthBtn withPosition:TMButtonSecond totalCount:2];
        }
        else {
            [self layoutView:findPswBtn withPosition:TMButtonFirst totalCount:1];
        }
    }
    else if ([_identifier isEqualToString:UnOpenedFirstStatusIdentifier]) {
        //未开通 同步、开通申请、视频认证
        [self addLine];
        UIButton *synBtn = [self buttonWithTitle:@"同步" action:@selector(synchronization:)];
        UIButton *openApplyBtn = [self buttonWithTitle:@"开通申请" action:@selector(openApply:)];
        UIButton *videoAuthBtn = [self buttonWithTitle:@"视频认证" action:@selector(videoAuth:)];
        if (_hasVideoAuth) {
            [self layoutView:synBtn withPosition:TMButtonFirst totalCount:3];
            [self layoutView:openApplyBtn withPosition:TMButtonSecond totalCount:3];
            [self layoutView:videoAuthBtn withPosition:TMButtonThird totalCount:3];
        }
        else {
            [self layoutView:synBtn withPosition:TMButtonFirst totalCount:2];
            [self layoutView:openApplyBtn withPosition:TMButtonSecond totalCount:2];
        }
    }
    else if ([_identifier isEqualToString:UnOpenedSecondStatusIdentifier]) {
        //未开通 申请开通、视频认证
        [self addLine];
        UIButton *openApplyBtn = [self buttonWithTitle:@"开通申请" action:@selector(openApply:)];
        UIButton *videoAuthBtn = [self buttonWithTitle:@"视频认证" action:@selector(videoAuth:)];
        if (_hasVideoAuth) {
            [self layoutView:openApplyBtn withPosition:TMButtonFirst totalCount:2];
            [self layoutView:videoAuthBtn withPosition:TMButtonSecond totalCount:2];
        }
        else {
            [self layoutView:openApplyBtn withPosition:TMButtonFirst totalCount:1];
        }
    }
    else if ([_identifier isEqualToString:PartOpenedStatusIdentifier]) {
        //部分开通 同步、重新申请开通、视频认证、找回POS密码
        [self addLine];
        UIButton *synBtn = [self buttonWithTitle:@"同步" action:@selector(synchronization:)];
        UIButton *openConfirmBtn = [self buttonWithTitle:@"重新申请开通" action:@selector(openConfirm:)];
        UIButton *videoAuthBtn = [self buttonWithTitle:@"视频认证" action:@selector(videoAuth:)];
        UIButton *findPswBtn = [self buttonWithTitle:@"找回POS密码" action:@selector(findPassword:)];
        if (_hasVideoAuth) {
            [self layoutView:synBtn withPosition:TMButtonFirst totalCount:4];
            [self layoutView:openConfirmBtn withPosition:TMButtonSecond totalCount:4];
            [self layoutView:findPswBtn withPosition:TMButtonThird totalCount:4];
            [self layoutView:videoAuthBtn withPosition:TMButtonForth totalCount:4];
        }
        else {
            [self layoutView:synBtn withPosition:TMButtonFirst totalCount:3];
            [self layoutView:openConfirmBtn withPosition:TMButtonSecond totalCount:3];
            [self layoutView:findPswBtn withPosition:TMButtonThird totalCount:3];
        }
    }
    else if ([_identifier isEqualToString:StoppedStatusIdentifier]) {
        //已停用 同步
        [self addLine];
        UIButton *synBtn = [self buttonWithTitle:@"同步" action:@selector(synchronization:)];
        [self.contentView addSubview:synBtn];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:synBtn
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_terminalLabel
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:middleSpace * 2]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:synBtn
                                                                     attribute:NSLayoutAttributeCenterX
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterX
                                                                    multiplier:1.0
                                                                      constant:0.f]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:synBtn
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:0.0
                                                                      constant:btnWidth]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:synBtn
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:0.0
                                                                      constant:btnHeight]];
    }
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

- (UIButton *)buttonWithTitle:(NSString *)titleName action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.layer.cornerRadius = 4;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1.f;
    button.layer.borderColor = kColor(255, 102, 36, 1).CGColor;
    [button setTitleColor:kColor(255, 102, 36, 1) forState:UIControlStateNormal];
    [button setTitleColor:kColor(134, 56, 0, 1) forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:10.f];
    [button setTitle:titleName forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)layoutView:(UIView *)view
      withPosition:(TMButtonPosition)position
        totalCount:(int)totalCount {
    CGFloat middleSpace = 10.f;
    CGFloat btnWidth = (kScreenWidth - 5 * middleSpace) / 4;
    CGFloat btnHeight = 28.f;
    [self.contentView addSubview:view];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_terminalLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:middleSpace * 2]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:btnWidth]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:btnHeight]];
    switch (totalCount) {
        case 1: {
            //总按钮数1个
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0
                                                                          constant:0.f]];
        }
            break;
        case 2: {
            //总按钮数2个
            if (position == TMButtonFirst) {
                //第一个
                [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                             attribute:NSLayoutAttributeRight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.contentView
                                                                             attribute:NSLayoutAttributeRight
                                                                            multiplier:.5
                                                                              constant:-middleSpace / 2]];
            }
            else {
                [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                             attribute:NSLayoutAttributeLeft
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.contentView
                                                                             attribute:NSLayoutAttributeCenterX
                                                                            multiplier:1.0
                                                                              constant:middleSpace / 2]];
            }
        }
            break;
        case 3: {
            //总按钮数3个
            if (position == TMButtonFirst) {
                [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                             attribute:NSLayoutAttributeRight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.contentView
                                                                             attribute:NSLayoutAttributeCenterX
                                                                            multiplier:1.0
                                                                              constant:-middleSpace - btnWidth / 2]];
            }
            else if (position == TMButtonSecond) {
                [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                             attribute:NSLayoutAttributeCenterX
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.contentView
                                                                             attribute:NSLayoutAttributeCenterX
                                                                            multiplier:1.0
                                                                              constant:0.f]];
            }
            else {
                [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                             attribute:NSLayoutAttributeLeft
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.contentView
                                                                             attribute:NSLayoutAttributeCenterX
                                                                            multiplier:1.0
                                                                              constant:middleSpace + btnWidth / 2]];
            }
        }
            break;
        case 4: {
            if (position == TMButtonFirst) {
                [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                             attribute:NSLayoutAttributeLeft
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.contentView
                                                                             attribute:NSLayoutAttributeLeft
                                                                            multiplier:1.0
                                                                              constant:middleSpace]];
            }
            else if (position == TMButtonSecond) {
                [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                             attribute:NSLayoutAttributeLeft
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.contentView
                                                                             attribute:NSLayoutAttributeLeft
                                                                            multiplier:1.0
                                                                              constant:middleSpace * 2 + btnWidth]];
            }
            else if (position == TMButtonThird) {
                [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                             attribute:NSLayoutAttributeLeft
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.contentView
                                                                             attribute:NSLayoutAttributeLeft
                                                                            multiplier:1.0
                                                                              constant:middleSpace * 3 + btnWidth * 2]];
            }
            else {
                [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                             attribute:NSLayoutAttributeRight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.contentView
                                                                             attribute:NSLayoutAttributeRight
                                                                            multiplier:1.0
                                                                              constant:-middleSpace]];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - Data

- (void)setContentsWithData:(TerminalManagerModel *)data {
    _cellData = data;
    self.terminalLabel.text = _cellData.TM_serialNumber;
    self.statusLabel.text = [_cellData getStatusString];
}

#pragma mark - Action

- (IBAction)videoAuth:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(terminalManagerVideoAuthWithData:)]) {
        [_delegate terminalManagerVideoAuthWithData:_cellData];
    }
}

- (IBAction)findPassword:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(terminalManagerFindPasswordWithData:)]) {
        [_delegate terminalManagerFindPasswordWithData:_cellData];
    }
}

- (IBAction)synchronization:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(terminalManagerSynchronizationWithData:)]) {
        [_delegate terminalManagerSynchronizationWithData:_cellData];
    }
}

- (IBAction)openApply:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(terminalManagerOpenApplyWithData:)]) {
        [_delegate terminalManagerOpenApplyWithData:_cellData];
    }
}

- (IBAction)openConfirm:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(terminalManagerOpenConfirmWithData:)]) {
        [_delegate terminalManagerOpenConfirmWithData:_cellData];
    }
}

@end
