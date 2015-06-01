//
//  NewRegisterViewController.m
//  ZFUB
//
//  Created by wufei on 15/5/11.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "NewRegisterViewController.h"
#import "MobileRegisterController.h"
#import "EmailRegisterController.h"
#import "RegularFormat.h"
#import "NetworkInterface.h"
#import "getCodeViewController.h"
#import "LocationViewController.h"
#import "FindPasswordViewController.h"
#import "MobClick.h"


@interface NewRegisterViewController ()<UITextFieldDelegate,LocationDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) UITextField *cityTF;

@property (nonatomic, strong) UITextField *phoneTF;

@property (nonatomic, strong) UIButton *sendBtn;

@property (nonatomic, strong) UITapGestureRecognizer * TAP;

@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSMutableArray *cityArray;

@property (nonatomic, strong) NSString *cityId;

@property (nonatomic, strong) NSString *codeNumber;

@property (nonatomic, strong) UIButton *forgetBtn;

@property (nonatomic, strong) UIButton *siginBtn;

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation NewRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.view.backgroundColor=[UIColor colorWithHexString:@"f4f3f3"];
   //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"layout_bg"]]];
    
    
    CGFloat topHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    self.primaryPoint = CGPointMake(0, self.view.frame.origin.y + topHeight);

    UIImageView *backgroundView = [[UIImageView alloc] init];
    backgroundView.image = kImageName(@"bkg");
    backgroundView.backgroundColor = [UIColor lightGrayColor];
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:backgroundView];
    [backgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    /*
    UIImageView *loginView = [[UIImageView alloc] init];
    loginView.image = kImageName(@"login_logo.png");
    loginView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:loginView];
    [loginView makeConstraints:^(MASConstraintMaker *make) {
       // make.top.equalTo(self.view.mas_top).offset(80);
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(@(self.view.frame.size.width));
        make.bottom.equalTo(self.view.centerY).offset(-60);
        make.height.equalTo(@((self.view.frame.size.height)*0.25));
    }];
     */

    UIView *view=[[UIView alloc] init];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.centerY).offset(-1);
        // make.centerY.equalTo(self.view.centerY);
        make.height.equalTo(@50);
    }];
    
    
    _cityTF = [[UITextField alloc] init];
    _cityTF.delegate = self;
    _cityTF.textAlignment = NSTextAlignmentRight;
    _cityTF.leftViewMode = UITextFieldViewModeAlways;
    _cityTF.font = FONT15;
    _cityTF.textColor = [UIColor colorWithHexString:@"b5b5b6"];
    UILabel * cityLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 120, 36)];
    [cityLB setBackgroundColor:[UIColor clearColor]];
    cityLB.font = FONT18;
    cityLB.text = @"您所在城市 ";
    cityLB.textAlignment=NSTextAlignmentCenter;
    cityLB.textColor = [UIColor colorWithHexString:@"333333"];
    _cityTF.leftView = cityLB;
    //UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
   // UIImageView *IMV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    //IMV.image = [UIImage imageNamed:@"user_login"];
    //[view addSubview:IMV];
   // _cityTF.rightView=view;
    _cityTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _cityTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _cityTF.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_cityTF setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_cityTF];
    [_cityTF makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.bottom.equalTo(self.view.centerY).offset(-1);
       // make.centerY.equalTo(self.view.centerY);
        make.height.equalTo(@50);
    }];
    
    
    UIButton *locBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locBtn.translatesAutoresizingMaskIntoConstraints = NO;
    locBtn.backgroundColor=[UIColor clearColor];
    [locBtn addTarget:self action:@selector(locBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [locBtn setBackgroundImage:[UIImage imageNamed:@"city_right1"] forState:UIControlStateNormal ];
    [self.view addSubview:locBtn];
    [locBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cityTF.top);
        make.bottom.equalTo(_cityTF.bottom);
        make.right.equalTo(self.view.right);
        make.left.equalTo(_cityTF.left);
    }];
    
    
    
    UILabel * line1 = [[UILabel alloc] init];
    [line1 setBackgroundColor:[UIColor colorWithHexString:LineColor]];
    [self.view addSubview:line1];
    [line1 makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_cityTF.top);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(@1);
    }];
    
    
    UILabel * line2 = [[UILabel alloc] init];
    [line2 setBackgroundColor:[UIColor colorWithHexString:LineColor]];
    [self.view addSubview:line2];
    [line2 makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(_cityTF.bottom);
        make.top.equalTo(self.view.centerY);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(@1);
    }];
    
    
    UIView *view1=[[UIView alloc] init];
    view1.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view1];
    [view1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.centerY).offset(1);
        //make.centerY.equalTo(self.view.centerY);
        make.height.equalTo(@50);

    }];

    _phoneTF = [[UITextField alloc] init];
    _phoneTF.delegate = self;
    _phoneTF.keyboardType = UIKeyboardTypePhonePad;
    _phoneTF.textAlignment = NSTextAlignmentRight;
    _phoneTF.leftViewMode = UITextFieldViewModeAlways;
    _phoneTF.font = FONT15;
    _phoneTF.textColor = [UIColor colorWithHexString:@"b5b5b6"];
    UILabel *phoneLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 120, 36)];
    [phoneLB setBackgroundColor:[UIColor clearColor]];
    phoneLB.font = FONT18;
    phoneLB.text = @"手机号码";
    phoneLB.textAlignment=NSTextAlignmentCenter;
    phoneLB.textColor = [UIColor colorWithHexString:@"333333"];
    _phoneTF.leftView = phoneLB;
    _phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneTF.placeholder = @"请输入手机号";
    _phoneTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _phoneTF.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_phoneTF setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_phoneTF];
    [_phoneTF makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.top.equalTo(self.view.centerY).offset(1);
        //make.centerY.equalTo(self.view.centerY);
        make.height.equalTo(@50);
    }];
    
    
    UILabel * line3 = [[UILabel alloc] init];
    [line3 setBackgroundColor:[UIColor colorWithHexString:LineColor]];
    [self.view addSubview:line3];
    [line3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneTF.bottom);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(@1);
    }];
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendBtn.translatesAutoresizingMaskIntoConstraints = NO;
    _sendBtn.layer.cornerRadius = 15;
    _sendBtn.layer.masksToBounds = YES;
    _sendBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [_sendBtn setTitle:@"获取手机验证码" forState:UIControlStateNormal];
    [_sendBtn setBackgroundImage:[UIImage imageNamed:@"orange.png"] forState:UIControlStateNormal];
    [_sendBtn addTarget:self action:@selector(sendBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendBtn];
    [_sendBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(_phoneTF.bottom).offset(50);
        make.width.equalTo(@180);
        make.height.equalTo(@40);
    }];
    
    CGFloat padding=(self.view.frame.size.width-180)/4.0;
    
    _forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _forgetBtn.titleLabel.font = FONT14;
    [ _forgetBtn setTitleColor:[UIColor colorWithHexString:@"fd6a00"] forState:UIControlStateNormal];
    [_forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_forgetBtn addTarget:self action:@selector(forgetBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_forgetBtn setHidden:YES];
    [self.view addSubview:_forgetBtn];
    [_forgetBtn makeConstraints:^(MASConstraintMaker *make) {
       // make.centerX.equalTo(self.view.centerX);
       // make.top.equalTo(_phoneTF.bottom).offset(50);
        make.centerX.equalTo(self.view.left).offset(padding);
        make.centerY.equalTo(_sendBtn.centerY);
        make.width.equalTo(@60);
        make.height.equalTo(@40);
    }];
    
    
    _siginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _siginBtn.titleLabel.font = FONT14;
    [_siginBtn setTitle:@"马上登录" forState:UIControlStateNormal];
    [ _siginBtn setTitleColor:[UIColor colorWithHexString:@"fd6a00"] forState:UIControlStateNormal];
    [_siginBtn addTarget:self action:@selector(siginBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_siginBtn setHidden:YES];
    [self.view addSubview:_siginBtn];
    [_siginBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.right).offset(-padding);
        make.centerY.equalTo(_sendBtn.centerY);
        make.width.equalTo(@60);
        make.height.equalTo(@40);
    }];
    
    
    _TAP = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchPressed:)];
    [self.view addGestureRecognizer:_TAP];
    
    //[self initPickerView];
    [self getUserLocation];
}


