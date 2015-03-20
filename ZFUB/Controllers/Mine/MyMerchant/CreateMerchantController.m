//
//  CreateMerchantController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/31.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CreateMerchantController.h"

#define kInputViewTag  50
#define kImageViewTag  51

@interface CreateMerchantController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *textField_merchant;
@property (nonatomic, strong) UITextField *textField_person;
@property (nonatomic, strong) UITextField *textField_person_ID;
@property (nonatomic, strong) UITextField *textField_licence;
@property (nonatomic, strong) UITextField *textField_tax;
@property (nonatomic, strong) UITextField *textField_organzation;
@property (nonatomic, strong) UITextField *textField_location;
@property (nonatomic, strong) UITextField *textField_bank;
@property (nonatomic, strong) UITextField *textField_bank_ID;

@property (nonatomic, strong) NSMutableDictionary *imageDict; //保存上传的图片地址

@property (nonatomic, strong) NSString *cityID;

@end

@implementation CreateMerchantController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"创建商户";
    _imageDict = [[NSMutableDictionary alloc] init];
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.001)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *createButton = [UIButton buttonWithType:UIButtonTypeCustom];
    createButton.frame = CGRectMake(80, 20, kScreenWidth - 160, 40);
    createButton.layer.cornerRadius = 4;
    createButton.layer.masksToBounds = YES;
    createButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [createButton setTitle:@"创建" forState:UIControlStateNormal];
    [createButton setBackgroundImage:[UIImage imageNamed:@"orange.png"] forState:UIControlStateNormal];
    [createButton addTarget:self action:@selector(createMerchant:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:createButton];
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
    [self initPickerView];
    
    //初始化文本框
    _textField_merchant = [[UITextField alloc] init];
    _textField_person = [[UITextField alloc] init];
    _textField_person_ID = [[UITextField alloc] init];
    _textField_licence = [[UITextField alloc] init];
    _textField_tax = [[UITextField alloc] init];
    _textField_organzation = [[UITextField alloc] init];
    _textField_location = [[UITextField alloc] init];
    _textField_location.userInteractionEnabled = NO;
    _textField_bank = [[UITextField alloc] init];
    _textField_bank_ID = [[UITextField alloc] init];
    [self setAttrForInputView:_textField_merchant];
    [self setAttrForInputView:_textField_person];
    [self setAttrForInputView:_textField_person_ID];
    [self setAttrForInputView:_textField_licence];
    [self setAttrForInputView:_textField_tax];
    [self setAttrForInputView:_textField_organzation];
    [self setAttrForInputView:_textField_location];
    [self setAttrForInputView:_textField_bank];
    [self setAttrForInputView:_textField_bank_ID];
    _textField_merchant.placeholder = @"请输入商户名";
    _textField_person.placeholder = @"请输入法人姓名";
    _textField_person_ID.placeholder = @"请输入法人身份证号";
    _textField_licence.placeholder = @"请输入营业执照号";
    _textField_tax.placeholder = @"请输入税务证号";
    _textField_organzation.placeholder = @"请输入机构代码号";
    _textField_location.placeholder = @"请选择";
    _textField_bank.placeholder = @"请输入开户银行";
    _textField_bank_ID.placeholder = @"请输入银行许可证号";
}

