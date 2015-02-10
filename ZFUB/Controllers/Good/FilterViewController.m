//
//  FilterViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/26.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *lowField;

@property (nonatomic, strong) UITextField *highField;

@property (nonatomic, strong) UISwitch *switchButton;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"筛选";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确认"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(filterFinished:)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(filterCanceled:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *signOut = [UIButton buttonWithType:UIButtonTypeCustom];
    signOut.frame = CGRectMake(80, 20, kScreenWidth - 160, 40);
    signOut.layer.cornerRadius = 4;
    signOut.layer.masksToBounds = YES;
    signOut.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [signOut setTitle:@"确认" forState:UIControlStateNormal];
    [signOut setBackgroundImage:[UIImage imageNamed:@"orange.png"] forState:UIControlStateNormal];
    [signOut addTarget:self action:@selector(filterFinished:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:signOut];
    _tableView.tableFooterView = footerView;
}

- (void)initAndLayoutUI {
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
    [self initInputView];
}

- (void)initInputView {
    _switchButton = [[UISwitch alloc] init];
    _switchButton.onTintColor = kColor(255, 102, 36, 1);
    _lowField = [[UITextField alloc] init];
    _lowField.font = [UIFont systemFontOfSize:14.f];
    _lowField.backgroundColor = [UIColor clearColor];
    _lowField.textAlignment = NSTextAlignmentRight;
    _lowField.placeholder = @"200";
    _lowField.delegate = self;
    _highField = [[UITextField alloc] init];
    _highField.font = [UIFont systemFontOfSize:14.f];
    _highField.backgroundColor = [UIColor clearColor];
    _highField.placeholder = @"300";
    _highField.textAlignment = NSTextAlignmentRight;
    _highField.delegate = self;
}

#pragma mark - Action

- (IBAction)filterFinished:(id)sender {
    
}

- (IBAction)filterCanceled:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 1;
            break;
        case 1:
            row = 7;
            break;
        case 2:
            row = 2;
            break;
        default:
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    switch (indexPath.section) {
        case 0: {
            cell.textLabel.text = @"只包含租赁";
            _switchButton.frame = CGRectMake(kScreenWidth - 60, 6, 40, 30);
            [cell.contentView addSubview:_switchButton];
        }
            break;
        case 1: {
            NSString *titleName = nil;
            NSString *detailInfo = nil;
            switch (indexPath.row) {
                case 0:
                    titleName = @"选择POS品牌";
                    detailInfo = @"泰山";
                    break;
                case 1:
                    titleName = @"选择POS类型";
                    detailInfo = @"磁条";
                    break;
                case 2:
                    titleName = @"选择支付通道";
                    detailInfo = @"安付";
                    break;
                case 3:
                    titleName = @"选择支付卡类型";
                    detailInfo = @"";
                    break;
                case 4:
                    titleName = @"选择支付交易类型";
                    detailInfo = @"";
                    break;
                case 5:
                    titleName = @"选择签购单方式";
                    detailInfo = @"";
                    break;
                case 6:
                    titleName = @"选择对账日期";
                    detailInfo = @"";
                    break;
                default:
                    break;
            }
            cell.textLabel.text = titleName;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
            cell.detailTextLabel.text = detailInfo;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 2: {
            switch (indexPath.row) {
                case 0: {
                    cell.textLabel.text = @"最低价￥";
                    _lowField.frame = CGRectMake(kScreenWidth - 120, 0, 100, cell.frame.size.height);
                    [cell.contentView addSubview:_lowField];
                }
                    break;
                case 1: {
                    cell.textLabel.text = @"最高价￥";
                    _highField.frame = CGRectMake(kScreenWidth - 120, 0, 100, cell.frame.size.height);
                    [cell.contentView addSubview:_highField];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
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

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
