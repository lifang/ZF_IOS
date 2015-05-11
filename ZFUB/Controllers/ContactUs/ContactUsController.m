//
//  ContactUsController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/19.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ContactUsController.h"
#import "IntentionViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

static NSString *s_phoneNumber = @"4000090876";

@interface ContactUsController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *panelView;

@property (nonatomic, strong) UIView *markView;

@end

@implementation ContactUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"联系我们";
    [self initAndLauoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 18 * kScaling)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
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
    [self initQRView];
}

- (void)initQRView {
    _panelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _panelView.backgroundColor = [UIColor blackColor];
    _panelView.alpha = 0.7;
    
    _markView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _markView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeQRView:)];
    [_markView addGestureRecognizer:tap];
    
    CGFloat borderSpace = 20.f;
    CGFloat imageSize = kScreenWidth - borderSpace * 2;
    CGFloat btnHeight = 40.f;
    CGFloat originY = kScreenHeight - imageSize - btnHeight * 4;
    
    UIImageView *qrView = [[UIImageView alloc] initWithFrame:CGRectMake(borderSpace, originY, imageSize, imageSize)];
    qrView.image = kImageName(@"qr.jpg");
    [_markView addSubview:qrView];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(borderSpace, originY + imageSize + btnHeight, imageSize, btnHeight);
    [saveBtn setBackgroundColor:[UIColor whiteColor]];
    [saveBtn setTitle:@"保存到本地" forState:UIControlStateNormal];
    [saveBtn setTitleColor:kColor(0, 122, 255, 1) forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
    saveBtn.layer.masksToBounds = YES;
    saveBtn.layer.cornerRadius = 6;
    [saveBtn addTarget:self action:@selector(saveQR:) forControlEvents:UIControlEventTouchUpInside];
    [_markView addSubview:saveBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(borderSpace, originY + imageSize + btnHeight * 2 + 10, imageSize, btnHeight);
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kColor(0, 122, 255, 1) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = 6;
    [cancelBtn addTarget:self action:@selector(removeQRView:) forControlEvents:UIControlEventTouchUpInside];
    [_markView addSubview:cancelBtn];
}

- (void)addQRView {
    [[AppDelegate shareAppDelegate].window addSubview:_panelView];
    [[AppDelegate shareAppDelegate].window addSubview:_markView];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *info = @"";
    if (error != NULL) {
        info = @"二维码保存失败";
    }
    else {
        info = @"二维码保存成功";
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.customView = [[UIImageView alloc] init];
    hud.mode = MBProgressHUDModeCustomView;
    [hud hide:YES afterDelay:1.f];
    hud.labelText = info;
}

#pragma mark - Action

- (IBAction)saveQR:(id)sender {
    [self removeQRView:nil];
    UIImage *image = [UIImage imageNamed:@"qr.jpg"];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (IBAction)removeQRView:(id)sender {
    [_panelView removeFromSuperview];
    [_markView removeFromSuperview];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Contact";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSString *title = nil;
    switch (indexPath.row) {
        case 0:
            title = @"填写购买意向单";
            break;
        case 1:
            title = @"联系客服400-009-0876";
            break;
        case 2:
            title = @"关注我们的微信";
            break;
        default:
            break;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.textLabel.text = title;
    if (indexPath.row == 2) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        imageView.image = kImageName(@"qrcode.png");
        cell.accessoryView = imageView;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {
            //购买意向单
            IntentionViewController *intentionC = [[IntentionViewController alloc] init];
            [self.navigationController pushViewController:intentionC animated:YES];
        }
            break;
        case 1: {
            //联系客服
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"拨打电话？"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                 destructiveButtonTitle:s_phoneNumber
                                                      otherButtonTitles:nil];
            [sheet showFromTabBar:self.tabBarController.tabBar];
        }
            break;
        case 2: {
            //微信
            [self addQRView];
        }
            break;
        default:
            break;
    }
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


#pragma mark - UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",s_phoneNumber]];
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
}

@end
