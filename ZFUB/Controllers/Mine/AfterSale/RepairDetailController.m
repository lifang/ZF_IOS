//
//  RepairDetailController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/4.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "RepairDetailController.h"

@interface RepairDetailController ()

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *applyTime;
@property (nonatomic, strong) NSString *terminalNum;
@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) NSString *modelName;
@property (nonatomic, strong) NSString *channelName;
@property (nonatomic, strong) NSString *merchantName;
@property (nonatomic, strong) NSString *merchantPhone;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *repairPrice;
@property (nonatomic, strong) NSString *detail;

@end

@implementation RepairDetailController

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
    
    //维修信息 274
    UILabel *repairLabel = [[UILabel alloc] init];
    repairLabel.translatesAutoresizingMaskIntoConstraints = NO;
    repairLabel.backgroundColor = [UIColor clearColor];
    repairLabel.textColor = kColor(108, 108, 108, 1);
    repairLabel.font = [UIFont systemFontOfSize:16.f];
    [self.scrollView addSubview:repairLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:repairLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:merchantPhoneLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:lineSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:repairLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:repairLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpce]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:repairLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:titleLabelHeight]];
    //划线 296
    UIView *thirdLine = [[UIView alloc] init];
    thirdLine.translatesAutoresizingMaskIntoConstraints = NO;
    thirdLine.backgroundColor = kColor(255, 102, 36, 1);
    [self.scrollView addSubview:thirdLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:repairLabel
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
    //收货地址 299
    UILabel *addressLabel = [[UILabel alloc] init];
    [self setLabel:addressLabel withTopView:thirdLine middleSpace:space];
    //维修费用
    UILabel *repairFeeLabel = [[UILabel alloc] init];
    [self setLabel:repairFeeLabel withTopView:addressLabel middleSpace:space];
    //故障描述
    UILabel *infoLabel = [[UILabel alloc] init];
    [self setLabel:infoLabel withTopView:repairFeeLabel middleSpace:space];
    
    //397
    CGFloat height = 0;
    //追踪记录
    if ([self.records count] > 0) {
        UILabel *tipLabel = [[UILabel alloc] init];
        [self setLabel:tipLabel withTopView:infoLabel middleSpace:lineSpace];
        tipLabel.font = [UIFont systemFontOfSize:10.f];
        tipLabel.text = @"追踪记录：";
        RecordView *recordView = [[RecordView alloc] initWithRecords:self.records
                                                               width:(kScreenWidth - leftSpace * 2)];
        recordView.translatesAutoresizingMaskIntoConstraints = NO;
        height = [recordView getHeight];
        [self.scrollView addSubview:recordView];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:recordView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:infoLabel
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:lineSpace * 2]];
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
                                                               constant:height]];
        [recordView initAndLayoutUI];
    }
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, 400 + height);
    terminalTitleLabel.text = @"终端信息";
    repairLabel.text = @"维修信息";
    statusLabel.text = [CustomerServiceHandle getStatusStringWithCSType:self.csType status:self.status];
    applyTimeLabel.text = [NSString stringWithFormat:@"申请时间：%@",_applyTime];
    terminalNumberLabel.text = [NSString stringWithFormat:@"终 端  号  %@",_terminalNum];
    brandLabel.text = [NSString stringWithFormat:@"POS品牌  %@",_brandName];
    modelLabel.text = [NSString stringWithFormat:@"POS型号 %@",_modelName];
    channelLabel.text = [NSString stringWithFormat:@"支付平台  %@",_channelName];
    merchantNameLabel.text = [NSString stringWithFormat:@"商 户  名  %@",_merchantName];
    merchantPhoneLabel.text = [NSString stringWithFormat:@"商户电话  %@",_merchantPhone];
    addressLabel.text = [NSString stringWithFormat:@"收货地址  %@",_address];
    repairFeeLabel.text = [NSString stringWithFormat:@"维修费用  %@",_repairPrice];
    infoLabel.text = [NSString stringWithFormat:@"故障描述  %@",_detail];
    
    //添加按钮
    [self addButton];
}

- (void)addButton {
    switch ([_status intValue]) {
        case CSStatusFirst: {
            //未付款
            UIButton *cancelBtn = [self buttonWithTitle:@"取消申请" action:@selector(cancelApply:)];
            [self layoutButton:cancelBtn position:OperationBtnFirst];
            
            UIButton *payBtn = [self buttonWithTitle:@"付款" action:@selector(payRepair:)];
            [self layoutButton:payBtn position:OperationBtnSecond];
        }
            break;
        case CSStatusSecond: {
            //待发回
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
    _address = @"";
    _repairPrice = @"";
    _detail = @"";
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
    if ([infoDict objectForKey:@"receiver_addr"]) {
        _address = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"receiver_addr"]];
    }
    if ([infoDict objectForKey:@"repair_price"]) {
        _repairPrice = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"repair_price"]];
    }
    if ([infoDict objectForKey:@"description"]) {
        _detail = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"description"]];
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

- (IBAction)cancelApply:(id)sender {
    
}

- (IBAction)payRepair:(id)sender {
    
}

- (IBAction)send:(id)sender {
    
}

@end
