//
//  OrderConfirmController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "OrderConfirmController.h"
#import "KxMenu.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "SelectedAddressController.h"

@interface OrderConfirmController ()<UITextFieldDelegate,SelectedAddressDelegate>

@property (nonatomic, strong) UIButton *typeBtn;

@property (nonatomic, strong) UIView *detailFooterView;

@property (nonatomic, strong) UIView *billView;

@end

@implementation OrderConfirmController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单确认";
    self.view.backgroundColor = kColor(244, 243, 243, 1);
    _billType = BillTypeCompany;
    [self initAndLauoutUI];
    [self getAddressList];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getNewAddress:)
                                                 name:SelectedAddressNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    CGFloat hearderHeight = 90.f;
    CGFloat blackViewHeight = 80.f;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, hearderHeight)];
    headerView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.tableHeaderView = headerView;
    
    _addressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, blackViewHeight)];
    _addressView.backgroundColor = kColor(33, 32, 42, 1);
    UITapGestureRecognizer *addressTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedAddress:)];
    [_addressView addGestureRecognizer:addressTap];
    [headerView addSubview:_addressView];
    
    CGFloat topSpace = 15.f;
    CGFloat leftSpace = 20.f;
    CGFloat rightSpace = 30.f;
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, topSpace, 140, 20.f)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [_addressView addSubview:_nameLabel];

    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace + 140, topSpace, kScreenWidth - leftSpace - rightSpace - 140, 20.f)];
    _phoneLabel.backgroundColor = [UIColor clearColor];
    _phoneLabel.textColor = [UIColor whiteColor];
    _phoneLabel.font = [UIFont boldSystemFontOfSize:14.f];
    [_addressView addSubview:_phoneLabel];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, 35, kScreenWidth - leftSpace - rightSpace, 36.f)];
    _addressLabel.numberOfLines = 2;
    _addressLabel.backgroundColor = [UIColor clearColor];
    _addressLabel.textColor = [UIColor whiteColor];
    _addressLabel.font = [UIFont systemFontOfSize:14.f];
    [_addressView addSubview:_addressLabel];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 28, (hearderHeight - 24) / 2, 24, 24)];
    arrowView.image = kImageName(@"rightarrow.png");
    [_addressView addSubview:arrowView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100.f)];
    footerView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footerView;
    _billBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _billBtn.frame = CGRectMake(20, 10, 18, 18);
    [_billBtn setBackgroundImage:kImageName(@"btn_unselected.png") forState:UIControlStateNormal];
    [_billBtn setBackgroundImage:kImageName(@"btn_selected.png") forState:UIControlStateHighlighted];
    [_billBtn addTarget:self action:@selector(needBill:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:_billBtn];
    
    UILabel *billLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, kScreenWidth - 40, 20)];
    billLabel.backgroundColor = [UIColor clearColor];
    billLabel.font = [UIFont systemFontOfSize:13.f];
    billLabel.text = @"我要发票";
    billLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(needBill:)];
    [billLabel addGestureRecognizer:tap];
    [footerView addSubview:billLabel];
    
    [footerView addSubview:self.billView];
    self.billView.hidden = YES;
}

- (UIView *)billView {
    if (_billView) {
        return _billView;
    }
    CGFloat billHeight = 44.f;
    _billView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, billHeight)];
    _billView.backgroundColor = [UIColor whiteColor];
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    firstLine.backgroundColor = kColor(135, 135, 135, 1);
    [_billView addSubview:firstLine];
    
    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(0, billHeight - 0.5, kScreenWidth, 0.5)];
    secondLine.backgroundColor = kColor(135, 135, 135, 1);
    [_billView addSubview:secondLine];
    
    _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _typeBtn.frame = CGRectMake(10, 0, 60, 44);
    _typeBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [_typeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_typeBtn setTitle:@"公司" forState:UIControlStateNormal];
    [_typeBtn setImage:kImageName(@"arrow.png") forState:UIControlStateNormal];
    [_typeBtn addTarget:self action:@selector(billType:) forControlEvents:UIControlEventTouchUpInside];
    _typeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    _typeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [_billView addSubview:_typeBtn];
    
    _billField = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, kScreenWidth - 90, billHeight)];
    _billField.delegate = self;
    _billField.placeholder = @"请输入发票抬头";
    _billField.font = [UIFont systemFontOfSize:14.f];
    _billField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_billView addSubview:_billField];
    
    return _billView;
}

