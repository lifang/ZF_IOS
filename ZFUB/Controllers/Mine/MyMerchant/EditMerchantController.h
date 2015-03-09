//
//  EditMerchantController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/5.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "MerchantDetailModel.h"

static NSString *EditMerchantInfoNotification = @"EditMerchantInfoNotification";

typedef enum {
    MerchantEditName = 0,
    MerchantEditPersonName,
    MerchantEditPersonID,
    MerchantEditLicense,
    MerchantEditTax,
    MerchantEditOrganization,
    MerchantEditBank = 10,
    MerchantEditBankID,
}MerchantEditType;

@interface EditMerchantController : CommonViewController

@property (nonatomic, strong) MerchantDetailModel *merchant;

@property (nonatomic, assign) MerchantEditType editType;

@end
