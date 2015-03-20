//
//  ProgressCheckViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ProgressCheckViewController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "ProgressModel.h"
#import "ProgressCell.h"
#import "RegularFormat.h"

@interface ProgressCheckViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *inputField;

@property (nonatomic, strong) UIButton *searchBtn;

@property (nonatomic, strong) NSMutableArray *dataItem;

@end

@implementation ProgressCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申请开通进度查询";
    self.view.backgroundColor = [UIColor whiteColor];
    _dataItem = [[NSMutableArray alloc] init];
    [self initAndLauoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    
    
    CGFloat btnWidth = 80.f;
    CGFloat middleSpace = 10.f;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    backView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:backView];
    
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kLineHeight)];
    firstLine.backgroundColor = kColor(200, 199, 204, 1);
    [backView addSubview:firstLine];
    
    _inputField = [[UITextField alloc] initWithFrame:CGRectMake(middleSpace, 0, kScreenWidth - btnWidth - 2 * middleSpace, 44)];
    _inputField.delegate = self;
    _inputField.placeholder = @"输入手机号";
    _inputField.font = [UIFont systemFontOfSize:15.f];
    _inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [backView addSubview:_inputField];
    
    _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchBtn.frame = CGRectMake(_inputField.frame.origin.x + _inputField.frame.size.width, 6, btnWidth, 32);
    _searchBtn.layer.cornerRadius = 4;
    _searchBtn.layer.masksToBounds = YES;
    _searchBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_searchBtn setTitle:@"查询" forState:UIControlStateNormal];
    [_searchBtn setBackgroundImage:[UIImage imageNamed:@"orange.png"] forState:UIControlStateNormal];
    [_searchBtn addTarget:self action:@selector(searchProgress:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_searchBtn];
    
    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(0, 44 - kLineHeight, kScreenWidth, kLineHeight)];
    secondLine.backgroundColor = kColor(200, 199, 204, 1);
    [backView addSubview:secondLine];
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footerView;
}

- (void)initAndLauoutUI {
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
}

#pragma mark - Request

- (void)getApplyProgress {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface searchTerminalStatusWithToken:delegate.token userID:delegate.userID phoneNumber:_inputField.text finished:^(BOOL success, NSData *response) {
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
                    [self parseProgressDataWithDictionary:object];
                    if ([[object objectForKey:@"result"] isKindOfClass:[NSArray class]] &&
                        [[object objectForKey:@"result"] count] <= 0) {
                        hud.labelText = @"未查到相关数据";
                    }
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

- (void)parseProgressDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    [_dataItem removeAllObjects];
    NSArray *infoList = [dict objectForKey:@"result"];
    for (int i = 0; i < [infoList count]; i++) {
        id progressDict = [infoList objectAtIndex:i];
        if ([progressDict isKindOfClass:[NSDictionary class]]) {
            ProgressModel *model = [[ProgressModel alloc] initWithParseDictionary:progressDict];
            [_dataItem addObject:model];
        }
    }
    [_tableView reloadData];
}

#pragma mark - Action

- (IBAction)searchProgress:(id)sender {
    if (!_inputField.text || [_inputField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入手机号";
        return;
    }
    if (!([RegularFormat isMobileNumber:_inputField.text] || [RegularFormat isTelephoneNumber:_inputField.text])) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写正确的手机号";
        return;
    }
    [self getApplyProgress];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataItem count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProgressCell *cell = [[ProgressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    ProgressModel *model = [_dataItem objectAtIndex:indexPath.row];
    [cell setContentsWithData:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProgressModel *model = [_dataItem objectAtIndex:indexPath.row];
    return kProgressPrimaryHeight + [model.openList count] * 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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


@end