- (void)initAndLauoutUI {
    CGFloat footerHeight = 60.f;
    _detailFooterView = [[UIView alloc] init];
    _detailFooterView.translatesAutoresizingMaskIntoConstraints = NO;
    _detailFooterView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_detailFooterView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_detailFooterView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:-footerHeight]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_detailFooterView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_detailFooterView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_detailFooterView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    
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
                                                             toItem:_detailFooterView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self footerViewAddSubview];
    
    _reviewField = [[UITextField alloc] init];
    _reviewField.borderStyle = UITextBorderStyleLine;
    _reviewField.delegate = self;
    _reviewField.placeholder = @"留言";
    _reviewField.font = [UIFont systemFontOfSize:14.f];
    _reviewField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)footerViewAddSubview {
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    firstLine.backgroundColor = kColor(135, 135, 135, 1);
    [_detailFooterView addSubview:firstLine];
    CGFloat space = 10.f;
    CGFloat btnWidth = 60.f;
    CGFloat btnHeight = 36.f;
    
    _payLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 10, kScreenWidth - space * 3 - btnWidth, 20)];
    _payLabel.backgroundColor = [UIColor clearColor];
    _payLabel.font = [UIFont boldSystemFontOfSize:14.f];
    _payLabel.textAlignment = NSTextAlignmentRight;
    [_detailFooterView addSubview:_payLabel];
    
    _deliveryLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 30, kScreenWidth - space * 3 - btnWidth, 20)];
    _deliveryLabel.backgroundColor = [UIColor clearColor];
    _deliveryLabel.font = [UIFont systemFontOfSize:14.f];
    _deliveryLabel.textAlignment = NSTextAlignmentRight;
    [_detailFooterView addSubview:_deliveryLabel];
    
    UIButton *ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ensureButton.frame = CGRectMake(kScreenWidth - space - btnWidth, 12, btnWidth, btnHeight);
    ensureButton.layer.cornerRadius = 4.f;
    ensureButton.layer.masksToBounds = YES;
    [ensureButton setBackgroundImage:kImageName(@"orange.png") forState:UIControlStateNormal];
    [ensureButton setTitle:@"确认" forState:UIControlStateNormal];
    ensureButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [ensureButton addTarget:self action:@selector(ensureOrder:) forControlEvents:UIControlEventTouchUpInside];
    [_detailFooterView addSubview:ensureButton];
}

- (void)btnSetSelected {
    if (_billBtn.isSelected) {
        [_billBtn setBackgroundImage:kImageName(@"btn_selected.png") forState:UIControlStateNormal];
    }
    else {
        [_billBtn setBackgroundImage:kImageName(@"btn_unselected.png") forState:UIControlStateNormal];
    }
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
        if (i == 0) {
            _defaultAddress = model;
        }
        if ([model.isDefault intValue] == AddressDefault) {
            _defaultAddress = model;
            break;
        }
    }
    [self updateContentsForAddress];
}

- (void)updateContentsForAddress {
    NSString *person = @"";
    NSString *address = @"";
    if (_defaultAddress) {
        person = _defaultAddress.addressReceiver;
        address = _defaultAddress.address;
    }
    _nameLabel.text = [NSString stringWithFormat:@"收件人：%@",person];
    _phoneLabel.text = _defaultAddress.addressPhone;
    _addressLabel.text = [NSString stringWithFormat:@"收件地址：%@",address];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Action

- (IBAction)selectedAddress:(id)sender {
    SelectedAddressController *addressC = [[SelectedAddressController alloc] init];
    addressC.addressID = _defaultAddress.addressID;
    addressC.delegate = self;
    [self.navigationController pushViewController:addressC animated:YES];
}

- (IBAction)needBill:(id)sender {
    _billBtn.selected = !_billBtn.selected;
    [self btnSetSelected];
    if (_billBtn.isSelected) {
        self.billView.hidden = NO;
    }
    else {
        self.billView.hidden = YES;
    }
}

- (IBAction)billType:(id)sender {
    NSMutableArray *listArray = [NSMutableArray arrayWithObjects:
                                 [KxMenuItem menuItem:@"公司"
                                                image:nil
                                               target:self
                                               action:@selector(selectBillType:)
                                        selectedTitle:nil
                                                  tag:1],
                                 [KxMenuItem menuItem:@"个人"
                                                image:nil
                                               target:self
                                               action:@selector(selectBillType:)
                                        selectedTitle:nil
                                                  tag:2],
                                 nil];
    CGRect factRect = [[_typeBtn superview] convertRect:_typeBtn.frame toView:self.view];
    CGRect rect = CGRectMake(factRect.origin.x + factRect.size.width / 2, factRect.origin.y, 0, 0);
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:listArray];
}

- (IBAction)selectBillType:(KxMenuItem *)sender {
    if (sender.tag == 1) {
        _billType = BillTypeCompany;
        [_typeBtn setTitle:@"公司" forState:UIControlStateNormal];
    }
    else {
        _billType = BillTypePerson;
        [_typeBtn setTitle:@"个人" forState:UIControlStateNormal];
    }
}

- (IBAction)ensureOrder:(id)sender {
    //重写
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - SelectedAddressDelegate

- (void)getSelectedAddress:(AddressModel *)addressModel {
    self.defaultAddress = addressModel;
    [self updateContentsForAddress];
}

#pragma mark - NSNotification

- (void)getNewAddress:(NSNotification *)notification {
    id address = [notification.userInfo objectForKey:newAddressKey];
    if ([address isKindOfClass:[AddressModel class]]) {
        self.defaultAddress = address;
        [self updateContentsForAddress];
    }
}

@end
