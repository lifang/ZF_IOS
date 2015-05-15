//
//  DealFlowViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/26.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "DealFlowViewController.h"
#import "RefreshView.h"
#import "AppDelegate.h"
#import "TerminalModel.h"
#import "TerminalSelectedController.h"
#import "TradeCell.h"
#import "StatisticDealFlowController.h"
#import "TradeDetailController.h"

typedef enum {
    TimeStart = 0,
    TimeEnd,
}TimeType;

static NSString *s_defaultTerminalNum = @"选择终端号";

@interface DealFlowViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshDelegate,TerminalSelectedDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UISegmentedControl *segmentControl;

@property (nonatomic, strong) UILabel *terminalLabel;
@property (nonatomic, strong) UIImageView *terminalView;
@property (nonatomic, strong) UIImageView *terminalArrowView;

@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, assign) TimeType timeType;

/***************上下拉刷新**********/
@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;

@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property (nonatomic, assign) int page;
/**********************************/

//保存获取的终端号
@property (nonatomic, strong) NSMutableArray *terminalItems;
//交易流水
@property (nonatomic, strong) NSMutableArray *tradeRecords;

@end

@implementation DealFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"交易流水";
    _terminalItems = [[NSMutableArray alloc] init];
    _tradeRecords = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
    [self getAllTerminalList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    [self layoutSubViewWithCell:cell];
}

#pragma mark - UI

- (void)initAndLayoutUI {
    [self initTerminalView];
    [self initContentView];
    [self initPickerView];
}

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    headerView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.tableHeaderView = headerView;
    NSArray *nameArray = [NSArray arrayWithObjects:
                          @"消费",
                          @"转账",
                          @"还款",
                          @"生活充值",
                          @"话费充值",
                          nil];
    CGFloat h_space = 20.f;
    CGFloat v_space = 10.f;
    _segmentControl = [[UISegmentedControl alloc] initWithItems:nameArray];
    _segmentControl.selectedSegmentIndex = 0;
    _segmentControl.frame = CGRectMake(h_space, v_space, kScreenWidth - h_space * 2, 30);
    _segmentControl.tintColor = kColor(255, 102, 36, 1);
    [_segmentControl addTarget:self action:@selector(typeChanged:) forControlEvents:UIControlEventValueChanged];
    NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIFont systemFontOfSize:12.f],NSFontAttributeName,
                              nil];
    [_segmentControl setTitleTextAttributes:attrDict forState:UIControlStateNormal];
    [headerView addSubview:_segmentControl];
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footerView;
}

- (void)initContentView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self setHeaderAndFooterView];
    [self.view addSubview:_tableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    _topRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, -80, self.view.bounds.size.width, 80)];
    _topRefreshView.direction = PullFromTop;
    _topRefreshView.delegate = self;
    [_tableView addSubview:_topRefreshView];
    
    _bottomRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    _bottomRefreshView.direction = PullFromBottom;
    _bottomRefreshView.delegate = self;
    _bottomRefreshView.hidden = YES;
    [_tableView addSubview:_bottomRefreshView];
}

- (void)initTerminalView {
    //终端号相关
    _terminalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    _terminalLabel.backgroundColor = [UIColor clearColor];
    _terminalLabel.font = [UIFont systemFontOfSize:15.f];
    _terminalLabel.textAlignment = NSTextAlignmentCenter;
    _terminalLabel.text = s_defaultTerminalNum;
    _terminalLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    _terminalView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 20)];
    _terminalView.image = kImageName(@"terminal.png");
    
    _terminalArrowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 9, 5)];
    _terminalArrowView.image = kImageName(@"arrow.png");
}

- (void)initPickerView {
    //日期选择相关控件
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 44)];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(pickerScrollOut)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    spaceItem.width = kScreenWidth - 60;
    [_toolbar setItems:[NSArray arrayWithObjects:spaceItem,finishItem, nil]];
    [self.view addSubview:_toolbar];
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 216)];
    _datePicker.backgroundColor = kColor(244, 243, 243, 1);
    [_datePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [self.view addSubview:self.datePicker];
}

