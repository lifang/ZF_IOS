//
//  ChannelSelectedController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/16.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ChannelSelectedController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"

@interface ChannelSelectedController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *channelField;

@property (nonatomic, strong) NSMutableArray *channelItems;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, strong) NSArray *secondArray;  //pickerView 第二列


@end

@implementation ChannelSelectedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择支付通道";
    self.view.backgroundColor = kColor(244, 243, 243, 1);
    _channelItems = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
    [self getChannelList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
//    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
//    _tableView.backgroundColor = kColor(244, 243, 243, 1);
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    [self.view addSubview:_tableView];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
//                                                          attribute:NSLayoutAttributeTop
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeTop
//                                                         multiplier:1.0
//                                                           constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
//                                                          attribute:NSLayoutAttributeLeft
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeLeft
//                                                         multiplier:1.0
//                                                           constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
//                                                          attribute:NSLayoutAttributeRight
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeRight
//                                                         multiplier:1.0
//                                                           constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
//                                                          attribute:NSLayoutAttributeBottom
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeBottom
//                                                         multiplier:1.0
//                                                           constant:0]];
//    //输入框
//    CGFloat offsetX = 20.0f;
//    //支付通道
//    _channelField = [[UITextField alloc] init];
//    _channelField.borderStyle = UITextBorderStyleNone;
//    _channelField.backgroundColor = [UIColor clearColor];
//    _channelField.delegate = self;
//    _channelField.font = [UIFont systemFontOfSize:15.f];
//    UIView *channelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, offsetX, offsetX)];
//    _channelField.leftView = channelView;
//    _channelField.leftViewMode = UITextFieldViewModeAlways;
//    _channelField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _channelField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    _channelField.userInteractionEnabled = NO;
    
    [self initPickerView];
}

- (void)initPickerView {
    //pickerView
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight - 260, kScreenWidth, 44)];
//    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
//                                                                   style:UIBarButtonItemStyleDone
//                                                                  target:self
//                                                                  action:@selector(pickerScrollOut)];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(selectedChannel:)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil
                                                                               action:nil];
    [_toolbar setItems:[NSArray arrayWithObjects:spaceItem,finishItem, nil]];
    [self.view addSubview:_toolbar];
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 216, kScreenWidth, 216)];
    _pickerView.backgroundColor = kColor(244, 243, 243, 1);
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    [self.view addSubview:_pickerView];
}


#pragma mark - Request

- (void)getChannelList {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface selectedChannelWithToken:delegate.token finished:^(BOOL success, NSData *response) {
        NSLog(@"!!!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",[object objectForKey:@"code"]];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    [self parseChannelListWithDictionary:object];
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

- (void)parseChannelListWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *list = [dict objectForKey:@"result"];
    for (int i = 0; i < [list count]; i++) {
        NSDictionary *channelDict = [list objectAtIndex:i];
        ChannelListModel *model = [[ChannelListModel alloc] initWithParseDictionary:channelDict];
        [_channelItems addObject:model];
    }
    [_pickerView reloadAllComponents];
}

#pragma mark - Action

- (IBAction)selectedChannel:(id)sender {
//    [self pickerScrollOut];
    NSInteger firstIndex = [_pickerView selectedRowInComponent:0];
    NSInteger secondIndex = [_pickerView selectedRowInComponent:1];
    ChannelListModel *channel = nil;
    BillingModel *model = nil;
    if (firstIndex < [_channelItems count]) {
        channel = [_channelItems objectAtIndex:firstIndex];
    }
    if (secondIndex < [_secondArray count]) {
        model = [_secondArray objectAtIndex:secondIndex];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(getChannelList:billModel:)]) {
        [_delegate getChannelList:channel billModel:model];
    }
    _channelField.text = [NSString stringWithFormat:@"%@ %@",channel.channelName,model.billName];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    switch (indexPath.section) {
        case 0: {
            //
            _channelField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
            [cell.contentView addSubview:_channelField];
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return 2.f;
    }
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2.f;
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [_channelItems count];
    }
    else {
        NSInteger channelIndex = [pickerView selectedRowInComponent:0];
        if ([_channelItems count] > 0) {
            ChannelListModel *channel = [_channelItems objectAtIndex:channelIndex];
            _secondArray = channel.children;
            return [_secondArray count];
        }
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        //通道
        ChannelListModel *model = [_channelItems objectAtIndex:row];
        return model.channelName;
    }
    else {
        //结算时间
        if ([_secondArray count] > 0) {
            BillingModel *model = [_secondArray objectAtIndex:row];
            return model.billName;
        }
        return @"";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        //通道
        [_pickerView reloadComponent:1];
    }
}

//#pragma mark - UIPickerView
//
//- (void)pickerScrollIn {
//    [UIView animateWithDuration:.3f animations:^{
//        _toolbar.frame = CGRectMake(0, kScreenHeight - 260, kScreenWidth, 44);
//        _pickerView.frame = CGRectMake(0, kScreenHeight - 216, kScreenWidth, 216);
//    }];
//}
//
//- (void)pickerScrollOut {
//    [UIView animateWithDuration:.3f animations:^{
//        _toolbar.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 44);
//        _pickerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216);
//    }];
//}


@end
