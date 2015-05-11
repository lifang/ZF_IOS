//
//  AddressEditController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "AddressEditController.h"
#import "CityHandle.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "RegularFormat.h"
#import "SelectedAddressController.h"
#import "OrderConfirmController.h"

@interface AddressEditController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *defaultBtn;

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UITextField *zipField;
@property (nonatomic, strong) UITextField *cityField;
@property (nonatomic, strong) UITextField *detailField;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, strong) NSArray *cityArray;  //pickerView 第二列

@property (nonatomic, strong) NSString *selectedCityID;

@end

@implementation AddressEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_type == AddressAdd) {
        self.title = @"新增地址";
    }
    else {
        self.title = @"修改地址";
    }
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    footerView.backgroundColor = [UIColor clearColor];
    
    _defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _defaultBtn.frame = CGRectMake(20, 20, 18, 18);
    [_defaultBtn setBackgroundImage:kImageName(@"btn_unselected.png") forState:UIControlStateNormal];
    [_defaultBtn setBackgroundImage:kImageName(@"btn_selected.png") forState:UIControlStateHighlighted];
    [_defaultBtn addTarget:self action:@selector(setDefaultAddress:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:_defaultBtn];
    
    UILabel *defaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, kScreenWidth - 40, 20)];
    defaultLabel.backgroundColor = [UIColor clearColor];
    defaultLabel.font = [UIFont systemFontOfSize:13.f];
    defaultLabel.text = @"设置为默认地址";
    defaultLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setDefaultAddress:)];
    [defaultLabel addGestureRecognizer:tap];
    [footerView addSubview:defaultLabel];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(80, 60, kScreenWidth - 160, 40);
    saveBtn.layer.cornerRadius = 4;
    saveBtn.layer.masksToBounds = YES;
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"orange.png"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveAddress:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:saveBtn];
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
    
    _nameField = [[UITextField alloc] init];
    [self setFieldAttr:_nameField withPlaceholder:@"姓名长度在20字符以内"];
    
    _phoneField = [[UITextField alloc] init];
    [self setFieldAttr:_phoneField withPlaceholder:@"请输入收件人手机"];
    
    _zipField = [[UITextField alloc] init];
    [self setFieldAttr:_zipField withPlaceholder:@"请输入邮编"];
    
    _cityField = [[UITextField alloc] init];
    _cityField.enabled = NO;
    [self setFieldAttr:_cityField withPlaceholder:@"请选择城市"];
    
    _detailField = [[UITextField alloc] init];
    [self setFieldAttr:_detailField withPlaceholder:@"请填写详细地址"];
    
    [self initPickerView];
    
    if (_type == AddressModify) {
        _nameField.text = _address.addressReceiver;
        _phoneField.text = _address.addressPhone;
        _zipField.text = _address.zipCode;
        _detailField.text = _address.address;
        _selectedCityID = _address.cityID;
        _cityField.text = [CityHandle getCityNameWithCityID:_address.cityID];
        [_pickerView selectRow:[CityHandle getProvinceIndexWithCityID:_address.cityID] inComponent:0 animated:NO];
        [_pickerView reloadAllComponents];
        [_pickerView selectRow:[CityHandle getCityIndexWithCityID:_address.cityID] inComponent:1 animated:NO];
        if ([_address.isDefault intValue] == AddressDefault) {
            _defaultBtn.selected = YES;
            [self btnSetSelected];
        }
    }
}

- (void)btnSetSelected {
    if (_defaultBtn.isSelected) {
        [_defaultBtn setBackgroundImage:kImageName(@"btn_selected.png") forState:UIControlStateNormal];
    }
    else {
        [_defaultBtn setBackgroundImage:kImageName(@"btn_unselected.png") forState:UIControlStateNormal];
    }
}

- (void)initPickerView {
    //pickerView
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 44)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(pickerScrollOut)];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(modifyLocation:)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil
                                                                               action:nil];
    [_toolbar setItems:[NSArray arrayWithObjects:cancelItem,spaceItem,finishItem, nil]];
    [self.view addSubview:_toolbar];
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 216)];
    _pickerView.backgroundColor = kColor(244, 243, 243, 1);
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    [self.view addSubview:_pickerView];
}

