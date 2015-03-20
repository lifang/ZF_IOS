//
//  MessageModel.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/17.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic, strong) NSString *messageID;
@property (nonatomic, strong) NSString *messageTitle;
@property (nonatomic, strong) NSString *messageContent;
@property (nonatomic, strong) NSString *messageTime;
@property (nonatomic, assign) BOOL messageRead;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
