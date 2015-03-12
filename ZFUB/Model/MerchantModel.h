//
//  MerchantModel.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/4.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MerchantModel : NSObject

@property (nonatomic, strong) NSString *merchantID;

@property (nonatomic, strong) NSString *merchantName;

@property (nonatomic, strong) NSString *merchantLegal;

@property (nonatomic, assign) BOOL isSelected;  //开通申请中记录是否选中

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
