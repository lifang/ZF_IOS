//
//  ProgressModel.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/17.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenTypeModel : NSObject

@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *status;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end

//申请开通进度查询
@interface ProgressModel : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *terminalNum;
@property (nonatomic, strong) NSMutableArray *openList;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
