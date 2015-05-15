//
//  EditPersonInfoController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/2.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "UserModel.h"

typedef enum {
    ModifyNone = 0,
    ModifyUsername,
}ModifyType;

@interface EditPersonInfoController : CommonViewController

@property (nonatomic, strong) UserModel *userInfo;

@property (nonatomic, assign) ModifyType modifyType;

@end
