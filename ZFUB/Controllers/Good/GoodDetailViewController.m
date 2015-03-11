//
//  GoodDetailViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/26.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "GoodDetailViewController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "GoodDetialModel.h"
#import "GoodButton.h"
#import "UIImageView+WebCache.h"
#import "FormView.h"

static CGFloat topImageHeight = 160.f;

@interface GoodDetailViewController ()

@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) UIScrollView *topScorllView;

@property (nonatomic, strong) GoodDetialModel *detailModel;

@property (nonatomic, strong) UIView *footerView;

//控件
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) GoodButton *buyButton;
@property (nonatomic, strong) GoodButton *rentButton;

@property (nonatomic, strong) UIButton *shopcartButton;  //购物车按钮
@property (nonatomic, strong) UIButton *buyGoodButton;   //立刻购买

@end

@implementation GoodDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品详情";
    self.view.backgroundColor = kColor(244, 243, 243, 1);
    [self downloadGoodDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
    CGFloat footerHeight = 60.f;
    //底部按钮
    _footerView = [[UIView alloc] init];
    _footerView.translatesAutoresizingMaskIntoConstraints = NO;
    _footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_footerView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_footerView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:-footerHeight]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_footerView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_footerView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_footerView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    [self footerViewAddSubview];
    
    _mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _mainScrollView.backgroundColor = kColor(244, 243, 243, 1);
    
    [self.view addSubview:_mainScrollView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mainScrollView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mainScrollView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mainScrollView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mainScrollView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_footerView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    //image
    _topScorllView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, topImageHeight)];
    _topScorllView.showsHorizontalScrollIndicator = NO;
    _topScorllView.showsVerticalScrollIndicator = NO;
    _topScorllView.backgroundColor = [UIColor blackColor];
    [_mainScrollView addSubview:_topScorllView];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.backgroundColor = [UIColor clearColor];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    
    _buyButton = [GoodButton buttonWithType:UIButtonTypeCustom];
    [_buyButton setButtonAttrWithTitle:@"购买"];
    [_buyButton addTarget:self action:@selector(buyGood:) forControlEvents:UIControlEventTouchUpInside];
    _buyButton.selected = YES;
    _rentButton = [GoodButton buttonWithType:UIButtonTypeCustom];
    [_rentButton setButtonAttrWithTitle:@"租赁"];
    [_rentButton addTarget:self action:@selector(rentGood:) forControlEvents:UIControlEventTouchUpInside];
    [self initSubViews];
}

