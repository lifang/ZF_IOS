//
//  RentDetailController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/4.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "RentDetailController.h"

@interface RentDetailController ()

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *applyTime;
@property (nonatomic, strong) NSString *terminalNum;
@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) NSString *modelName;
@property (nonatomic, strong) NSString *channelName;
@property (nonatomic, strong) NSString *merchantName;
@property (nonatomic, strong) NSString *merchantPhone;
@property (nonatomic, assign) CGFloat  rent;
@property (nonatomic, assign) CGFloat  deposit; //押金
@property (nonatomic, strong) NSString *rentDuration;
@property (nonatomic, strong) NSString *maxDuration;
@property (nonatomic, strong) NSString *minDuration;
@property (nonatomic, assign) CGFloat  refund;
@property (nonatomic, strong) NSString *contact;
@property (nonatomic, strong) NSString *phoneNumber;

@end

@implementation RentDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initSubViews {
    CGFloat topSpace = 20.f;
    CGFloat leftSpace = 20.f;
    CGFloat rightSpce = 20.f;
    CGFloat space = 2.f;       //label之间垂直间距
    CGFloat lineSpace = 20.f;  //划线前后间距
    CGFloat titleLabelHeight = 20.f;
    
    //右侧按钮宽度
    CGFloat btnWidth = 80.f;
    
    //状态
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.font = [UIFont systemFontOfSize:18.f];
    [self.scrollView addSubview:statusLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.scrollView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:topSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpce - btnWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:30.f]];
    
    //申请时间
    UILabel *applyTimeLabel = [[UILabel alloc] init];
    [self setLabel:applyTimeLabel withTopView:statusLabel middleSpace:space];
    applyTimeLabel.textColor = [UIColor blackColor];
    //划线 90
    UIView *firstLine = [[UIView alloc] init];
    firstLine.translatesAutoresizingMaskIntoConstraints = NO;
    firstLine.backgroundColor = kColor(222, 220, 220, 1);
    [self.scrollView addSubview:firstLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:applyTimeLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:lineSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:1.0]];
    //终端信息 111
    UILabel *terminalTitleLabel = [[UILabel alloc] init];
    terminalTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    terminalTitleLabel.backgroundColor = [UIColor clearColor];
    terminalTitleLabel.textColor = kColor(108, 108, 108, 1);
    terminalTitleLabel.font = [UIFont systemFontOfSize:16.f];
    [self.scrollView addSubview:terminalTitleLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:terminalTitleLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:firstLine
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:lineSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:terminalTitleLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:terminalTitleLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpce]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:terminalTitleLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:titleLabelHeight]];
    //划线 133
    UIView *secondLine = [[UIView alloc] init];
    secondLine.translatesAutoresizingMaskIntoConstraints = NO;
    secondLine.backgroundColor = kColor(255, 102, 36, 1);
    [self.scrollView addSubview:secondLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:terminalTitleLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:space]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpce]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:1.0]];
    //终端号136
    UILabel *terminalNumberLabel = [[UILabel alloc] init];
    [self setLabel:terminalNumberLabel withTopView:secondLine middleSpace:space];
    //POS品牌
    UILabel *brandLabel = [[UILabel alloc] init];
    [self setLabel:brandLabel withTopView:terminalNumberLabel middleSpace:space];
    //POS型号
    UILabel *modelLabel = [[UILabel alloc] init];
    [self setLabel:modelLabel withTopView:brandLabel middleSpace:space];
    //支付平台
    UILabel *channelLabel = [[UILabel alloc] init];
    [self setLabel:channelLabel withTopView:modelLabel middleSpace:space];
    //商户名
    UILabel *merchantNameLabel = [[UILabel alloc] init];
    [self setLabel:merchantNameLabel withTopView:channelLabel middleSpace:space];
    //商户电话 236
    UILabel *merchantPhoneLabel = [[UILabel alloc] init];
    [self setLabel:merchantPhoneLabel withTopView:merchantNameLabel middleSpace:space];
    //租金
    UILabel *rentLabel = [[UILabel alloc] init];
    [self setLabel:rentLabel withTopView:merchantPhoneLabel middleSpace:space];
    //押金
    UILabel *depositLabel = [[UILabel alloc] init];
    [self setLabel:depositLabel withTopView:rentLabel middleSpace:space];
    //时长
    UILabel *durationLabel = [[UILabel alloc] init];
    [self setLabel:durationLabel withTopView:depositLabel middleSpace:space];
    //最长
    UILabel *maxLabel = [[UILabel alloc] init];
    [self setLabel:maxLabel withTopView:durationLabel middleSpace:space];
    //最短
    UILabel *minLabel = [[UILabel alloc] init];
    [self setLabel:minLabel withTopView:maxLabel middleSpace:space];

    //退货信息 374
    UILabel *returnLabel = [[UILabel alloc] init];
    returnLabel.translatesAutoresizingMaskIntoConstraints = NO;
    returnLabel.backgroundColor = [UIColor clearColor];
    returnLabel.textColor = kColor(108, 108, 108, 1);
    returnLabel.font = [UIFont systemFontOfSize:16.f];
    [self.scrollView addSubview:returnLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:returnLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:minLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:lineSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:returnLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:returnLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpce]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:returnLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:titleLabelHeight]];
    //划线 396
    UIView *thirdLine = [[UIView alloc] init];
    thirdLine.translatesAutoresizingMaskIntoConstraints = NO;
    thirdLine.backgroundColor = kColor(255, 102, 36, 1);
    [self.scrollView addSubview:thirdLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:returnLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:space]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdLine
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdLine
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpce]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:1.0]];
    //退货 399
    UILabel *moneyLabel = [[UILabel alloc] init];
    [self setLabel:moneyLabel withTopView:thirdLine middleSpace:space];
    //联系人
    UILabel *contactLabel = [[UILabel alloc] init];
    [self setLabel:contactLabel withTopView:moneyLabel middleSpace:space];
    //电话
    UILabel *phoneLabel = [[UILabel alloc] init];
    [self setLabel:phoneLabel withTopView:contactLabel middleSpace:space];
    
    CGFloat resourceHeight = 0.f;
    CGFloat tempHeight = lineSpace; //计算资料高度
    //资料
    if ([self.resources count] > 0) {
        UILabel *resourceLabel = [[UILabel alloc] init];
        resourceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        resourceLabel.backgroundColor = [UIColor clearColor];
        resourceLabel.textColor = kColor(108, 108, 108, 1);
        resourceLabel.font = [UIFont systemFontOfSize:16.f];
        resourceLabel.text = @"租赁退还申请资料";
        [self.scrollView addSubview:resourceLabel];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:resourceLabel
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:phoneLabel
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:tempHeight]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:resourceLabel
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:leftSpace]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:resourceLabel
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:-rightSpce]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:resourceLabel
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:titleLabelHeight]];
        //划线
        UIView *tempLine = [[UIView alloc] init];
        tempLine.translatesAutoresizingMaskIntoConstraints = NO;
        tempLine.backgroundColor = kColor(255, 102, 36, 1);
        [self.scrollView addSubview:tempLine];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tempLine
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:resourceLabel
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:space]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tempLine
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:leftSpace]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tempLine
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:-rightSpce]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tempLine
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:1.0]];
        tempHeight += titleLabelHeight + space * 2 + 1;
        //资料
        for (int i = 0; i < [self.resources count]; i++) {
            ResourceModel *model = [self.resources objectAtIndex:i];
            UILabel *resourceTitleLabel = [[UILabel alloc] init];
            resourceTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
            resourceTitleLabel.backgroundColor = [UIColor clearColor];
            resourceTitleLabel.font = [UIFont systemFontOfSize:13.f];
            resourceTitleLabel.textColor = kColor(108, 108, 108, 1);
            resourceTitleLabel.text = model.title;
            resourceTitleLabel.adjustsFontSizeToFitWidth = YES;
            [self.scrollView addSubview:resourceTitleLabel];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:resourceTitleLabel
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:phoneLabel
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:tempHeight]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:resourceTitleLabel
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0
                                                                   constant:leftSpace]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:resourceTitleLabel
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:0.0
                                                                   constant:80.f]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:resourceTitleLabel
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:40.f]];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            button.titleLabel.font = [UIFont systemFontOfSize:14.f];
            if (model.path && ![model.path isEqualToString:@""]) {
                [button setTitleColor:kColor(255, 102, 36, 1) forState:UIControlStateNormal];
                [button setTitleColor:kColor(134, 56, 0, 1) forState:UIControlStateHighlighted];
                [button setTitle:@"点击查看" forState:UIControlStateNormal];
                [button addTarget:self action:@selector(scanResource:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = i + 1;
            }
            else {
                [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [button setTitle:@"未提交" forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
            }
            button.tag = i + 1;
            [self.scrollView addSubview:button];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:phoneLabel
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:tempHeight]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:resourceTitleLabel
                                                                  attribute:NSLayoutAttributeRight
                                                                 multiplier:1.0
                                                                   constant:0.f]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:0.0
                                                                   constant:80.f]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:40.f]];
            tempHeight += 40.f;
        }
        resourceHeight = tempHeight;
    }
    //417
    CGFloat recordHeight = 0.f;
    //追踪记录
    if ([self.records count] > 0) {
        UILabel *tipLabel = [[UILabel alloc] init];
        [self setLabel:tipLabel withTopView:phoneLabel middleSpace:resourceHeight + lineSpace];
        tipLabel.font = [UIFont systemFontOfSize:10.f];
        tipLabel.text = @"追踪记录：";
        RecordView *recordView = [[RecordView alloc] initWithRecords:self.records
                                                               width:(kScreenWidth - leftSpace * 2)];
        recordView.translatesAutoresizingMaskIntoConstraints = NO;
        recordHeight = [recordView getHeight];
        [self.scrollView addSubview:recordView];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:recordView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:phoneLabel
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:lineSpace * 2 + resourceHeight]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:recordView
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:leftSpace]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:recordView
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:-rightSpce]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:recordView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:recordHeight]];
        [recordView initAndLayoutUI];
    }
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, 510 + resourceHeight + recordHeight);
    terminalTitleLabel.text = @"终端信息";
    returnLabel.text = @"退货信息";
    statusLabel.text = [CustomerServiceHandle getStatusStringWithCSType:self.csType status:self.status];
    applyTimeLabel.text = [NSString stringWithFormat:@"申请时间：%@",_applyTime];
    terminalNumberLabel.text = [NSString stringWithFormat:@"终 端  号  %@",_terminalNum];
    brandLabel.text = [NSString stringWithFormat:@"POS品牌  %@",_brandName];
    modelLabel.text = [NSString stringWithFormat:@"POS型号 %@",_modelName];
    channelLabel.text = [NSString stringWithFormat:@"支付平台  %@",_channelName];
    merchantNameLabel.text = [NSString stringWithFormat:@"商 户  名  %@",_merchantName];
    merchantPhoneLabel.text = [NSString stringWithFormat:@"商户电话  %@",_merchantPhone];
    rentLabel.text = [NSString stringWithFormat:@"租    金  ￥%.2f",_rent];
    depositLabel.text = [NSString stringWithFormat:@"租赁押金  ￥%.2f",_deposit];
    durationLabel.text = [NSString stringWithFormat:@"租赁时长  %@",_rentDuration];
    maxLabel.text = [NSString stringWithFormat:@"最长租赁日期  %@",_maxDuration];
    minLabel.text = [NSString stringWithFormat:@"最短租赁日期  %@",_minDuration];
    moneyLabel.text = [NSString stringWithFormat:@"退款金额  ￥%.2f",_refund];
    contactLabel.text = [NSString stringWithFormat:@"联 系  人  %@",_contact];
    phoneLabel.text = [NSString stringWithFormat:@"联系电话  %@",_phoneNumber];
    
    //添加按钮
    [self addButton];
}