//根据终端名长度布局
- (void)layoutSubViewWithCell:(UITableViewCell *)cell {
    CGSize size = CGSizeMake(kScreenWidth, 44);
    CGFloat space = 5.f;
    [_terminalLabel sizeToFit];
    CGRect rect = _terminalLabel.frame;
    if (rect.size.width > kScreenWidth - 80) {
        rect.size.width = kScreenWidth - 80;
        _terminalLabel.frame = rect;
    }
    _terminalLabel.frame = CGRectMake((size.width - _terminalLabel.bounds.size.width) / 2, 0, _terminalLabel.bounds.size.width, size.height);
    _terminalView.frame = CGRectMake(_terminalLabel.frame.origin.x - _terminalView.bounds.size.width - space, (size.height - _terminalView.bounds.size.height) / 2, 18, 20);
    _terminalArrowView.frame = CGRectMake(_terminalLabel.frame.origin.x + _terminalLabel.frame.size.width + space, (size.height - _terminalArrowView.bounds.size.height) / 2, 9, 5);
}

#pragma mark - Set

- (void)setStartTime:(NSString *)startTime {
    _startTime = startTime;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:1];
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = _startTime;
}

- (void)setEndTime:(NSString *)endTime {
    _endTime = endTime;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:1];
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = _endTime;
}

#pragma mark - Request

//获取终端号
- (void)getAllTerminalList {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getTerminalListWithToken:delegate.token userID:delegate.userID finished:^(BOOL success, NSData *response) {
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
                    [self parseTerminalDataWithDictionary:object];
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

- (void)firstLoadData {
    _page = 1;
    [self downloadDataWithPage:_page isMore:NO];
}

- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    TradeType tradeType = [self tradeTypeFromIndex:_segmentControl.selectedSegmentIndex];
    [NetworkInterface searchTradeRecordWithToken:delegate.token tradeType:tradeType terminalNumber:_terminalLabel.text startTime:_startTime endTime:_endTime page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            NSLog(@"!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    if (!isMore) {
                        [_tradeRecords removeAllObjects];
                    }
                    id list = [[object objectForKey:@"result"] objectForKey:@"list"];
                    if ([list isKindOfClass:[NSArray class]] && [list count] > 0) {
                        //有数据
                        self.page++;
                        [hud hide:YES];
                    }
                    else {
                        //无数据
                        hud.labelText = @"没有更多数据了...";
                    }
                    [self parseTradeDataWithDictionary:object];
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
        if (!isMore) {
            [self refreshViewFinishedLoadingWithDirection:PullFromTop];
        }
        else {
            [self refreshViewFinishedLoadingWithDirection:PullFromBottom];
        }
    }];
}

#pragma mark - Data

//解析终端信息
- (void)parseTerminalDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *terminalList = [dict objectForKey:@"result"];
    for (int i = 0; i < [terminalList count]; i++) {
        id terminalDict = [terminalList objectAtIndex:i];
        if ([terminalDict isKindOfClass:[NSDictionary class]]) {
            TerminalModel *terminal = [[TerminalModel alloc] initWithParseDictionary:terminalDict];
            [_terminalItems addObject:terminal];
        }
    }
}

- (void)parseTradeDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *tradeList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    for (int i = 0; i < [tradeList count]; i++) {
        TradeModel *trade = [[TradeModel alloc] initWithParseDictionary:[tradeList objectAtIndex:i]];
        [_tradeRecords addObject:trade];
    }
    [_tableView reloadData];
}

//将日期转化成字符串yyyy-MM-dd格式
- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [format stringFromDate:date];
    if ([dateString length] >= 10) {
        return [dateString substringToIndex:10];
    }
    return dateString;
}

//将yyyy-MM-dd格式字符串转化成日期
- (NSDate *)dateFromString:(NSString *)string {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    return [format dateFromString:string];
}

- (TradeType)tradeTypeFromIndex:(NSInteger)index {
    TradeType type = TradeTypeNone;
    switch (index) {
        case 0:
            type = TradeTypeConsume;
            break;
        case 1:
            type = TradeTypeTransfer;
            break;
        case 2:
            type = TradeTypeRepayment;
            break;
        case 3:
            type = TradeTypeLife;
            break;
        case 4:
            type = TradeTypeTelephoneFare;
            break;
        default:
            break;
    }
    return type;
}

#pragma mark - Action

