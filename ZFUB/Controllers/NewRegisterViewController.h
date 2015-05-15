//
//  NewRegisterViewController.h
//  ZFUB
//
//  Created by wufei on 15/5/11.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondLayerViewController.h"


@interface NewRegisterViewController : SecondLayerViewController

//正在编辑的textfield
@property (nonatomic, strong) UITextField *editingField;

@property (nonatomic, assign) CGPoint primaryPoint;

@property (nonatomic, assign) CGFloat offset;

@end