- (void)addButton {
    switch ([_status intValue]) {
        case CSStatusFirst: {
            //待处理
            UIButton *cancelBtn = [self buttonWithTitle:@"取消申请" action:@selector(cancelApply:)];
            [self layoutButton:cancelBtn position:OperationBtnFirst];
        }
            break;
        case CSStatusSecond: {
            //退还中
            UIButton *sendBtn = [self buttonWithTitle:@"提交物流信息" action:@selector(send:)];
            [self layoutButton:sendBtn position:OperationBtnFirst];
        }
            break;
        case CSStatusThird:
            break;
        case CSStatusForth:
            break;
        case CSStatusFifth:
            break;
        default:
            break;
    }
}

#pragma mark - 重写

- (void)parseCSDetailDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _status = @"";
    _applyTime = @"";
    _terminalNum = @"";
    _brandName = @"";
    _modelName = @"";
    _channelName = @"";
    _merchantName = @"";
    _merchantPhone = @"";
    _rentDuration = @"";
    _maxDuration = @"";
    _minDuration = @"";
    _contact = @"";
    _phoneNumber = @"";
    NSDictionary *infoDict = [dict objectForKey:@"result"];
    if ([infoDict objectForKey:@"status"]) {
        _status = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"status"]];
    }
    if ([infoDict objectForKey:@"apply_time"]) {
        _applyTime = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"apply_time"]];
    }
    if ([infoDict objectForKey:@"terminal_num"]) {
        _terminalNum = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"terminal_num"]];
    }
    if ([infoDict objectForKey:@"brand_name"]) {
        _brandName = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"brand_name"]];
    }
    if ([infoDict objectForKey:@"brand_number"]) {
        _modelName = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"brand_number"]];
    }
    if ([infoDict objectForKey:@"zhifu_pingtai"]) {
        _channelName = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"zhifu_pingtai"]];
    }
    if ([infoDict objectForKey:@"merchant_name"]) {
        _merchantName = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"merchant_name"]];
    }
    if ([infoDict objectForKey:@"merchant_phone"]) {
        _merchantPhone = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"merchant_phone"]];
    }
    if ([infoDict objectForKey:@"lease_price"]) {
        _rent = [[infoDict objectForKey:@"lease_price"] floatValue] / 100;
    }
    if ([infoDict objectForKey:@"lease_deposit"]) {
        _deposit = [[infoDict objectForKey:@"lease_deposit"] floatValue] / 100;
    }
    if ([infoDict objectForKey:@"lease_length"]) {
        _rentDuration = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"lease_length"]];
    }
    if ([infoDict objectForKey:@"lease_max_time"]) {
        _maxDuration = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"lease_max_time"]];
    }
    if ([infoDict objectForKey:@"lease_min_time"]) {
        _minDuration = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"lease_min_time"]];
    }
    if ([infoDict objectForKey:@"return_price"]) {
        _refund = [[infoDict objectForKey:@"return_price"] floatValue] / 100;
    }
    if ([infoDict objectForKey:@"receiver_name"]) {
        _contact = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"receiver_name"]];
    }
    if ([infoDict objectForKey:@"receiver_phone"]) {
        _phoneNumber = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"receiver_phone"]];
    }
    id resourceObject = [infoDict objectForKey:@"resource_info"];
    if ([resourceObject isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [resourceObject count]; i++) {
            ResourceModel *model = [[ResourceModel alloc] initWithParseDictionary:[resourceObject objectAtIndex:i]];
            [self.resources addObject:model];
        }
    }
    id object = [[infoDict objectForKey:@"comments"] objectForKey:@"content"];
    if ([object isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [object count]; i++) {
            RecordModel *model = [[RecordModel alloc] initWithParseDictionary:[object objectAtIndex:i]];
            [self.records addObject:model];
        }
    }
    [self initSubViews];
}

#pragma mark - Action

- (IBAction)scanResource:(id)sender {
    UIButton *btn = (UIButton *)sender;
    ResourceModel *model = [self.resources objectAtIndex:btn.tag - 1];
    ChannelWebsiteController *websiteC = [[ChannelWebsiteController alloc] init];
    websiteC.title = @"资料详情";
    websiteC.urlString = model.path;
    [self.navigationController pushViewController:websiteC animated:YES];
}

- (IBAction)cancelApply:(id)sender {
    [self cancelApply];
}

- (IBAction)send:(id)sender {
    [self submitLogisticInfomaiton];
}

@end