- (void)footerViewAddSubview {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    line.backgroundColor = kColor(135, 135, 135, 1);
    [_footerView addSubview:line];
    CGFloat middleSpace = 10.f;
    CGFloat btnWidth = (kScreenWidth - 4 * middleSpace) / 2;
    CGFloat btnHeight = 36.f;
    _shopcartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _shopcartButton.frame = CGRectMake(middleSpace, 12, btnWidth, btnHeight);
    _shopcartButton.layer.cornerRadius = 4.f;
    _shopcartButton.layer.masksToBounds = YES;
    _shopcartButton.layer.borderWidth = 1.f;
    _shopcartButton.layer.borderColor = kColor(255, 102, 36, 1).CGColor;
    [_shopcartButton setTitleColor:kColor(255, 102, 36, 1) forState:UIControlStateNormal];
    [_shopcartButton setTitleColor:kColor(134, 56, 0, 1) forState:UIControlStateHighlighted];
    [_shopcartButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    _shopcartButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [_shopcartButton addTarget:self action:@selector(addShoppingCart:) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_shopcartButton];
    
    //立即购买
    _buyGoodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _buyGoodButton.frame = CGRectMake(btnWidth + 3 * middleSpace, 12, btnWidth, btnHeight);
    _buyGoodButton.layer.cornerRadius = 4.f;
    _buyGoodButton.layer.masksToBounds = YES;
    [_buyGoodButton setBackgroundImage:kImageName(@"orange.png") forState:UIControlStateNormal];
    [_buyGoodButton setTitle:@"立即购买" forState:UIControlStateNormal];
    _buyGoodButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [_buyGoodButton addTarget:self action:@selector(buyNow:) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_buyGoodButton];
}

- (void)initSubViews {
    CGFloat leftSpace = 20.f;  //左侧间距
    CGFloat rightSpace = 20.f; //右侧间距
    CGFloat labelHeight = 20.f; //label 高度
    CGFloat firstSpace = 5.f;
    CGFloat vSpace = 2.f;  //label 垂直间距
    CGFloat hSpace = 10.f;
    CGFloat leftLabelWidth = 60.f;  //左侧标题label宽度
    CGFloat btnHeight = 20.f;  //支付通道 和 购买方式 按钮高度
    CGFloat btnWidth = (kScreenWidth - leftSpace - rightSpace - leftLabelWidth - firstSpace - 2 * hSpace) / 3;
    CGFloat originY = _topScorllView.frame.origin.y + _topScorllView.frame.size.height + vSpace;
    //商品名
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, labelHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
    titleLabel.text = _detailModel.goodName;
    [_mainScrollView addSubview:titleLabel];
    
    originY += vSpace + labelHeight;
    //商品简介
    UILabel *summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, labelHeight)];
    summaryLabel.backgroundColor = [UIColor clearColor];
    summaryLabel.font = [UIFont systemFontOfSize:13.f];
    summaryLabel.textColor = [UIColor lightGrayColor];
    summaryLabel.text = _detailModel.detailName;
    [_mainScrollView addSubview:summaryLabel];
    
    originY += vSpace + labelHeight;
    //品牌
    UILabel *brandTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, leftLabelWidth, labelHeight)];
    [self setLabel:brandTitleLabel withTitle:@"品牌" font:[UIFont systemFontOfSize:13.f]];
    UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace + leftLabelWidth + firstSpace, originY, 80, labelHeight)];
    [self setLabel:brandLabel withTitle:_detailModel.goodBrand font:[UIFont boldSystemFontOfSize:13.f]];
    
    //价格
    CGFloat originX = leftSpace + leftLabelWidth + firstSpace + 80;
    _priceLabel.frame = CGRectMake(originX, originY, kScreenWidth - originX - rightSpace, labelHeight);
    [self setPriceWithString:[NSString stringWithFormat:@"%.2f",_detailModel.goodPrice]];
    [_mainScrollView addSubview:_priceLabel];
    
    originY += vSpace + labelHeight;
    //型号
    UILabel *modelTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, leftLabelWidth, labelHeight)];
    [self setLabel:modelTitleLabel withTitle:@"型号" font:[UIFont systemFontOfSize:13.f]];
    UILabel *modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace + leftLabelWidth + firstSpace, originY, 80, labelHeight)];
    [self setLabel:modelLabel withTitle:_detailModel.goodModel font:[UIFont boldSystemFontOfSize:13.f]];
    
    //已售
    UILabel *saleNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, kScreenWidth - originX - rightSpace, labelHeight)];
    saleNumberLabel.backgroundColor = [UIColor clearColor];
    saleNumberLabel.font = [UIFont systemFontOfSize:13.f];
    saleNumberLabel.textAlignment = NSTextAlignmentRight;
    saleNumberLabel.text = [NSString stringWithFormat:@"已售%d",[_detailModel.goodSaleNumber intValue]];
    [_mainScrollView addSubview:saleNumberLabel];
    
    originY += vSpace + labelHeight;
    //终端类型
    UILabel *terTypeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, leftLabelWidth, labelHeight)];
    [self setLabel:terTypeTitleLabel withTitle:@"终端类型" font:[UIFont systemFontOfSize:13.f]];
    UILabel *terTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace + leftLabelWidth + firstSpace, originY, kScreenWidth - leftSpace - rightSpace - leftLabelWidth, labelHeight)];
    [self setLabel:terTypeLabel withTitle:_detailModel.goodCategory font:[UIFont boldSystemFontOfSize:13.f]];
    
    //支付通道
    originY += labelHeight + 10.f;
    UILabel *channelTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, leftLabelWidth, btnHeight)];
    [self setLabel:channelTitleLabel withTitle:@"支付通道" font:[UIFont systemFontOfSize:13.f]];
    originX = leftSpace + leftLabelWidth + firstSpace;
    CGFloat channelOriginY = originY;
    for (int i = 0; i < [_detailModel.channelItem count]; i++) {
        if (i % 3 == 0 && i != 0) {
            originX = leftSpace + leftLabelWidth + firstSpace;
            channelOriginY += btnHeight + hSpace;
        }
        ChannelModel *model = [_detailModel.channelItem objectAtIndex:i];
        GoodButton *btn = [GoodButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(originX, channelOriginY, btnWidth, btnHeight);
        btn.ID = model.channelID;
        [btn setButtonAttrWithTitle:model.channelName];
        if ([model.channelID isEqualToString:_detailModel.defaultChannel.channelID]) {
            btn.selected = YES;
        }
        [btn addTarget:self action:@selector(selectedChannel:) forControlEvents:UIControlEventTouchUpInside];
        [_mainScrollView addSubview:btn];
        originX += btnWidth + hSpace;
    }
    int rows = (int)([_detailModel.channelItem count] - 1) / 3 + 1;
    originY += rows * (btnHeight + hSpace);
    
    //购买方式
    UILabel *buyTypeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, leftLabelWidth, btnHeight)];
    [self setLabel:buyTypeTitleLabel withTitle:@"购买方式" font:[UIFont systemFontOfSize:13.f]];
    _buyButton.frame = CGRectMake(leftSpace + leftLabelWidth + firstSpace, originY, btnWidth, btnHeight);
    [_mainScrollView addSubview:_buyButton];
    _rentButton.frame = CGRectMake(_buyButton.frame.origin.x + _buyButton.frame.size.width + hSpace, originY, btnWidth, btnHeight);
    [_mainScrollView addSubview:_rentButton];
    if (_detailModel.canRent) {
        _rentButton.hidden = NO;
    }
    else {
        _rentButton.hidden = YES;
    }
    
    //厂家信息
    originY += btnHeight + hSpace;
    UILabel *factoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, 90.f, labelHeight)];
    factoryLabel.backgroundColor = [UIColor clearColor];
    factoryLabel.font = [UIFont systemFontOfSize:12.f];
    factoryLabel.text = @"查看厂家信息";
    [_mainScrollView addSubview:factoryLabel];
    
    //厂家按钮
    UIButton *factoryBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    factoryBtn.frame = CGRectMake(factoryLabel.frame.origin.x + factoryLabel.frame.size.width + vSpace, originY, labelHeight, labelHeight);
    factoryBtn.enabled = NO;
    [factoryBtn addTarget:self action:@selector(scanFactoryInfo:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:factoryBtn];
    
    //划线
    originY += labelHeight + vSpace;
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(10, originY, kScreenWidth - 20, 1)];
    firstLine.backgroundColor = kColor(255, 102, 36, 1);
    [_mainScrollView addSubview:firstLine];
    
    //厂家图片
    originY += vSpace + 1;
    UIImageView *factoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftSpace, originY, leftLabelWidth, labelHeight)];
    [factoryImageView sd_setImageWithURL:[NSURL URLWithString:_detailModel.factoryImagePath]];
    [_mainScrollView addSubview:factoryImageView];
    //厂家网址
    UILabel *websiteLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace + leftLabelWidth, originY, kScreenWidth - leftLabelWidth - leftSpace, labelHeight)];
    [self setLabel:websiteLabel withTitle:_detailModel.factoryWebsite font:[UIFont systemFontOfSize:13.f]];
    
    //厂家简介
    originY += vSpace + labelHeight;
    CGFloat summaryHeight = [self heightWithString:_detailModel.factorySummary
                                             width:kScreenWidth - leftSpace - rightSpace
                                          fontSize:13.f];
    UILabel *factorySummaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, summaryHeight)];
    [self setLabel:factorySummaryLabel withTitle:_detailModel.factorySummary font:[UIFont systemFontOfSize:13.f]];
    
    //按钮view
    originY += summaryHeight + 10;
    UIView *handleView = [self handleViewWithOriginY:originY];
    [_mainScrollView addSubview:handleView];
    
    //pos信息
    originY += handleView.frame.size.height + 10;
    UILabel *posTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, labelHeight)];
    [self setLabel:posTitleLabel withTitle:@"POS信息" font:[UIFont systemFontOfSize:14.f]];
    
    //划线
    originY += labelHeight + vSpace;
    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(10, originY, kScreenWidth - 20, 1)];
    secondLine.backgroundColor = kColor(255, 102, 36, 1);
    [_mainScrollView addSubview:secondLine];
    
    //品牌型号
    originY += vSpace + 1;
    NSString *brandModel = [NSString stringWithFormat:@"%@%@",_detailModel.goodBrand,_detailModel.goodModel];
    [self addLabelWithTitle:@"品牌型号" content:brandModel offsetY:originY];
    //外壳
    originY += vSpace + labelHeight;
    [self addLabelWithTitle:@"外壳类型" content:_detailModel.goodMaterial offsetY:originY];
    //电池
    originY += vSpace + labelHeight;
    [self addLabelWithTitle:@"电池信息" content:_detailModel.goodBattery offsetY:originY];
    //签购单
    originY += vSpace +labelHeight;
    [self addLabelWithTitle:@"签购单打印方式" content:_detailModel.goodSignWay offsetY:originY];
    //加密卡
    originY += vSpace + labelHeight;
    [self addLabelWithTitle:@"加密卡方式" content:_detailModel.goodEncryptWay offsetY:originY];
    
    //支付通道信息
    originY += labelHeight + 10;
    UILabel *cTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, labelHeight)];
    [self setLabel:cTitleLabel withTitle:@"支付通道信息" font:[UIFont systemFontOfSize:13.f]];
    
    //划线
    originY += labelHeight + vSpace;
    UIView *thirdLine = [[UIView alloc] initWithFrame:CGRectMake(10, originY, kScreenWidth - 20, 1)];
    thirdLine.backgroundColor = kColor(255, 102, 36, 1);
    [_mainScrollView addSubview:thirdLine];
    
    //支持区域
    originY += vSpace + 1;
    NSString *area = [_detailModel.defaultChannel.supportAreaItem componentsJoinedByString:@" "];
    [self addLabelWithTitle:@"支持支付区域" content:area offsetY:originY];
    //注销
    originY += vSpace +labelHeight;
    NSString *cancelString = nil;
    if (_detailModel.defaultChannel.canCanceled) {
        cancelString = @"支持";
    }
    else {
        cancelString = @"不支持";
    }
    [self addLabelWithTitle:@"是否支持注销" content:cancelString offsetY:originY];
    
    //标准手续费
    originY += labelHeight + 10;
    CGFloat standFormHeight = [FormView heightWithRowCount:[_detailModel.defaultChannel.standRateItem count]
                                                  hasTitle:YES];
    FormView *standForm = [[FormView alloc] initWithFrame:CGRectMake(0, originY, kScreenWidth, standFormHeight)];
    [standForm setGoodDetailDataWithFormTitle:@"刷卡交易标准手续费"
                                      content:_detailModel.defaultChannel.standRateItem
                                   titleArray:[NSArray arrayWithObjects:@"商户类",@"费率",@"说明",nil]];
    [_mainScrollView addSubview:standForm];
    
    //资金服务费
    originY += standFormHeight + 10;
    CGFloat dateFormHeight = [FormView heightWithRowCount:[_detailModel.defaultChannel.dateRateItem count]
                                                 hasTitle:YES];
    FormView *dateForm = [[FormView alloc] initWithFrame:CGRectMake(0, originY, kScreenWidth, dateFormHeight)];
    [dateForm setGoodDetailDataWithFormTitle:@"资金服务费"
                                     content:_detailModel.defaultChannel.dateRateItem
                                  titleArray:[NSArray arrayWithObjects:@"结算周",@"费率",@"说明", nil]];
    [_mainScrollView addSubview:dateForm];
    
    //其它交易费率
    originY += dateFormHeight + 10;
    CGFloat otherFormHeight = [FormView heightWithRowCount:[_detailModel.defaultChannel.otherRateItem count]
                                                  hasTitle:YES];
    FormView *otherForm = [[FormView alloc] initWithFrame:CGRectMake(0, originY, kScreenWidth, otherFormHeight)];
    [otherForm setGoodDetailDataWithFormTitle:@"其它交易费率"
                                      content:_detailModel.defaultChannel.otherRateItem
                                   titleArray:[NSArray arrayWithObjects:@"交易类",@"费率",@"说明", nil]];
    [_mainScrollView addSubview:otherForm];
    
    originY += otherFormHeight + 10;
    
    _mainScrollView.contentSize = CGSizeMake(kScreenWidth, originY);
}