-(void)locBtnPressed:(id)sender
{
    
    //[self pickerScrollIn];
    LocationViewController *locVC=[[LocationViewController alloc] init];
    locVC.delegate=self;
    locVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:locVC animated:YES];
    
}

 - (void)getSelectedLocation:(CityModel *)selectedCity
{
    if (selectedCity) {
        _cityTF.text = selectedCity.cityName;
        _cityId = selectedCity.cityID;
    }
    else {
        //_cityTF.text = @"定位失败";
        //_cityId = kDefaultCityID;
    }


}


-(void)sendBtnPressed:(id)sender
{
     [_phoneTF resignFirstResponder];
    if ([_cityTF.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择城市";
        return;
        
    }
    
    if (![RegularFormat isMobileNumber:_phoneTF.text]) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入正确的手机号";
        return;
        
    }
    [self sendMobileValidate];
    /*
    getCodeViewController *getCodeVC=[[getCodeViewController alloc] init];
    getCodeVC.hidesBottomBarWhenPushed=YES;
    getCodeVC.phoneNumber=_phoneTF.text;
    getCodeVC.cityId=_cityId;
    [self.navigationController pushViewController:getCodeVC animated:YES ];
*/

}




-(void) touchPressed:(UITapGestureRecognizer *)t
{
    //CGPoint point  = [t locationInView:self.view];
    
    
    [BaseApi EndEditing];
    
}


