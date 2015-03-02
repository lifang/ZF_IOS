//
//  NetworkInterface.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "NetworkInterface.h"
#import "EncryptHelper.h"

static NSString *HTTP_POST = @"POST";
static NSString *HTTP_GET  = @"GET";

@implementation NetworkInterface


#pragma mark - 公用方法

+ (void)requestWithURL:(NSString *)urlString
                params:(NSMutableDictionary *)params
            httpMethod:(NSString *)method
              finished:(requestDidFinished)finish {
    NetworkRequest *request = [[NetworkRequest alloc] initWithRequestURL:urlString
                                                              httpMethod:method
                                                                finished:finish];
    NSLog(@"url = %@,params = %@",urlString,params);
    if ([method isEqualToString:HTTP_POST]) {
        NSData *postData = [NSJSONSerialization dataWithJSONObject:params
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        [request setPostBody:postData];
    }
    [request start];
}

#pragma mark - 接口方法

//1.
+ (void)registerWithActivation:(NSString *)activation
                      username:(NSString *)username
                  userPassword:(NSString *)userPassword
                        cityID:(NSString *)cityID
               isEmailRegister:(BOOL)isEmailRegister
                      finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (activation) {
        [paramDict setObject:activation forKey:@"code"];
    }
    [paramDict setObject:username forKey:@"username"];
    NSString *encryptPassword = [EncryptHelper MD5_encryptWithString:userPassword];
    [paramDict setObject:encryptPassword forKey:@"password"];
    [paramDict setObject:cityID forKey:@"cityId"];
    [paramDict setObject:[NSNumber numberWithBool:isEmailRegister] forKey:@"accountType"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_register_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//2.
+ (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
         isAlreadyEncrypt:(BOOL)encrypt
                 finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:username forKey:@"username"];
    NSString *encryptPassword = password;
    if (!encrypt) {
        encryptPassword = [EncryptHelper MD5_encryptWithString:password];
    }
    [paramDict setObject:encryptPassword forKey:@"password"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_login_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//3.1
+ (void)getRegisterValidateCodeWithMobileNumber:(NSString *)mobileNumber
                                       finished:(requestDidFinished)finish {
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",kServiceURL,s_registerValidate_method,mobileNumber];
    [[self class] requestWithURL:urlString
                          params:nil
                      httpMethod:HTTP_GET
                        finished:finish];
}

//3.2
+ (void)getFindValidateCodeWithMobileNumber:(NSString *)mobileNumber
                                   finished:(requestDidFinished)finish {
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",kServiceURL,s_findValidate_method,mobileNumber];
    [[self class] requestWithURL:urlString
                          params:nil
                      httpMethod:HTTP_GET
                        finished:finish];
}

//6.
+ (void)getApplyListWithToken:(NSString *)token
                       userID:(NSString *)userID
                         page:(int)page
                         rows:(int)rows
                     finished:(requestDidFinished)finish {
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%d/%d",kServiceURL,s_applyList_method,userID,page,rows];
    [[self class] requestWithURL:urlString
                          params:nil
                      httpMethod:HTTP_GET
                        finished:finish];
}

//15.
+ (void)getTerminalManagerListWithToken:(NSString *)token
                                 userID:(NSString *)userID
                                   page:(int)page
                                   rows:(int)rows
                               finished:(requestDidFinished)finish {
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%d/%d",kServiceURL,s_terminalManagerList_method,userID,page,rows];
    [[self class] requestWithURL:urlString
                          params:nil
                      httpMethod:HTTP_GET
                        finished:finish];
}

//16.
+ (void)getCollectionChannelWithToken:(NSString *)token finished:(requestDidFinished)finish {
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/",kServiceURL,s_organzationList_method];
    [[self class] requestWithURL:urlString
                          params:nil
                      httpMethod:HTTP_GET
                        finished:finish];
}

//17.
+ (void)addTerminalWithToken:(NSString *)token
                      userID:(NSString *)userID
               institutionID:(NSString *)institutionID
              terminalNumber:(NSString *)terminalNumber
                merchantName:(NSString *)merchantName
                    finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:userID forKey:@"customerId"];
    [paramDict setObject:terminalNumber forKey:@"serialNum"];
    [paramDict setObject:merchantName forKey:@"title"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_addTerminal_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//18.
+ (void)findPOSPasswordWithToken:(NSString *)token
                            tmID:(NSString *)tmID
                        finished:(requestDidFinished)finish {
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",kServiceURL,s_terminalFindPsw_method,tmID];
    [[self class] requestWithURL:urlString
                          params:nil
                      httpMethod:HTTP_GET
                        finished:finish];
}

//19.
+ (void)videoAuthWithToken:(NSString *)token
                      tmID:(NSString *)tmID
                  finished:(requestDidFinished)finish {
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_videoAuth_method];
    [[self class] requestWithURL:urlString
                          params:nil
                      httpMethod:HTTP_GET
                        finished:finish];
}

//20.
+ (void)synchronizeWithToken:(NSString *)token
                        tmID:(NSString *)tmID
                    finished:(requestDidFinished)finish {
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_synchronize_method];
    [[self class] requestWithURL:urlString
                          params:nil
                      httpMethod:HTTP_GET
                        finished:finish];
}

//21.
+ (void)getTerminalDetailWithToken:(NSString *)token
                              tmID:(NSString *)tmID
                          finished:(requestDidFinished)finish {
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",kServiceURL,s_termainlDetail_method,tmID];
    [[self class] requestWithURL:urlString
                          params:nil
                      httpMethod:HTTP_GET
                        finished:finish];
}

//22.
+ (void)goodSearchInfoWithCityID:(NSString *)cityID
                        finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:cityID forKey:@"city_id"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_goodSearch_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//23.
+ (void)getGoodListWithCityID:(NSString *)cityID
                     sortType:(OrderFilter)filterType
                      brandID:(NSArray *)brandID
                     category:(NSArray *)category
                    channelID:(NSArray *)channelID
                    payCardID:(NSArray *)cardID
                      tradeID:(NSArray *)tradeID
                       slipID:(NSArray *)slipID
                         date:(NSArray *)date
                     maxPrice:(CGFloat)maxPrice
                     minPrice:(CGFloat)minPrice
                      keyword:(NSString *)keyword
                     onlyRent:(BOOL)rent
                         page:(int)page
                         rows:(int)rows
                     finished:(requestDidFinished)finish {
    
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:cityID forKey:@"city_id"];
    if (filterType != OrderFilterNone) {
        [paramDict setObject:[NSNumber numberWithInt:filterType] forKey:@"orderType"];
    }
    if (brandID) {
        [paramDict setObject:brandID forKey:@"brands_id"];
    }
    if (category) {
        [paramDict setObject:category forKey:@"category"];
    }
    if (channelID) {
        [paramDict setObject:channelID forKey:@"pay_channel_id"];
    }
    if (cardID) {
        [paramDict setObject:cardID forKey:@"pay_card_id"];
    }
    if (tradeID) {
        [paramDict setObject:tradeID forKey:@"trade_type_id"];
    }
    if (slipID) {
        [paramDict setObject:slipID forKey:@"sale_slip_id"];
    }
    if (date) {
        [paramDict setObject:date forKey:@"tDate"];
    }
    if (maxPrice >= 0) {
        [paramDict setObject:[NSNumber numberWithFloat:maxPrice] forKey:@"maxPrice"];
    }
    if (minPrice >= 0) {
        [paramDict setObject:[NSNumber numberWithFloat:minPrice] forKey:@"minPrice"];
    }
    if (keyword) {
        [paramDict setObject:keyword forKey:@"keys"];
    }
    [paramDict setObject:[NSNumber numberWithInt:rent] forKey:@"has_purchase"];
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_goodList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//24.
+ (void)getGoodDetailWithCityID:(NSString *)cityID
                         goodID:(NSString *)goodID
                       finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:cityID forKey:@"city_id"];
    [paramDict setObject:goodID forKey:@"goodId"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_goodDetail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//27.
+ (void)getShoppingCartWithToken:(NSString *)token
                          userID:(NSString *)userID
                         finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:userID forKey:@"customerId"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_shoppingList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//29.
+ (void)deleteShoppingCartWithToken:(NSString *)token
                             cartID:(NSString *)cartID
                           finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:cartID forKey:@"id"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_deleteShoppingList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//30.
+ (void)updateShoppingCartWithToken:(NSString *)token
                             cartID:(NSString *)cartID
                              count:(int)count
                           finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:cartID forKey:@"id"];
    [paramDict setObject:[NSNumber numberWithInt:count] forKey:@"quantity"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_updateShoppingList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//35.
+ (void)getTerminalListWithToken:(NSString *)token
                          userID:(NSString *)userID
                        finished:(requestDidFinished)finish {
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",kServiceURL,s_terminalList_method,userID];
    [[self class] requestWithURL:urlString
                          params:nil
                      httpMethod:HTTP_GET
                        finished:finish];
}

//36.
+ (void)searchTradeRecordWithToken:(NSString *)token
                         tradeType:(TradeType)tradeType
                    terminalNumber:(NSString *)terminalNum
                         startTime:(NSString *)startTime
                           endTime:(NSString *)endTime
                              page:(int)page
                              rows:(int)rows
                          finished:(requestDidFinished)finish {
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%d/%@/%@/%@/%d/%d",kServiceURL,s_tradeRecord_method,tradeType,terminalNum,startTime,endTime,page,rows];
    [[self class] requestWithURL:urlString
                          params:nil
                      httpMethod:HTTP_GET
                        finished:finish];
    
}

//37.
+ (void)getTradeDetailWithToken:(NSString *)token
                        tradeID:(NSString *)tradeID
                       finished:(requestDidFinished)finish {
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",kServiceURL,s_tradeDetail_method,tradeID];
    [[self class] requestWithURL:urlString
                          params:nil
                      httpMethod:HTTP_GET
                        finished:finish];
}

//38.
+ (void)getTradeTotalWithToken:(NSString *)token
                     tradeType:(TradeType)tradeType
                terminalNumber:(NSString *)terminalNum
                     startTime:(NSString *)startTime
                       endTime:(NSString *)endTime
                      finished:(requestDidFinished)finish {
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%d/%@/%@/%@",kServiceURL,s_tradeTotal_method,tradeType,terminalNum,startTime,endTime];
    [[self class] requestWithURL:urlString
                          params:nil
                      httpMethod:HTTP_GET
                        finished:finish];
}

//39.
+ (void)modifyUserInfoWithToken:(NSString *)token
                         userID:(NSString *)userID
                        username:(NSString *)username
                     mobilePhone:(NSString *)mobilePhone
                           email:(NSString *)email
                          cityID:(NSString *)cityID
                        finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:userID forKey:@"id"];
    if (username) {
        [paramDict setObject:username forKey:@"name"];
    }
    if (mobilePhone) {
        [paramDict setObject:mobilePhone forKey:@"phone"];
    }
    if (email) {
        [paramDict setObject:email forKey:@"email"];
    }
    if (cityID) {
        [paramDict setObject:cityID forKey:@"cityId"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_userUpdate_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

@end
