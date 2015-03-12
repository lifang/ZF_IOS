//
//  ApplyDetailController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ApplyDetailController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "ApplyOpenModel.h"
#import "MerchantSelectedController.h"
#import "CityHandle.h"
#import "BankSelectedController.h"

#define kTextViewTag   111

@interface ApplyInfoCell : UITableViewCell

@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) MaterialType type;

@end

@implementation ApplyInfoCell

@end

@interface InputTextField : UITextField

@property (nonatomic, strong) NSString *key;

@end

@implementation InputTextField


@end

@interface ApplyDetailController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ApplyMerchantSelectedDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentControl;

@property (nonatomic, assign) OpenApplyType applyType;  //对公 对私

@property (nonatomic, strong) ApplyOpenModel *applyData;

@property (nonatomic, strong) NSMutableDictionary *infoDict;

@property (nonatomic, strong) UILabel *brandLabel;
@property (nonatomic, strong) UILabel *modelLabel;
@property (nonatomic, strong) UILabel *terminalLabel;
@property (nonatomic, strong) UILabel *channelLabel;

//用于记录点击的是哪一行
@property (nonatomic, strong) NSString *selectedKey;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, strong) NSArray *cityArray;  //pickerView 第二列

//无作用 就是用来去掉cell中输入框的输入状态
@property (nonatomic, strong) UITextField *tempField;

@end

@implementation ApplyDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"开通申请";
    _applyType = OpenApplyPublic;
    _infoDict = [[NSMutableDictionary alloc] init];
    _tempField = [[UITextField alloc] init];
    _tempField.hidden = YES;
    [self.view addSubview:_tempField];
    [self initAndLayoutUI];
    [self beginApply];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    headerView.backgroundColor = kColor(234, 234, 234, 1);
    _tableView.tableHeaderView = headerView;
    NSArray *nameArray = [NSArray arrayWithObjects:
                          @"对公",
                          @"对私",
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
    
    UIView *terminalView = [self terminalInfoView];
    [headerView addSubview:terminalView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(80, 20, kScreenWidth - 160, 40);
    submitBtn.layer.cornerRadius = 4;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"orange.png"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitApply:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitBtn];
    _tableView.tableFooterView = footerView;
}

- (UIView *)terminalInfoView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 100)];
    view.backgroundColor = kColor(244, 243, 243, 1);
    CGFloat borderSpace = 20.f;
    CGFloat topSpace = 10.f;
    CGFloat labelHeight = 20.f;
    _brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(borderSpace, topSpace, kScreenWidth - borderSpace * 2, labelHeight)];
    _brandLabel.backgroundColor = [UIColor clearColor];
    _brandLabel.textColor = kColor(142, 141, 141, 1);
    _brandLabel.font = [UIFont systemFontOfSize:14.f];
    [view addSubview:_brandLabel];
    
    _modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(borderSpace, topSpace + labelHeight, kScreenWidth - borderSpace * 2, labelHeight)];
    _modelLabel.backgroundColor = [UIColor clearColor];
    _modelLabel.textColor = kColor(142, 141, 141, 1);
    _modelLabel.font = [UIFont systemFontOfSize:14.f];
    [view addSubview:_modelLabel];
    
    _terminalLabel = [[UILabel alloc] initWithFrame:CGRectMake(borderSpace, topSpace + labelHeight * 2, kScreenWidth - borderSpace * 2, labelHeight)];
    _terminalLabel.backgroundColor = [UIColor clearColor];
    _terminalLabel.textColor = kColor(142, 141, 141, 1);
    _terminalLabel.font = [UIFont systemFontOfSize:14.f];
    [view addSubview:_terminalLabel];
    
    _channelLabel = [[UILabel alloc] initWithFrame:CGRectMake(borderSpace, topSpace + labelHeight * 3, kScreenWidth - borderSpace * 2, labelHeight)];
    _channelLabel.backgroundColor = [UIColor clearColor];
    _channelLabel.textColor = kColor(142, 141, 141, 1);
    _channelLabel.font = [UIFont systemFontOfSize:14.f];
    [view addSubview:_channelLabel];
    
    return view;
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
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 216)];
    _datePicker.backgroundColor = kColor(244, 243, 243, 1);
    [_datePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [self.view addSubview:self.datePicker];
}

