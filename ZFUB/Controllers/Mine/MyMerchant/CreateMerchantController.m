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

@property (nonatomic, strong) UIImageView *imageView_person_first;
@property (nonatomic, strong) UIImageView *imageView_person_second;
@property (nonatomic, strong) UIImageView *imageView_person_third;
@property (nonatomic, strong) UIImageView *imageView_licence;
@property (nonatomic, strong) UIImageView *imageView_tax;
@property (nonatomic, strong) UIImageView *imageView_organzation;
@property (nonatomic, strong) UIImageView *imageView_bank;

@property (nonatomic, strong) UITableViewCell *selectedCell;

@end

@implementation CreateMerchantController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"创建商户";
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
    
    //图片框
    _imageView_person_first = [[UIImageView alloc] init];
    _imageView_person_second = [[UIImageView alloc] init];
    _imageView_person_third = [[UIImageView alloc] init];
    _imageView_licence = [[UIImageView alloc] init];
    _imageView_tax = [[UIImageView alloc] init];
    _imageView_organzation = [[UIImageView alloc] init];
    _imageView_bank = [[UIImageView alloc] init];
    [self setAttrForImageView:_imageView_person_first];
    [self setAttrForImageView:_imageView_person_second];
    [self setAttrForImageView:_imageView_person_third];
    [self setAttrForImageView:_imageView_licence];
    [self setAttrForImageView:_imageView_tax];
    [self setAttrForImageView:_imageView_organzation];
    [self setAttrForImageView:_imageView_bank];
    _imageView_person_first.hidden = YES;
    _imageView_person_second.hidden = YES;
    _imageView_person_third.hidden = YES;
    _imageView_licence.hidden = YES;
    _imageView_tax.hidden = YES;
    _imageView_organzation.hidden = YES;
    _imageView_bank.hidden = YES;
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

- (void)setAttrForImageView:(UIImageView *)imageView {
    imageView.image = kImageName(@"upload.png");
    imageView.tag = kImageViewTag;
}

#pragma mark - Action

- (IBAction)createMerchant:(id)sender {
    
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
        CGRect rect = CGRectMake(cell.frame.size.width - 170, (cell.frame.size.height - 30) / 2, 150, 30);
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
                        _textField_location.frame = CGRectMake(rect.origin.x - 5, rect.origin.y, rect.size.width, rect.size.height);
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        CGRect rect = CGRectMake(cell.frame.size.width - 40, (cell.frame.size.height - 20) / 2, 20, 20);
        cell.detailTextLabel.textColor = kColor(255, 102, 36, 1);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
        switch (indexPath.row) {
            case 0:
                titleName = @"商户法人身份证照片正面";
                _imageView_person_first.frame = rect;
                [cell.contentView addSubview:_imageView_person_first];
                if (_imageView_person_first.hidden) {
                    cell.detailTextLabel.text = @"上传照片";
                }
                break;
            case 1:
                titleName = @"商户法人身份证照片背面";
                _imageView_person_second.frame = rect;
                [cell.contentView addSubview:_imageView_person_second];
                if (_imageView_person_second.hidden) {
                    cell.detailTextLabel.text = @"上传照片";
                }
                break;
            case 2:
                titleName = @"商户法人上半身照片";
                _imageView_person_third.frame = rect;
                [cell.contentView addSubview:_imageView_person_third];
                if (_imageView_person_third.hidden) {
                    cell.detailTextLabel.text = @"上传照片";
                }
                break;
            case 3:
                titleName = @"营业执照照片";
                _imageView_licence.frame = rect;
                [cell.contentView addSubview:_imageView_licence];
                if (_imageView_licence.hidden) {
                    cell.detailTextLabel.text = @"上传照片";
                }
                break;
            case 4:
                titleName = @"税务证照片";
                _imageView_tax.frame = rect;
                [cell.contentView addSubview:_imageView_tax];
                if (_imageView_tax.hidden) {
                    cell.detailTextLabel.text = @"上传照片";
                }
                break;
            case 5:
                titleName = @"组织机构代码证照片";
                _imageView_organzation.frame = rect;
                [cell.contentView addSubview:_imageView_organzation];
                if (_imageView_organzation.hidden) {
                    cell.detailTextLabel.text = @"上传照片";
                }
                break;
            case 6:
                titleName = @"银行开户许可证照片";
                _imageView_bank.frame = rect;
                [cell.contentView addSubview:_imageView_bank];
                if (_imageView_bank.hidden) {
                    cell.detailTextLabel.text = @"上传照片";
                }
                break;
            default:
                break;
        }
    }
    cell.textLabel.text = titleName;
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    UITextField *textfield = (UITextField *)[_selectedCell.contentView viewWithTag:kInputViewTag];
    if (textfield && textfield.userInteractionEnabled) {
        //输入框
        [textfield becomeFirstResponder];
    }
    else {
        //图片框
        _selectedCell.detailTextLabel.text = nil;
        UIImageView *imageView = (UIImageView *)[_selectedCell.contentView viewWithTag:kImageViewTag];
        imageView.hidden = NO;
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

@end
