//
//  MerchantImageLoadController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/5.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"

static NSString *key_frontImage = @"key_frontImage";
static NSString *key_backImage = @"key_backImage";
static NSString *key_bodyImage = @"key_bodyImage";
static NSString *key_licenseImage = @"key_licenseImage";
static NSString *key_taxImage = @"key_taxImage";
static NSString *key_organizationImage = @"key_organizationImage";
static NSString *key_bankImage = @"key_bankImage";

@interface MerchantImageLoadController : CommonViewController

@property (nonatomic, strong) NSString *selectedImageKey;  //选中的图片行

- (void)selectedKey:(NSString *)imageKey
           hasImage:(BOOL)hasImage;

- (void)saveWithURLString:(NSString *)urlString;

@end