- (void)setTextFieldAttr:(InputTextField *)textField {
    textField.borderStyle = UITextBorderStyleNone;
    textField.textAlignment = NSTextAlignmentRight;
    textField.font = [UIFont systemFontOfSize:14.f];
    textField.tag = kTextViewTag;
    textField.delegate = self;
    textField.textColor = kColor(108, 108, 108, 1);
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

#pragma mark - Request

- (void)beginApply {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface beginToApplyWithToken:delegate.token userID:delegate.userID applyStatus:_applyType terminalID:_terminalID finished:^(BOOL success, NSData *response) {
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
                    [self parseApplyDataWithDictionary:object];
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

- (void)parseApplyDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *applyDict = [dict objectForKey:@"result"];
    ApplyOpenModel *model = [[ApplyOpenModel alloc] initWithParseDictionary:applyDict];
    _applyData = model;
    _brandLabel.text = [NSString stringWithFormat:@"POS品牌   %@",_applyData.brandName];
    _modelLabel.text = [NSString stringWithFormat:@"POS型号   %@",_applyData.modelNumber];
    _terminalLabel.text = [NSString stringWithFormat:@"终  端  号   %@",_applyData.terminalNumber];
    _channelLabel.text = [NSString stringWithFormat:@"支付通道   %@",_applyData.channelName];
    [_tableView reloadData];
}

//根据对公对私材料的id找到是否已经提交过材料
- (NSString *)getApplyValueForKey:(NSString *)key {
    if ([_applyData.applyList count] <= 0) {
        return nil;
    }
    for (ApplyInfoModel *model in _applyData.applyList) {
        if ([model.targetID isEqualToString:key]) {
            if (model.value && ![model.value isEqualToString:@""]) {
                [_infoDict setObject:model.value forKey:key];
            }
            return model.value;
        }
    }
    return nil;
}

- (void)parseImageUploadInfo:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *infoDict = [dict objectForKey:@"result"];
    NSString *urlString = [infoDict objectForKey:@"filePath"];
    if (urlString && ![urlString isEqualToString:@""]) {
        [_infoDict setObject:urlString forKey:_selectedKey];
    }
    [_tableView reloadData];
}

#pragma mark - 上传图片

- (void)uploadPictureWithImage:(UIImage *)image {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"上传中...";
    [NetworkInterface uploadMerchantImageWithImage:image finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"上传成功";
                    [self parseImageUploadInfo:object];
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

//点击图片行调用
- (void)showImageOption {
    UIActionSheet *sheet = nil;
    NSString *value = [_infoDict objectForKey:_selectedKey];
    if (value && ![value isEqualToString:@""]) {
        sheet = [[UIActionSheet alloc] initWithTitle:@""
                                            delegate:self
                                   cancelButtonTitle:@"取消"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@"查看照片",@"相册上传",@"拍照上传",nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@""
                                            delegate:self
                                   cancelButtonTitle:@"取消"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@"相册上传",@"拍照上传",nil];
    }
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger sourceType = UIImagePickerControllerSourceTypeCamera;
    NSString *value = [_infoDict objectForKey:_selectedKey];
    if (value && ![value isEqualToString:@""]) {
        if (buttonIndex == 0) {
            //查看大图
            return;
        }
        else if (buttonIndex == 1) {
            //相册
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        else if (buttonIndex == 2) {
            //拍照
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    else {
        if (buttonIndex == 0) {
            //相册
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        else if (buttonIndex == 1) {
            //拍照
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] &&
        buttonIndex != actionSheet.cancelButtonIndex) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self uploadPictureWithImage:editImage];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger section = 2;
    if ([_applyData.materialList count] > 0) {
        section = 3;
    }
    return section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 9;
            break;
        case 1:
            row = 6;
            break;
        case 2:
            row = [_applyData.materialList count];
        default:
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ApplyInfoCell *cell = nil;
    switch (indexPath.section) {
        case 0: {
            static NSString *firstIdentifier = @"firstIdentifier";
            cell = [tableView dequeueReusableCellWithIdentifier:firstIdentifier];
            if (cell == nil) {
                cell = [[ApplyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstIdentifier];
                CGRect rect = CGRectMake(cell.frame.size.width - 170, (cell.frame.size.height - 30) / 2, 150, 30);
                InputTextField *textField = [[InputTextField alloc] init];
                textField.frame = rect;
                [self setTextFieldAttr:textField];
                [cell.contentView addSubview:textField];
            }
            InputTextField *textFiled = (InputTextField *)[cell.contentView viewWithTag:kTextViewTag];
            NSString *textKey = nil;
            NSString *titleName = nil;
            switch (indexPath.row) {
                case 0:
                    textKey = key_selected;
                    titleName = @"选择已有商户";
                    break;
                case 1:
                    textKey = key_name;
                    titleName = @"姓名";
                    break;
                case 2:
                    textKey = key_merchantName;
                    titleName = @"店铺名称（商户名）";
                    break;
                case 3:
                    textKey = key_sex;
                    titleName = @"性别";
                    break;
                case 4:
                    textKey = key_birth;
                    titleName = @"选择生日";
                    break;
                case 5:
                    textKey = key_cardID;
                    titleName = @"身份证号";
                    break;
                case 6:
                    textKey = key_phone;
                    titleName = @"电话";
                    break;
                case 7:
                    textKey = key_email;
                    titleName = @"邮箱";
                    break;
                case 8:
                    textKey = key_location;
                    titleName = @"选择所在地";
                    break;
                default:
                    break;
            }
            textFiled.key = textKey;
            if (indexPath.row == 0 || indexPath.row == 4 || indexPath.row == 8) {
                CGRect rect = CGRectMake(cell.frame.size.width - 180, (cell.frame.size.height - 30) / 2, 150, 30);
                textFiled.frame = rect;
                textFiled.userInteractionEnabled = NO;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else {
                CGRect rect = CGRectMake(cell.frame.size.width - 170, (cell.frame.size.height - 30) / 2, 150, 30);
                textFiled.frame = rect;
                textFiled.userInteractionEnabled = YES;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            if ([_infoDict objectForKey:textKey]) {
                if (indexPath.row == 8) {
                    textFiled.text = [CityHandle getCityNameWithCityID:[_infoDict objectForKey:textKey]];
                }
                else {
                    textFiled.text = [_infoDict objectForKey:textKey];
                }
            }
            cell.key = textKey;
            cell.textLabel.text = titleName;
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
        }
            break;
        case 1: {
            static NSString *secondIdentifier = @"secondIdentifier";
            cell = [tableView dequeueReusableCellWithIdentifier:secondIdentifier];
            if (cell == nil) {
                cell = [[ApplyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:secondIdentifier];
                CGRect rect = CGRectMake(cell.frame.size.width - 170, (cell.frame.size.height - 30) / 2, 150, 30);
                InputTextField *textField = [[InputTextField alloc] init];
                textField.frame = rect;
                [self setTextFieldAttr:textField];
                [cell.contentView addSubview:textField];
            }
            InputTextField *textFiled = (InputTextField *)[cell.contentView viewWithTag:kTextViewTag];
            NSString *textKey = nil;
            NSString *titleName = nil;
            switch (indexPath.row) {
                case 0:
                    textKey = key_bank;
                    titleName = @"结算银行名称";
                    break;
                case 1:
                    textKey = key_bankID;
                    titleName = @"结算银行代码";
                    break;
                case 2:
                    textKey = key_bankAccount;
                    titleName = @"结算银行账户";
                    break;
                case 3:
                    textKey = key_taxID;
                    titleName = @"税务登记证号";
                    break;
                case 4:
                    textKey = key_organID;
                    titleName = @"组织机构号";
                    break;
                case 5:
                    textKey = key_channel;
                    titleName = @"支付通道";
                    break;
                default:
                    break;
            }
            textFiled.key = textKey;
            if (indexPath.row == 5) {
                CGRect rect = CGRectMake(cell.frame.size.width - 180, (cell.frame.size.height - 30) / 2, 150, 30);
                textFiled.frame = rect;
                textFiled.userInteractionEnabled = NO;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else {
                CGRect rect = CGRectMake(cell.frame.size.width - 170, (cell.frame.size.height - 30) / 2, 150, 30);
                textFiled.frame = rect;
                textFiled.userInteractionEnabled = YES;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            cell.key = textKey;
            cell.textLabel.text = titleName;
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
        }
            break;
        case 2: {
            MaterialModel *model = [_applyData.materialList objectAtIndex:indexPath.row];
            if (model.materialType == MaterialList) {
                //选项 银行
                cell = [[ApplyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                CGRect rect = CGRectMake(cell.frame.size.width - 180, (cell.frame.size.height - 30) / 2, 150, 30);
                InputTextField *textField = [[InputTextField alloc] init];
                textField.frame = rect;
                [self setTextFieldAttr:textField];
                textField.userInteractionEnabled = NO;
                textField.key = model.materialID;
                textField.text = [self getApplyValueForKey:textField.key];
                [cell.contentView addSubview:textField];
                cell.key = model.materialID;
                cell.type = MaterialList;
                cell.textLabel.text = model.materialName;
                cell.textLabel.font = [UIFont systemFontOfSize:15.f];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }
            else if (model.materialType == MaterialText) {
                //文字
                cell = [[ApplyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                CGRect rect = CGRectMake(cell.frame.size.width - 170, (cell.frame.size.height - 30) / 2, 150, 30);
                InputTextField *textField = [[InputTextField alloc] init];
                textField.frame = rect;
                [self setTextFieldAttr:textField];
                textField.key = model.materialID;
                textField.text = [self getApplyValueForKey:textField.key];
                [cell.contentView addSubview:textField];
                cell.key = model.materialID;
                cell.type = MaterialText;
                cell.textLabel.text = model.materialName;
                cell.textLabel.font = [UIFont systemFontOfSize:15.f];
                return cell;
            }
            else if (model.materialType == MaterialImage) {
                cell = [[ApplyInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
                CGRect rect = CGRectMake(cell.frame.size.width - 40, (cell.frame.size.height - 20) / 2, 20, 20);
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
                imageView.image = kImageName(@"upload.png");
                [cell.contentView addSubview:imageView];
                
                cell.key = model.materialID;
                cell.type = MaterialImage;
                cell.textLabel.text = model.materialName;
                cell.textLabel.font = [UIFont systemFontOfSize:15.f];
                [self getApplyValueForKey:cell.key];
                if ([_infoDict objectForKey:cell.key] && ![[_infoDict objectForKey:cell.key] isEqualToString:@""]) {
                    imageView.hidden = NO;
                    cell.detailTextLabel.text = nil;
                }
                else {
                    imageView.hidden = YES;
                    cell.detailTextLabel.text = @"上传照片";
                }
                cell.detailTextLabel.textColor = kColor(255, 102, 36, 1);
                cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
            }
            else {
                //其他 防止报错
                cell = [[ApplyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                return cell;
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_tempField becomeFirstResponder];
    [_tempField resignFirstResponder];
    if (indexPath.section == 0 || indexPath.section == 1) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            //选择商户
            MerchantSelectedController *selectedC = [[MerchantSelectedController alloc] init];
            selectedC.merchantItems = _applyData.merchantList;
            selectedC.delegate = self;
            [self.navigationController pushViewController:selectedC animated:YES];
        }
        else if (indexPath.section == 0 && indexPath.row == 4) {
            //选择生日
            ApplyInfoCell *cell = (ApplyInfoCell *)[_tableView cellForRowAtIndexPath:indexPath];
            _selectedKey = cell.key;
            [self pickerScrollIn];
        }
        else if (indexPath.section == 0 && indexPath.row == 8) {
            //选择所在地
            ApplyInfoCell *cell = (ApplyInfoCell *)[_tableView cellForRowAtIndexPath:indexPath];
            _selectedKey = cell.key;
            [self pickerScrollIn];
        }
        else if (indexPath.section == 1 && indexPath.row == 5) {
            //选择支付通道
        }
        else {
            ApplyInfoCell *cell = (ApplyInfoCell *)[_tableView cellForRowAtIndexPath:indexPath];
            InputTextField *textfield = (InputTextField *)[cell.contentView viewWithTag:kTextViewTag];
            if (textfield && textfield.userInteractionEnabled) {
                //输入框
                [textfield becomeFirstResponder];
            }
        }
    }
    else if (indexPath.section == 2) {
        ApplyInfoCell *cell = (ApplyInfoCell *)[_tableView cellForRowAtIndexPath:indexPath];
        if (cell.type == MaterialList) {
            //结算银行
            BankSelectedController *bankC = [[BankSelectedController alloc] init];
            [self.navigationController pushViewController:bankC animated:YES];
        }
        else if (cell.type == MaterialImage) {
            _selectedKey = cell.key;
            [self showImageOption];
        }
        else {
            InputTextField *textfield = (InputTextField *)[cell.contentView viewWithTag:kTextViewTag];
            if (textfield && textfield.userInteractionEnabled) {
                //输入框
                [textfield becomeFirstResponder];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20.f;
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
}

#pragma mark - UIPickerView

- (void)pickerScrollIn {
    if ([_selectedKey isEqualToString:key_location]) {
        NSString *cityID = [_infoDict objectForKey:key_location];
        [_pickerView selectRow:[CityHandle getProvinceIndexWithCityID:cityID] inComponent:0 animated:NO];
        [_pickerView reloadAllComponents];
        [_pickerView selectRow:[CityHandle getCityIndexWithCityID:cityID] inComponent:1 animated:NO];
        [UIView animateWithDuration:.3f animations:^{
            _toolbar.frame = CGRectMake(0, kScreenHeight - 260, kScreenWidth, 44);
            _pickerView.frame = CGRectMake(0, kScreenHeight - 216, kScreenWidth, 216);
            _datePicker.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216);
        }];
    }
    else if ([_selectedKey isEqualToString:key_birth]) {
        NSString *birth = [_infoDict objectForKey:key_birth];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        if (birth) {
            NSDate *birthDate = [format dateFromString:birth];
            _datePicker.date = birthDate;
        }
        else {
            [self timeChanged:nil];
        }
        [UIView animateWithDuration:.3f animations:^{
            _toolbar.frame = CGRectMake(0, kScreenHeight - 260, kScreenWidth, 44);
            _datePicker.frame = CGRectMake(0, kScreenHeight - 216, kScreenWidth, 216);
            _pickerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216);
        }];
    }
}

- (void)pickerScrollOut {
    [UIView animateWithDuration:.3f animations:^{
        _toolbar.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 44);
        _pickerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216);
        _datePicker.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216);
    }];
}

#pragma mark - Action

- (IBAction)typeChanged:(id)sender {
    if (_segmentControl.selectedSegmentIndex == 1) {
        _applyType = OpenApplyPrivate;
    }
    else {
        _applyType = OpenApplyPublic;
    }
    [self beginApply];
    NSLog(@"%d",_applyType);
}

- (IBAction)modifyLocation:(id)sender {
    [self pickerScrollOut];
    if ([_selectedKey isEqualToString:key_location]) {
        NSInteger index = [_pickerView selectedRowInComponent:1];
        NSString *cityID = [NSString stringWithFormat:@"%@",[[_cityArray objectAtIndex:index] objectForKey:@"id"]];
        //    NSString *cityName = [[_cityArray objectAtIndex:index] objectForKey:@"name"];
        [_infoDict setObject:cityID forKey:key_location];
    }
    else if ([_selectedKey isEqualToString:key_birth]) {
        
    }
    [_tableView reloadData];
}

//datePicker滚动时调用方法
- (IBAction)timeChanged:(id)sender {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [format stringFromDate:_datePicker.date];
    NSString *str_date = dateString;
    if ([dateString length] >= 10) {
        str_date = [dateString substringToIndex:10];
    }
    [_infoDict setObject:str_date forKey:key_birth];
}

- (IBAction)submitApply:(id)sender {
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self pickerScrollOut];
}

- (void)textFieldDidEndEditing:(InputTextField *)textField {
    if (textField.text && ![textField.text isEqualToString:@""]) {
        [_infoDict setObject:textField.text forKey:textField.key];
    }
}

#pragma mark - ApplyMerchantSelectedDelegate
//选中商户后 带入商户的一些信息
- (void)getSelectedMerchant:(MerchantDetailModel *)model {
    if (model.merchantPersonName && ![model.merchantPersonName isEqualToString:@""]) {
        [_infoDict setObject:model.merchantPersonName forKey:key_selected];
        [_infoDict setObject:model.merchantPersonName forKey:key_name];
    }
    if (model.merchantName && ![model.merchantName isEqualToString:@""]) {
        [_infoDict setObject:model.merchantName forKey:key_merchantName];
    }
    if (model.merchantPersonID && ![model.merchantPersonID isEqualToString:@""]) {
        [_infoDict setObject:model.merchantPersonID forKey:key_cardID];
    }
    if (model.merchantCityID && ![model.merchantCityID isEqualToString:@""]) {
        [_infoDict setObject:model.merchantCityID forKey:key_location];
    }
    if (model.merchantTaxID && ![model.merchantTaxID isEqualToString:@""]) {
        [_infoDict setObject:model.merchantTaxID forKey:key_taxID];
    }
    if (model.merchantOrganizationID && ![model.merchantOrganizationID isEqualToString:@""]) {
        [_infoDict setObject:model.merchantOrganizationID forKey:key_organID];
    }
    [_tableView reloadData];
}

@end
