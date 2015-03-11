//
//  AddressManagerController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "AddressManagerController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "AddressModel.h"
#import "AddressEditController.h"

@interface AddressManagerController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL isMultiDelete;

@property (nonatomic, strong) NSMutableArray *addressItems;

@end

@implementation AddressManagerController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"地址管理";
    _addressItems = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
    [self getAddressList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList:) name:RefreshAddressListNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
    [self initNavigationBarView];
    [self initContentView];
}

- (void)initNavigationBarView {
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(0, 0, 24, 24);
    [deleteButton setBackgroundImage:kImageName(@"merchant1.png") forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(multiDelete:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 24, 24);
    [addButton setBackgroundImage:kImageName(@"merchant2.png") forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置间距
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    spaceItem.width = -5;
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithCustomView:deleteButton];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:spaceItem,deleteItem,addItem, nil];
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
}

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footerView;
}

- (void)setIsMultiDelete:(BOOL)isMultiDelete {
    _isMultiDelete = isMultiDelete;
    [_tableView setEditing:_isMultiDelete animated:YES];
}

#pragma mark - Request

- (void)getAddressList {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getAddressListWithToken:delegate.token usedID:delegate.userID finished:^(BOOL success, NSData *response) {
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
                    [_addressItems removeAllObjects];
                    [self parseAddressListDataWithDict:object];
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

- (void)parseAddressListDataWithDict:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *addressList = [dict objectForKey:@"result"];
    for (int i = 0; i < [addressList count]; i++) {
        NSDictionary *addressDict = [addressList objectAtIndex:i];
        AddressModel *model = [[AddressModel alloc] initWithParseDictionary:addressDict];
        [_addressItems addObject:model];
    }
    [_tableView reloadData];
}

#pragma mark - Action

- (IBAction)multiDelete:(id)sender {
    self.isMultiDelete = !_isMultiDelete;
}

- (IBAction)addAddress:(id)sender {
    AddressEditController *modifyC = [[AddressEditController alloc] init];
    modifyC.type = AddressAdd;
    [self.navigationController pushViewController:modifyC animated:YES];
}


#pragma mark - UITableView


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_addressItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Address";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    AddressModel *model = [_addressItems objectAtIndex:indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
    cell.detailTextLabel.numberOfLines = 0;
    cell.textLabel.text = [NSString stringWithFormat:@"收件人：%@  %@",model.addressReceiver,model.addressPhone];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"收件地址：%@",model.address];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isMultiDelete) {
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }
    else {
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AddressModel *model = [_addressItems objectAtIndex:indexPath.row];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.labelText = @"加载中...";
        AppDelegate *delegate = [AppDelegate shareAppDelegate];
        [NetworkInterface deleteAddressWithToken:delegate.token addressID:model.addressID finished:^(BOOL success, NSData *response) {
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
                        [_addressItems removeObject:model];
                        [_tableView beginUpdates];
                        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                        [_tableView endUpdates];
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
    else if (editingStyle == 3) {
        NSLog(@"33333");
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isMultiDelete) {
        AddressModel *model = [_addressItems objectAtIndex:indexPath.row];
        AddressEditController *modifyC = [[AddressEditController alloc] init];
        modifyC.type = AddressModify;
        modifyC.address = model;
        [self.navigationController pushViewController:modifyC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
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

#pragma mark - NSNotification

- (void)refreshList:(NSNotification *)notification {
    [self getAddressList];
}

@end
