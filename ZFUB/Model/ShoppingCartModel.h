//
//  ShoppingCartModel.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/12.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCartModel : NSObject

///购物车ID
@property (nonatomic, strong) NSString *cartID;
///商品名
@property (nonatomic, strong) NSString *cartTitle;
///商品型号
@property (nonatomic, strong) NSString *cartModel;
///商品ID
@property (nonatomic, strong) NSString *cartGoodID;
///支付通道
@property (nonatomic, strong) NSString *cartChannel;
///数量
@property (nonatomic, assign) int cartCount;
///价格
@property (nonatomic, assign) CGFloat cartPrice;
///图片地址
@property (nonatomic, strong) NSString *cartImagePath;

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isEditing;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
