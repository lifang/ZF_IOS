//
//  ApplyDetailController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"

static NSString *key_selected = @"key_selected";
static NSString *key_name = @"key_name";
static NSString *key_merchantName = @"key_merchantName";
static NSString *key_sex = @"key_sex";
static NSString *key_birth = @"key_birth";
static NSString *key_cardID = @"key_cardID";
static NSString *key_phone = @"key_phone";
static NSString *key_email = @"key_email";
static NSString *key_location = @"key_location";
static NSString *key_bank = @"key_bank";
static NSString *key_bankID = @"key_bankID";
static NSString *key_bankAccount = @"key_bankAccount";
static NSString *key_taxID = @"key_taxID";
static NSString *key_organID = @"key_organID";
static NSString *key_channel = @"key_channel";

@interface ApplyDetailController : CommonViewController

@property (nonatomic, strong) NSString *terminalID;

@end