-(void)forgetBtnPressed:(id)sender
{

    FindPasswordViewController *findC = [[FindPasswordViewController alloc] init];
    [self.navigationController pushViewController:findC animated:YES];

}

-(void)siginBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];


}



#pragma mark - Data

//发送验证码
- (void)sendMobileValidate {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在发送...";
    [NetworkInterface getRegisterValidateCodeWithMobileNumber:_phoneTF.text finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.0f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == RequestSuccess) {
                    [hud setHidden:YES];
                    _codeNumber = [object objectForKey:@"result"];
                    //[self TimeCountStart];
                    getCodeViewController *getCodeVC=[[getCodeViewController alloc] init];
                    getCodeVC.hidesBottomBarWhenPushed=YES;
                    getCodeVC.phoneNumber=_phoneTF.text;
                    getCodeVC.cityId=_cityId;
                    getCodeVC.codeNumber=_codeNumber;
                    [self.navigationController pushViewController:getCodeVC animated:YES ];
                    
                }
                else {
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                    
                    [_sendBtn setHidden:YES];
                    [_forgetBtn setHidden:NO];
                    [_siginBtn setHidden:NO];
                 
                    
                }
            }
            else {
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
}





#pragma mark - UITextField

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.editingField = textField;
    [_sendBtn setHidden:NO];
    [_forgetBtn setHidden:YES];
    [_siginBtn setHidden:YES];
    return YES;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.editingField = nil;
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 键盘

- (void)handleKeyboardDidShow:(NSNotification *)paramNotification {
    //获取键盘高度
    CGRect keyboardRect = [[[paramNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect fieldRect = [[self.editingField superview] convertRect:self.editingField.frame toView:self.view];
    CGFloat topHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat offsetY = keyboardRect.size.height - (kScreenHeight - topHeight - fieldRect.origin.y - fieldRect.size.height);
    if (offsetY > 0 && self.offset == 0) {
        self.offset = offsetY;
        [UIView animateWithDuration:0.3f animations:^{
            self.view.frame = CGRectMake(self.primaryPoint.x, self.primaryPoint.y - offsetY, self.view.bounds.size.width, self.view.bounds.size.height);
        }];
    }
}

- (void)handleKeyboardDidHidden {
    if (self.offset != 0) {
        self.offset = 0;
        [UIView animateWithDuration:0.3f animations:^{
            self.view.frame = CGRectMake(self.primaryPoint.x, self.primaryPoint.y, self.view.bounds.size.width, self.view.bounds.size.height);
        }];
    }
}


- (void)viewWillAppear:(BOOL)animated {

    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidShow:)
                                                name:UIKeyboardDidShowNotification
                                              object:nil];
    //注册通知，监听键盘消失事件
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidHidden)
                                                name:UIKeyboardDidHideNotification
                                              object:nil];
    [MobClick beginLogPageView:@"PageOne"];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PageOne"];
}


#pragma mark - 定位

- (void)getUserLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; //控制定位精度,越高耗电量越大。
        _locationManager.distanceFilter = 100; //控制定位服务更新频率。单位是“米”
        [_locationManager startUpdatingLocation];
        //在ios 8.0下要授权
        if (kDeviceVersion >= 8.0)
            [_locationManager requestWhenInUseAuthorization];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            if ([placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks lastObject];
                NSString *cityName = placemark.locality;
                [self getCurrentCityInfoWithCityName:cityName];
            }
        }
    }];
}



- (void)getCurrentCityInfoWithCityName:(NSString *)cityName {
    CityModel *currentCity = nil;
    for (CityModel *model in [CityHandle shareCityList]) {
        if ([cityName rangeOfString:model.cityName].length != 0) {
            currentCity = model;
            break;
        }
    }
    if (currentCity) {
        _cityTF.text = currentCity.cityName;
        _cityId = currentCity.cityID;
    }
    else {
        //_cityTF.text = @"定位失败";
        _cityId = kDefaultCityID;
    }
     [_locationManager stopUpdatingLocation];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
