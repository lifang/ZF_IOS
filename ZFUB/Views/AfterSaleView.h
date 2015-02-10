//
//  AfterSaleView.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/30.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

/***********售后按钮***********/

typedef enum {
    AfterSaleNone = 0,
    ///维修记录
    AfterSaleModify,
    ///退货记录
    AfterSaleRefund,
    ///注销记录
    AfterSaleCancel,
    ///换货记录
    AfterSaleExchange,
    ///更新资料记录
    AfterSaleUpdate,
    ///租赁退还记录
    AfterSaleRent,
    ///修改到账日期记录
    AfterSaleAccountingDate,
}AfterSaleTag;

#import <UIKit/UIKit.h>

@interface AfterSaleView : UIButton

@property (nonatomic, strong) NSString *imageName;

@property (nonatomic, strong) NSString *titleName;

- (void)setTitleName:(NSString *)titleName
           imageName:(NSString *)imageName;

@end
