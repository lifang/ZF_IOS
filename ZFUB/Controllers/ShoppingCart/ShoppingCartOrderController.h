//
//  ShoppingCartOrderController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "OrderConfirmController.h"
#import "ShoppingCartModel.h"

@interface ShoppingCartOrderController : OrderConfirmController

//若从购物车跳转过来 保存选中的数据
@property (nonatomic, strong) NSArray *shoppingCartItem;

@end
