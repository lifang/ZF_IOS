//
//  RegisterLocationController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/16.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "CityHandle.h"

@interface RegisterLocationController : CommonViewController

@property (nonatomic, strong) NSString *selectedCityID;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) NSArray *cityArray;  //pickerView 第二列

- (void)initPickerView;
- (IBAction)modifyLocation:(id)sender;
- (void)pickerScrollIn;
- (void)pickerScrollOut;

@end
