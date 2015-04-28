//
//  LoginViewController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/6.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

//正在编辑的textfield
@property (nonatomic, strong) UITextField *editingField;

@property (nonatomic, assign) CGPoint primaryPoint;

@property (nonatomic, assign) CGFloat offset;

@end
