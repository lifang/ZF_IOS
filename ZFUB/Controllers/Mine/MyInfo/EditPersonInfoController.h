//
//  EditPersonInfoController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/2.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "UserModel.h"

//修改用户姓名、手机号、邮箱
static NSString *EditUserInfoNotification = @"EditUserInfoNotification";

typedef enum {
    ModifyNone = 0,
    ModifyUsername,
    ModifyPhoneNumber,
    ModifyEmail,
}ModifyType;

@interface EditPersonInfoController : CommonViewController

@property (nonatomic, strong) UserModel *userInfo;

@property (nonatomic, assign) ModifyType modifyType;

@end