- (void)setAttrForInputView:(UITextField *)textField {
    textField.borderStyle = UITextBorderStyleNone;
    textField.textAlignment = NSTextAlignmentRight;
    textField.font = [UIFont systemFontOfSize:14.f];
    textField.tag = kInputViewTag;
    textField.delegate = self;
    textField.textColor = kColor(108, 108, 108, 1);
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

#pragma mark - Action

- (IBAction)createMerchant:(id)sender {
    [_textField_merchant becomeFirstResponder];
    [_textField_merchant resignFirstResponder];
    [self pickerScrollOut];
    if (!_textField_merchant.text || [_textField_merchant.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入商户名";
        return;
    }
    if (!_textField_person.text || [_textField_person.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入法人姓名";
        return;
    }
    if (!_textField_person_ID.text || [_textField_person_ID.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入法人身份证号";
        return;
    }
    if (!_textField_licence.text || [_textField_licence.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入营业执照号";
        return;
    }
    if (!_textField_tax.text || [_textField_tax.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入税务证号";
        return;
    }
    if (!_textField_organzation.text || [_textField_organzation.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入组织机构代码证号";
        return;
    }
    if (!_cityID || [_cityID isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择商户所在地";
        return;
    }
    if (!_textField_bank.text || [_textField_bank.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入开户银行";
        return;
    }
    if (!_textField_bank_ID.text || [_textField_bank_ID.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入银行许可证号";
        return;
    }
    if (![_imageDict objectForKey:key_frontImage] || [[_imageDict objectForKey:key_frontImage] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请上传身份证照片正面";
        return;
    }
    if (![_imageDict objectForKey:key_backImage] || [[_imageDict objectForKey:key_backImage] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请上传身份证照片背面";
        return;
    }
    if (![_imageDict objectForKey:key_bodyImage] || [[_imageDict objectForKey:key_bodyImage] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请上传法人上半身照片";
        return;
    }
    if (![_imageDict objectForKey:key_licenseImage] || [[_imageDict objectForKey:key_licenseImage] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请上传营业执照照片";
        return;
    }
    if (![_imageDict objectForKey:key_taxImage] || [[_imageDict objectForKey:key_taxImage] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请上传税务证照片";
        return;
    }
    if (![_imageDict objectForKey:key_organizationImage] || [[_imageDict objectForKey:key_organizationImage] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请上传组织机构代码证照片";
        return;
    }
    if (![_imageDict objectForKey:key_bankImage] || [[_imageDict objectForKey:key_bankImage] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请上传银行开户许可证照片";
        return;
    }
    [self requestForCreateMerchant];
}

- (IBAction)modifyLocation:(id)sender {
    [self pickerScrollOut];
    NSInteger index = [self.pickerView selectedRowInComponent:1];
    _cityID = [NSString stringWithFormat:@"%@",[[self.cityArray objectAtIndex:index] objectForKey:@"id"]];
    NSString *cityName = [[self.cityArray objectAtIndex:index] objectForKey:@"name"];
    _textField_location.text = cityName;
}

#pragma mark - Request

- (void)requestForCreateMerchant {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface createMerchantWithToken:delegate.token userID:delegate.userID merchantName:_textField_merchant.text personName:_textField_person.text personID:_textField_person_ID.text licenseID:_textField_licence.text taxID:_textField_tax.text oraganID:_textField_organzation.text cityID:_cityID bankName:_textField_bank.text bankID:_textField_bank_ID.text frontPath:[_imageDict objectForKey:key_frontImage] backPath:[_imageDict objectForKey:key_backImage] bodyPath:[_imageDict objectForKey:key_bodyImage] licensePath:[_imageDict objectForKey:key_licenseImage] taxPath:[_imageDict objectForKey:key_taxImage] orgPath:[_imageDict objectForKey:key_organizationImage] bankPath:[_imageDict objectForKey:key_bankImage] finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"添加商户成功";
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshMerchantListNotification object:nil];
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

- (void)saveWithURLString:(NSString *)urlString {
    if (urlString && ![urlString isEqualToString:@""]) {
        [_imageDict setObject:urlString forKey:self.selectedImageKey];
    }
    [_tableView reloadData];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 7;
            break;
        case 1:
            row = 2;
            break;
        case 2:
            row = 7;
            break;
        default:
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    NSString *titleName = nil;
    if (indexPath.section == 0 || indexPath.section == 1) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        CGRect rect = CGRectMake(kScreenWidth - 170, (cell.frame.size.height - 30) / 2, 150, 30);
        switch (indexPath.section) {
            case 0: {
                switch (indexPath.row) {
                    case 0:
                        titleName = @"店铺名称（商户名）";
                        _textField_merchant.frame = rect;
                        [cell.contentView addSubview:_textField_merchant];
                        break;
                    case 1:
                        titleName = @"商户法人姓名";
                        _textField_person.frame = rect;
                        [cell.contentView addSubview:_textField_person];
                        break;
                    case 2:
                        titleName = @"商户法人身份证号";
                        _textField_person_ID.frame = rect;
                        [cell.contentView addSubview:_textField_person_ID];
                        break;
                    case 3:
                        titleName = @"营业执照登记号";
                        _textField_licence.frame = rect;
                        [cell.contentView addSubview:_textField_licence];
                        break;
                    case 4:
                        titleName = @"税务证号";
                        _textField_tax.frame = rect;
                        [cell.contentView addSubview:_textField_tax];
                        break;
                    case 5:
                        titleName = @"组织机构代码证号";
                        _textField_organzation.frame = rect;
                        [cell.contentView addSubview:_textField_organzation];
                        break;
                    case 6:
                        titleName = @"商户所在地";
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        _textField_location.frame = CGRectMake(rect.origin.x - 10, rect.origin.y, rect.size.width, rect.size.height);
                        [cell.contentView addSubview:_textField_location];
                        break;
                    default:
                        break;
                }
            }
                break;
            case 1: {
                switch (indexPath.row) {
                    case 0:
                        titleName = @"开户银行";
                        _textField_bank.frame = rect;
                        [cell.contentView addSubview:_textField_bank];
                        break;
                    case 1:
                        titleName = @"银行开户许可证号";
                        _textField_bank_ID.frame = rect;
                        [cell.contentView addSubview:_textField_bank_ID];
                    default:
                        break;
                }
            }
            default:
                break;
        }
    }
    else {
        NSString *detailName = @"上传照片";
        static NSString *imageIdentifier = @"imageIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:imageIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:imageIdentifier];
            CGRect rect = CGRectMake(kScreenWidth - 40, (cell.frame.size.height - 20) / 2, 20, 20);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
            imageView.image = kImageName(@"upload.png");
            imageView.tag = kImageViewTag;
            imageView.hidden = YES;
            [cell.contentView addSubview:imageView];
        }
        cell.detailTextLabel.textColor = kColor(255, 102, 36, 1);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:kImageViewTag];
        NSString *urlString = nil;
        switch (indexPath.row) {
            case 0:
                titleName = @"商户法人身份证照片正面";
                urlString = [_imageDict objectForKey:key_frontImage];
                break;
            case 1:
                titleName = @"商户法人身份证照片背面";
                urlString = [_imageDict objectForKey:key_backImage];
                break;
            case 2:
                titleName = @"商户法人上半身照片";
                urlString = [_imageDict objectForKey:key_bodyImage];
                break;
            case 3:
                titleName = @"营业执照照片";
                urlString = [_imageDict objectForKey:key_licenseImage];
                break;
            case 4:
                titleName = @"税务证照片";
                urlString = [_imageDict objectForKey:key_taxImage];
                break;
            case 5:
                titleName = @"组织机构代码证照片";
                urlString = [_imageDict objectForKey:key_organizationImage];
                break;
            case 6:
                titleName = @"银行开户许可证照片";
                urlString = [_imageDict objectForKey:key_bankImage];
                break;
            default:
                break;
        }
        if (urlString && ![urlString isEqualToString:@""]) {
            imageView.hidden = NO;
            cell.detailTextLabel.text = nil;
        }
        else {
            imageView.hidden = YES;
            cell.detailTextLabel.text = detailName;
        }
    }
    cell.textLabel.text = titleName;
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ((indexPath.section == 0 && indexPath.row != 6) || indexPath.section == 1) {
        UITextField *textfield = (UITextField *)[cell.contentView viewWithTag:kInputViewTag];
        if (textfield && textfield.userInteractionEnabled) {
            //输入框
            [textfield becomeFirstResponder];
        }
    }
    else if (indexPath.section == 0 && indexPath.row == 6) {
        [_textField_merchant becomeFirstResponder];
        [_textField_merchant resignFirstResponder];
        [self pickerScrollIn];
    }
    else if (indexPath.section == 2) {
        //上传图片
        NSString *key = nil;
        BOOL hasImage = NO;
        switch (indexPath.row) {
            case 0:
                key = key_frontImage;
                break;
            case 1:
                key = key_backImage;
                break;
            case 2:
                key = key_bodyImage;
                break;
            case 3:
                key = key_licenseImage;
                break;
            case 4:
                key = key_taxImage;
                break;
            case 5:
                key = key_organizationImage;
                break;
            case 6:
                key = key_bankImage;
                break;
            default:
                break;
        }
        hasImage = ([_imageDict objectForKey:key] && ![[_imageDict objectForKey:key] isEqualToString:@""]);
        [self selectedKey:key hasImage:hasImage];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20.f;
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect rect = [textField.superview convertRect:textField.frame toView:self.view];
    NSLog(@"%@",NSStringFromCGRect(rect));
}

@end