- (UIView *)handleViewWithOriginY:(CGFloat)originY {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, originY, kScreenWidth, 90)];
    view.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < 3; i++ ) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 45 * i - 1, kScreenWidth, 0.5f)];
        line.backgroundColor = kColor(201, 201, 201, 1);
        [view addSubview:line];
    }
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commentBtn.frame = CGRectMake(0, 0, kScreenWidth / 2, 45);
    [commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [commentBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [commentBtn setTitle:[NSString stringWithFormat:@"查看评论(%d)",[_detailModel.goodComment intValue]]
                forState:UIControlStateNormal
    ];
    [commentBtn addTarget:self action:@selector(scanComment:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:commentBtn];
    UIButton *rateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rateButton.frame = CGRectMake(kScreenWidth / 2, 0, kScreenWidth / 2, 45);
    [rateButton setTitle:@"交易费率" forState:UIControlStateNormal];
    [rateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rateButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [rateButton addTarget:self action:@selector(scanRate:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rateButton];
    UIButton *openButton = [UIButton buttonWithType:UIButtonTypeCustom];
    openButton.frame = CGRectMake(0, 45, kScreenWidth / 2, 45);
    [openButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [openButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [openButton setTitle:@"开通所需材料" forState:UIControlStateNormal];
    [openButton addTarget:self action:@selector(scanOpenInfo:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:openButton];
    if (_detailModel.canRent) {
        UIButton *rentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rentButton.frame = CGRectMake(kScreenWidth / 2, 45, kScreenWidth / 2, 45);
        [rentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [rentButton setTitle:@"租赁说明" forState:UIControlStateNormal];
        [rentButton addTarget:self action:@selector(scanRent:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:rentButton];
    }
    //竖线
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth / 2, 10, 0.5f, 25)];
    firstLine.backgroundColor = kColor(201, 201, 201, 1);
    [view addSubview:firstLine];
    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth / 2, 55, 0.5f, 25)];
    secondLine.backgroundColor = kColor(201, 201, 201, 1);
    [view addSubview:secondLine];
    return view;
}

//POS信息

- (void)addLabelWithTitle:(NSString *)title
                  content:(NSString *)content
                  offsetY:(CGFloat)offsetY {
    CGFloat leftSpace = 20.f;
    CGFloat titleLabelWidth = 100.f;
    CGFloat labelHeight = 20.f;
    CGFloat middleLeftSpace = leftSpace + titleLabelWidth + 5;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, offsetY, titleLabelWidth, labelHeight)];
    [self setLabel:titleLabel withTitle:title font:[UIFont systemFontOfSize:14.f]];
    [_mainScrollView addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(middleLeftSpace, offsetY, kScreenWidth - middleLeftSpace, labelHeight)];
    [self setLabel:contentLabel withTitle:content font:[UIFont systemFontOfSize:14.f]];
    
}

- (void)setLabel:(UILabel *)label withTitle:(NSString *)title font:(UIFont *)font{
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.text = title;
    [_mainScrollView addSubview:label];
}

- (void)setPriceWithString:(NSString *)price {
    NSString *priceString = [NSString stringWithFormat:@"价格￥%@",price];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:priceString];
    NSDictionary *normalAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont systemFontOfSize:13.f],NSFontAttributeName,
                                [UIColor lightGrayColor],NSForegroundColorAttributeName,
                                nil];
    NSDictionary *priceAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                               [UIFont boldSystemFontOfSize:14.f],NSFontAttributeName,
                               kColor(255, 102, 36, 1),NSForegroundColorAttributeName,
                               nil];
    [attrString addAttributes:normalAttr range:NSMakeRange(0, 2)];
    [attrString addAttributes:priceAttr range:NSMakeRange(2, [attrString length] - 2)];
    _priceLabel.attributedText = attrString;
}

