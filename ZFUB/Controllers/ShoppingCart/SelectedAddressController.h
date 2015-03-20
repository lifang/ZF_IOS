//
//  SelectedAddressController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/19.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "AddressCell.h"

@protocol SelectedAddressDelegate <NSObject>

- (void)getSelectedAddress:(AddressModel *)addressModel;

@end

@interface SelectedAddressController : CommonViewController

@property (nonatomic, assign) id<SelectedAddressDelegate>delegate;

@property (nonatomic, strong) NSString *addressID; //当前选择的地址id

@end
