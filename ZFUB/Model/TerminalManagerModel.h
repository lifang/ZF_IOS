//
//  TerminalManagerModel.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/27.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TerminalManagerModel : NSObject

@property (nonatomic, strong) NSString *TM_ID;      //终端记录id

@property (nonatomic, strong) NSString *TM_status;  //终端记录状态

@property (nonatomic, strong) NSString *TM_serialNumber;  //终端号

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
