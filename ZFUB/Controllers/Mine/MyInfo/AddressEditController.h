//
//  AddressEditController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

typedef enum {
    AddressModify = 1,  //修改
    AddressAdd,         //添加
}AddressFunction;

#import "CommonViewController.h"
#import "AddressModel.h"

static NSString *RefreshAddressListNotification = @"RefreshAddressListNotification";

@interface AddressEditController : CommonViewController

@property (nonatomic, assign) AddressFunction type;

@property (nonatomic, strong) AddressModel *address;

@end