- (IBAction)startSearch:(id)sender {
    [self pickerScrollOut];
    if ([_terminalLabel.text isEqualToString:s_defaultTerminalNum]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请选择终端号"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (!_startTime || [_startTime isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请选择开始时间"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (!_endTime || [_endTime isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请选择结束时间"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSDate *start = [self dateFromString:_startTime];
    NSDate *end = [self dateFromString:_endTime];
    if (!([start earlierDate:end] == start)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"开始时间不能晚于结束时间"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self firstLoadData];
}

- (IBAction)startStatistic:(id)sender {
    if ([_terminalLabel.text isEqualToString:s_defaultTerminalNum]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请选择终端号"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (!_startTime || [_startTime isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请选择开始时间"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (!_endTime || [_endTime isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请选择结束时间"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSDate *start = [self dateFromString:_startTime];
    NSDate *end = [self dateFromString:_endTime];
    if (!([start earlierDate:end] == start)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"开始时间不能晚于结束时间"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    StatisticDealFlowController *statisticC = [[StatisticDealFlowController alloc] init];
    statisticC.startTime = _startTime;
    statisticC.endTime = _endTime;
    statisticC.terminalNumber = _terminalLabel.text;
    statisticC.tradeType = [self tradeTypeFromIndex:_segmentControl.selectedSegmentIndex];
    [self.navigationController pushViewController:statisticC animated:YES];
}

//datePicker滚动时调用方法
- (IBAction)timeChanged:(id)sender {
    if (_timeType == TimeStart) {
        self.startTime = [self stringFromDate:_datePicker.date];
    }
    else if (_timeType == TimeEnd) {
        self.endTime = [self stringFromDate:_datePicker.date];
    }
}

- (IBAction)typeChanged:(id)sender {
    [_tradeRecords removeAllObjects];
    [_tableView reloadData];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
            //终端号
            row = 1;
            break;
        case 1:
            //时间选择
            row = 2;
            break;
        case 2:
            //交易流水
            row = [_tradeRecords count];
            break;
        default:
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            static NSString *terminalIdentifier = @"terminalIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:terminalIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:terminalIdentifier];
                [cell.contentView addSubview:_terminalLabel];
                [cell.contentView addSubview:_terminalView];
                [cell.contentView addSubview:_terminalArrowView];
                [self layoutSubViewWithCell:cell];
            }
            return cell;
        }
            break;
        case 1: {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"选择开始时间";
                    cell.detailTextLabel.text = _startTime;
                    cell.imageView.image = kImageName(@"time.png");
                    break;
                case 1:
                    cell.textLabel.text = @"选择结束时间";
                    cell.detailTextLabel.text = _endTime;
                    cell.imageView.image = kImageName(@"time.png");
                    break;
                default:
                    break;
            }
            return cell;
        }
        case 2: {
            static NSString *cellIdentifier = @"TradeList";
            TradeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[TradeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            TradeModel *trade = [_tradeRecords objectAtIndex:indexPath.row];
            [cell setContentWithData:trade
                       withTradeType:[self tradeTypeFromIndex:_segmentControl.selectedSegmentIndex]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2 && [_tradeRecords count] > 0) {
        return 20.f;
    }
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = 0.001f;
    switch (section) {
        case 0:
            height = 5.f;
            break;
        case 1:
            height = 60.f;
            break;
        default:
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return kTradeCellHeight;
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2 && [_tradeRecords count] > 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20.f)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:12.f];
        label.text = @"      交易流水：";
        return label;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        footerView.backgroundColor = [UIColor clearColor];
        
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        searchBtn.frame = CGRectMake(20, 10, kScreenWidth / 2 - 40, 40);
        searchBtn.layer.cornerRadius = 4;
        searchBtn.layer.masksToBounds = YES;
        searchBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [searchBtn setTitle:@"开始查询" forState:UIControlStateNormal];
        [searchBtn setBackgroundImage:[UIImage imageNamed:@"orange.png"] forState:UIControlStateNormal];
        [searchBtn addTarget:self action:@selector(startSearch:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:searchBtn];
        
        UIButton *statisticBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        statisticBtn.frame = CGRectMake(kScreenWidth / 2 + 20, 10, kScreenWidth / 2 - 40, 40);
        statisticBtn.layer.cornerRadius = 4;
        statisticBtn.layer.masksToBounds = YES;
        statisticBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [statisticBtn setTitle:@"开始统计" forState:UIControlStateNormal];
        [statisticBtn setBackgroundImage:[UIImage imageNamed:@"orange.png"] forState:UIControlStateNormal];
        [statisticBtn addTarget:self action:@selector(startStatistic:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:statisticBtn];
        return footerView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        TerminalSelectedController *selectedC = [[TerminalSelectedController alloc] init];
        selectedC.delegate = self;
        selectedC.terminalItems = self.terminalItems;
        [self.navigationController pushViewController:selectedC animated:YES];
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            _timeType = TimeStart;
            [self pickerScrollIn];
        }
        else {
            _timeType = TimeEnd;
            [self pickerScrollIn];
        }
    }
    else if (indexPath.section == 2) {
        TradeModel *trade = [_tradeRecords objectAtIndex:indexPath.row];
        TradeDetailController *detailC = [[TradeDetailController alloc] init];
        detailC.tradeID = trade.tradeID;
        detailC.tradeType = [self tradeTypeFromIndex:_segmentControl.selectedSegmentIndex];
        [self.navigationController pushViewController:detailC animated:YES];
    }
}

#pragma mark - TerminalSelectedDelegate
//动态适应文字宽度
- (void)getSelectedTerminalNum:(NSString *)terminalNum {
    _terminalLabel.text = terminalNum;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    [self layoutSubViewWithCell:cell];
}

#pragma mark - UIPickerView

- (void)pickerScrollIn {
    if (_timeType == TimeStart) {
        if (_startTime && ![_startTime isEqualToString:@""]) {
            _datePicker.date = [self dateFromString:_startTime];
        }
        else {
            self.startTime = [self stringFromDate:_datePicker.date];
        }
    }
    else if (_timeType == TimeEnd) {
        if (_endTime && ![_endTime isEqualToString:@""]) {
            _datePicker.date = [self dateFromString:_endTime];
        }
        else {
            self.endTime = [self stringFromDate:_datePicker.date];
        }
    }
    [UIView animateWithDuration:.3f animations:^{
        _toolbar.frame = CGRectMake(0, kScreenHeight - 260, kScreenWidth, 44);
        _datePicker.frame = CGRectMake(0, kScreenHeight - 216, kScreenWidth, 216);
    }];
}

- (void)pickerScrollOut {
    [UIView animateWithDuration:.3f animations:^{
        _toolbar.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 44);
        _datePicker.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216);
    }];
}

#pragma mark - Refresh

- (void)refreshViewReloadData {
    _reloading = YES;
}

- (void)refreshViewFinishedLoadingWithDirection:(PullDirection)direction {
    _reloading = NO;
    if (direction == PullFromTop) {
        [_topRefreshView refreshViewDidFinishedLoading:_tableView];
    }
    else if (direction == PullFromBottom) {
        _bottomRefreshView.frame = CGRectMake(0, _tableView.contentSize.height, _tableView.bounds.size.width, 60);
        [_bottomRefreshView refreshViewDidFinishedLoading:_tableView];
    }
    [self updateFooterViewFrame];
}

- (BOOL)refreshViewIsLoading:(RefreshView *)view {
    return _reloading;
}

- (void)refreshViewDidEndTrackingForRefresh:(RefreshView *)view {
    [self refreshViewReloadData];
    //loading...
    if (view == _topRefreshView) {
        [self pullDownToLoadData];
    }
    else if (view == _bottomRefreshView) {
        [self pullUpToLoadData];
    }
}

- (void)updateFooterViewFrame {
    _bottomRefreshView.frame = CGRectMake(0, _tableView.contentSize.height, _tableView.bounds.size.width, 60);
    _bottomRefreshView.hidden = NO;
    if (_tableView.contentSize.height < _tableView.frame.size.height) {
        _bottomRefreshView.hidden = YES;
    }
}

#pragma mark - UIScrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _primaryOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView) {
        CGPoint newPoint = scrollView.contentOffset;
        if (_primaryOffsetY < newPoint.y) {
            //上拉
            if (_bottomRefreshView.hidden) {
                return;
            }
            [_bottomRefreshView refreshViewDidScroll:scrollView];
        }
        else {
            //下拉
            [_topRefreshView refreshViewDidScroll:scrollView];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == _tableView) {
        CGPoint newPoint = scrollView.contentOffset;
        if (_primaryOffsetY < newPoint.y) {
            //上拉
            if (_bottomRefreshView.hidden) {
                return;
            }
            [_bottomRefreshView refreshViewDidEndDragging:scrollView];
        }
        else {
            //下拉
            [_topRefreshView refreshViewDidEndDragging:scrollView];
        }
    }
}

#pragma mark - 上下拉刷新
//下拉刷新
- (void)pullDownToLoadData {
    [self firstLoadData];
}

//上拉加载
- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}

@end
