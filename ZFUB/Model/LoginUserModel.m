//
//  LoginUserModel.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/4/28.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "LoginUserModel.h"

@implementation LoginUserModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_username forKey:@"username"];
    [aCoder encodeObject:_password forKey:@"password"];
    [aCoder encodeObject:_cityID forKey:@"city"];
    [aCoder encodeObject:_userID forKey:@"userID"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _username = [aDecoder decodeObjectForKey:@"username"];
        _password = [aDecoder decodeObjectForKey:@"password"];
        _cityID = [aDecoder decodeObjectForKey:@"city"];
        _userID = [aDecoder decodeObjectForKey:@"userID"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    LoginUserModel *user = [[self class] allocWithZone:zone];
    user.username = [_username copyWithZone:zone];
    user.password = [_password copyWithZone:zone];
    user.cityID = [_cityID copyWithZone:zone];
    user.userID = [_userID copyWithZone:zone];
    return user;
}

@end
