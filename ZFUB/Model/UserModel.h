//
//  UserModel.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/2.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, strong) NSString *cityID;

@property (nonatomic, strong) NSString *phoneNumber;

@property (nonatomic, strong) NSString *email;

@property (nonatomic, strong) NSString *userName;
//用户积分
@property (nonatomic, strong) NSString *userScore;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
