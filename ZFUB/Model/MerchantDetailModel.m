//
//  MerchantDetailModel.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/5.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "MerchantDetailModel.h"

@implementation MerchantDetailModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _merchantID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"title"]) {
            _merchantName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
        }
        if ([dict objectForKey:@"legalPersonName"]) {
            _merchantPersonName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"legalPersonName"]];
        }
        if ([dict objectForKey:@"legalPersonCardId"]) {
            _merchantPersonID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"legalPersonCardId"]];
        }
        if ([dict objectForKey:@"businessLicenseNo"]) {
            _merchantBusinessID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"businessLicenseNo"]];
        }
        if ([dict objectForKey:@"taxRegisteredNo"]) {
            _merchantTaxID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"taxRegisteredNo"]];
        }
        if ([dict objectForKey:@"organizationCodeNo"]) {
            _merchantOrganizationID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"organizationCodeNo"]];
        }
        if ([dict objectForKey:@"accountBankName"]) {
            _merchantBank = [NSString stringWithFormat:@"%@",[dict objectForKey:@"accountBankName"]];
        }
        if ([dict objectForKey:@"bankOpenAccount"]) {
            _merchantBankID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"bankOpenAccount"]];
        }
        if ([dict objectForKey:@"cityId"]) {
            _merchantCityID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"cityId"]];
        }
        if ([dict objectForKey:@"cardIdFrontPhotoPath"]) {
            _frontPath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"cardIdFrontPhotoPath"]];
        }
        if ([dict objectForKey:@"cardIdBackPhotoPath"]) {
            _backPath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"cardIdBackPhotoPath"]];
        }
        if ([dict objectForKey:@"bodyPhotoPath"]) {
            _bodyPath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"bodyPhotoPath"]];
        }
        if ([dict objectForKey:@"licenseNoPicPath"]) {
            _licensePath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"licenseNoPicPath"]];
        }
        if ([dict objectForKey:@"taxNoPicPath"]) {
            _taxPath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"taxNoPicPath"]];
        }
        if ([dict objectForKey:@"orgCodeNoPicPath"]) {
            _organizationPath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"orgCodeNoPicPath"]];
        }
        if ([dict objectForKey:@"accountPicPath"]) {
            _bankPath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"accountPicPath"]];
        }
    }
    return self;
}

@end
