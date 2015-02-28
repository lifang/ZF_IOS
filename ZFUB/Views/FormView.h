//
//  FormView.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat menuHeight = 24.f;
static CGFloat contentHeight = 34.f;

@interface FormView : UIView


+ (CGFloat)heightWithRowCount:(NSInteger)row
                     hasTitle:(BOOL)hasTitle;

- (void)createFormWithTitle:(NSString *)formTitle
                     column:(NSArray *)titleArray
                    content:(NSArray *)itemArray;

@end