#pragma mark - 计算

- (CGFloat)heightWithString:(NSString *)content
                      width:(CGFloat)width
                   fontSize:(CGFloat)fontSize {
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UIFont systemFontOfSize:fontSize],NSFontAttributeName,
                          nil];
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attr
                                        context:nil];
    return rect.size.height > 20.f ? rect.size.height : 20.f;
}

#pragma mark - Request

- (void)downloadGoodDetail {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface getGoodDetailWithCityID:delegate.cityID goodID:_goodID finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    [self parseGoodDetailDateWithDictionary:object];
                }
            }
            else {
                //返回错误数据
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
}

#pragma mark - Data

- (void)parseGoodDetailDateWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *detailDict = [dict objectForKey:@"result"];
    _detailModel = [[GoodDetialModel alloc] initWithParseDictionary:detailDict];
    [self initAndLayoutUI];
}

#pragma mark - Action

- (IBAction)selectedChannel:(id)sender {
    GoodButton *btn = (GoodButton *)sender;
    btn.selected = YES;
    if ([_detailModel.defaultChannel.channelID isEqualToString:btn.ID]) {
        NSLog(@"!");
    }
    else {
        NSLog(@"~~~");
        ChannelModel *newModel = nil;
        for (ChannelModel *model in _detailModel.channelItem) {
            if ([model.channelID isEqualToString:btn.ID]) {
                newModel = model;
                break;
            }
        }
        _detailModel.defaultChannel = newModel;
        for (UIView *view in _mainScrollView.subviews) {
            [view removeFromSuperview];
        }
        [self initSubViews];
    }
}

- (IBAction)buyGood:(id)sender {
    NSLog(@"buy ");
    _buyButton.selected = YES;
    _rentButton.selected = NO;
    
    _shopcartButton.enabled = YES;
    [_buyGoodButton setTitle:@"立即购买" forState:UIControlStateNormal];
}

- (IBAction)rentGood:(id)sender {
    NSLog(@"rent");
    _buyButton.selected = NO;
    _rentButton.selected = YES;
    
    _shopcartButton.enabled = NO;
    [_buyGoodButton setTitle:@"立即租赁" forState:UIControlStateNormal];
}

- (IBAction)scanFactoryInfo:(id)sender {
    
}

- (IBAction)scanComment:(id)sender {
    
}

- (IBAction)scanRate:(id)sender {
    
}

- (IBAction)scanOpenInfo:(id)sender {
    
}

- (IBAction)scanRent:(id)sender {
    
}

//加入购物车
- (IBAction)addShoppingCart:(id)sender {
    
}

//立即购买
- (IBAction)buyNow:(id)sender {
    
}

@end