- (void)setFieldAttr:(UITextField *)textField withPlaceholder:(NSString *)placeholder {
    textField.delegate = self;
    textField.placeholder = placeholder;
    textField.textAlignment = NSTextAlignmentRight;
    textField.font = [UIFont systemFontOfSize:15.f];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

#pragma mark - Request 

- (void)modifyAddress {
    AddressType isDefault = AddressOther;
    if (_defaultBtn.isSelected) {
        isDefault = AddressDefault;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface modifyAddressWithToken:delegate.token userID:delegate.userID addressID:_address.addressID cityID:_selectedCityID receiverName:_nameField.text phoneNumber:_phoneField.text zipCode:_zipField.text address:_detailField.text isDefault:isDefault finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"地址修改成功";
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshAddressListNotification object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshSelectedAddressNotification object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
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

- (void)addAddress {
    AddressType isDefault = AddressOther;
    if (_defaultBtn.isSelected) {
        isDefault = AddressDefault;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface addAddressWithToken:delegate.token userID:delegate.userID cityID:_selectedCityID receiverName:_nameField.text phoneNumber:_phoneField.text zipCode:_zipField.text address:_detailField.text isDefault:isDefault finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    hud.labelText = @"新增地址成功";
                    if (_isFromOrder) {
                        NSLog(@"%@",[[object objectForKey:@"result"] class]);
                        if ([[object objectForKey:@"result"] isKindOfClass:[NSNumber class]]) {
                            int addressID = [[object objectForKey:@"result"] intValue];
                            AddressModel *newAddress = [self createAddressWithID:addressID];
                            NSDictionary *addressDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                         newAddress,newAddressKey,
                                                         nil];
                            [[NSNotificationCenter defaultCenter] postNotificationName:SelectedAddressNotification object:nil userInfo:addressDict];
                            UIViewController *orderController = nil;
                            for (UIViewController *controller in self.navigationController.childViewControllers) {
                                if ([controller isKindOfClass:[OrderConfirmController class]]) {
                                    orderController = controller;
                                    break;
                                }
                            }
                            if (orderController) {
                                [self.navigationController popToViewController:orderController animated:YES];
                            }
                        }
                        else {
                            [self updateAfterAddAddress];
                        }
                    }
                    else {
                        [self updateAfterAddAddress];
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

- (AddressModel *)createAddressWithID:(int)addressID {
    AddressModel *model = [[AddressModel alloc] init];
    model.addressID = [NSString stringWithFormat:@"%d",addressID];
    model.addressReceiver = _nameField.text;
    model.addressPhone = _phoneField.text;
    model.zipCode = _zipField.text;
    model.cityID = _selectedCityID;
    model.address = _detailField.text;
    return model;
}

- (void)updateAfterAddAddress {
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshAddressListNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshSelectedAddressNotification object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    CGRect rect = CGRectMake(80, 0, kScreenWidth - 110, cell.bounds.size.height);
    NSString *titleName = nil;
    switch (indexPath.row) {
        case 0: {
            titleName = @"收件人姓名";
            _nameField.frame = rect;
            [cell.contentView addSubview:_nameField];
        }
            break;
        case 1: {
            titleName = @"电话";
            _phoneField.frame = rect;
            [cell.contentView addSubview:_phoneField];
        }
            break;
        case 2: {
            titleName = @"邮编";
            _zipField.frame = rect;
            [cell.contentView addSubview:_zipField];
        }
            break;
        case 3: {
            titleName = @"选择省/市";
            _cityField.frame = rect;
            [cell.contentView addSubview:_cityField];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 4: {
            titleName = @"详细地址";
            _detailField.frame = rect;
            [cell.contentView addSubview:_detailField];
        }
            break;
        default:
            break;
    }
    cell.textLabel.text = titleName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 3) {
//        [_nameField becomeFirstResponder];
//        [_nameField resignFirstResponder];
        [self.editingField resignFirstResponder];
        [self pickerScrollIn];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
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

#pragma mark - Action

- (IBAction)saveAddress:(id)sender {
    if (!_nameField.text || [_nameField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写收件人姓名";
        return;
    }
    if (!_phoneField.text || [_phoneField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写收件人电话";
        return;
    }
//    if (!_zipField.text || [_zipField.text isEqualToString:@""]) {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//        hud.customView = [[UIImageView alloc] init];
//        hud.mode = MBProgressHUDModeCustomView;
//        [hud hide:YES afterDelay:1.f];
//        hud.labelText = @"请填写邮编";
//        return;
//    }
    if (!_cityField.text || [_cityField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择城市";
        return;
    }
    if (!_detailField.text || [_detailField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写详细地址";
        return;
    }
    if (!_nameField.text || [_nameField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"修改信息不能为空";
        return;
    }
    if ([RegularFormat stringLength:_nameField.text] > 20) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"联系人姓名必须在20字符以内";
        return;
    }
    if (!([RegularFormat isMobileNumber:_phoneField.text] || [RegularFormat isTelephoneNumber:_phoneField.text])) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写正确的电话";
        return;
    }
    if (!([RegularFormat isZipCode:_zipField.text])) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写正确的邮编";
        return;
    }
    if (_type == AddressModify) {
        [self modifyAddress];
    }
    else if (_type == AddressAdd) {
        [self addAddress];
    }
}

- (IBAction)setDefaultAddress:(id)sender {
    _defaultBtn.selected = !_defaultBtn.selected;
    [self btnSetSelected];
}

- (IBAction)modifyLocation:(id)sender {
    [self pickerScrollOut];
    NSInteger index = [_pickerView selectedRowInComponent:1];
    _selectedCityID = [NSString stringWithFormat:@"%@",[[_cityArray objectAtIndex:index] objectForKey:@"id"]];
    _cityField.text = [[_cityArray objectAtIndex:index] objectForKey:@"name"];
}

#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [[CityHandle shareProvinceList] count];
    }
    else {
        NSInteger provinceIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *provinceDict = [[CityHandle shareProvinceList] objectAtIndex:provinceIndex];
        _cityArray = [provinceDict objectForKey:@"cities"];
        return [_cityArray count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        //省
        NSDictionary *provinceDict = [[CityHandle shareProvinceList] objectAtIndex:row];
        return [provinceDict objectForKey:@"name"];
    }
    else {
        //市
        return [[_cityArray objectAtIndex:row] objectForKey:@"name"];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        //省
        [_pickerView reloadComponent:1];
    }
    else {
        _cityField.text = [[_cityArray objectAtIndex:row] objectForKey:@"name"];
    }
}

#pragma mark - UIPickerView

- (void)pickerScrollIn {
    [UIView animateWithDuration:.3f animations:^{
        _toolbar.frame = CGRectMake(0, kScreenHeight - 260, kScreenWidth, 44);
        _pickerView.frame = CGRectMake(0, kScreenHeight - 216, kScreenWidth, 216);
    }];
}

- (void)pickerScrollOut {
    [UIView animateWithDuration:.3f animations:^{
        _toolbar.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 44);
        _pickerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216);
    }];
}

#pragma mark - UITextField

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.editingField = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.editingField = nil;
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self pickerScrollOut];
}

#pragma mark - 键盘

- (void)handleKeyboardDidShow:(NSNotification *)paramNotification {
    //获取键盘高度
    CGRect keyboardRect = [[[paramNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect fieldRect = [[self.editingField superview] convertRect:self.editingField.frame toView:self.view];
    CGFloat topHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat offsetY = keyboardRect.size.height - (kScreenHeight - topHeight - fieldRect.origin.y - fieldRect.size.height);
    if (offsetY > 0 && self.offset == 0) {
        self.primaryPoint = self.tableView.contentOffset;
        self.offset = offsetY;
        [self.tableView setContentOffset:CGPointMake(0, self.primaryPoint.y + self.offset) animated:YES];
    }
}

- (void)handleKeyboardDidHidden {
    if (self.offset != 0) {
        [self.tableView setContentOffset:CGPointMake(0, self.primaryPoint.y) animated:YES];
        self.offset = 0;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.editingField) {
        self.offset = 0;
        [self.editingField resignFirstResponder];
    }
}


@end
