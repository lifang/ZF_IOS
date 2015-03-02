//
//  InstitutionModel.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/28.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

/*收单机构*/
#import <Foundation/Foundation.h>

@interface InstitutionModel : NSObject

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) BOOL isSelected;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
