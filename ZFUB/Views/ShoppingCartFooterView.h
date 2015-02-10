//
//  ShoppingCartFooterView.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/4.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCartFooterView : UIView

@property (nonatomic, strong) UIButton *selectedButton;
//全选文字 颜色根据是否选中变化
@property (nonatomic, strong) UILabel *selectedLabel;

@property (nonatomic, strong) UILabel *totalLabel;

@property (nonatomic, strong) UIButton *finishButton;

@end
