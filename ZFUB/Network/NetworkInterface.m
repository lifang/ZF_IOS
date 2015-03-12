//
//  NetworkInterface.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "NetworkInterface.h"
#import "EncryptHelper.h"
#import "MerchantDetailModel.h"

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
    if ([method isEqualToString:HTTP_POST] && params) {
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

//3.
+ (void)getFindValidateCodeWithMobileNumber:(NSString *)mobileNumber
                                   finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:mobileNumber forKey:@"codeNumber"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_findValidate_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//5.
+ (void)getRegisterValidateCodeWithMobileNumber:(NSString *)mobileNumber
                                       finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:mobileNumber forKey:@"codeNumber"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_registerValidate_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//6.
+ (void)getApplyListWithToken:(NSString *)token
                       userID:(NSString *)userID
                         page:(int)page
                         rows:(int)rows
                     finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customersId"];
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_applyList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//7.
+ (void)beginToApplyWithToken:(NSString *)token
                       userID:(NSString *)userID
                  applyStatus:(OpenApplyType)applyStatus
                   terminalID:(NSString *)terminalID
                     finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customerId"];
    [paramDict setObject:[NSNumber numberWithInt:[terminalID intValue]] forKey:@"terminalsId"];
    [paramDict setObject:[NSNumber numberWithInt:applyStatus] forKey:@"status"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_intoApply_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//8.
+ (void)selectedMerchantWithToken:(NSString *)token
                       merchantID:(NSString *)merchantID
                         finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:[merchantID intValue]] forKey:@"merchantId"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_applyMerchant_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//9.
+ (void)selectedChannelWithToken:(NSString *)token
                        finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_applyChannel_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//10.
+ (void)selectedBankWithToken:(NSString *)token
                     finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_applyBank_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//11.
+ (void)uploadImageWithImage:(UIImage *)image
                    finished:(requestDidFinished)finish {
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_loadImage_method];
    NetworkRequest *request = [[NetworkRequest alloc] initWithRequestURL:urlString
                                                              httpMethod:HTTP_POST
                                                                finished:finish];
    [request uploadImageData:UIImagePNGRepresentation(image)
                   imageName:nil
                         key:@"img"];
    [request start];
}

//12.
+ (void)getApplyMaterialWithToken:(NSString *)token
                       terminalID:(NSString *)terminalID
                         openType:(OpenApplyType)type
                         finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:[terminalID intValue]] forKey:@"terminalId"];
    [paramDict setObject:[NSNumber numberWithInt:type] forKey:@"status"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_applyMaterial_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
    
}

//15.
+ (void)getTerminalManagerListWithToken:(NSString *)token
                                 userID:(NSString *)userID
                                   page:(int)page
                                   rows:(int)rows
                               finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customersId"];
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_terminalManagerList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//16.
+ (void)getCollectionChannelWithToken:(NSString *)token
                             finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_organzationList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
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
    [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customerId"];
    [paramDict setObject:terminalNumber forKey:@"serialNum"];
    [paramDict setObject:[merchantName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"title"];
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
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:tmID forKey:@"terminalid"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_terminalFindPsw_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//19.
+ (void)videoAuthWithToken:(NSString *)token
                      tmID:(NSString *)tmID
                  finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
//    [paramDict setObject:tmID forKey:@"terminalid"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_videoAuth_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//20.
+ (void)synchronizeWithToken:(NSString *)token
                        tmID:(NSString *)tmID
                    finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
//    [paramDict setObject:tmID forKey:@"terminalid"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_synchronize_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//21.
+ (void)getTerminalDetailWithToken:(NSString *)token
                            userID:(NSString *)userID
                              tmID:(NSString *)tmID
                          finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:[tmID intValue]] forKey:@"terminalsId"];
    [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customerId"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_termainlDetail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
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
        [paramDict setObject:[keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"keys"];
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
    [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customerId"];
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

//32.
+ (void)createOrderFromCartWithToken:(NSString *)token
                              userID:(NSString *)userID
                             cartsID:(NSArray *)cartsID
                           addressID:(NSString *)addressID
                             comment:(NSString *)comment
                         needInvoice:(int)needInvoice
                         invoiceType:(int)invoiceType
                         invoiceInfo:(NSString *)invoiceTitle
                            finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customerId"];
    [paramDict setObject:cartsID forKey:@"cartid"];
    [paramDict setObject:[NSNumber numberWithInt:[addressID intValue]] forKey:@"addressId"];
    if (comment) {
        [paramDict setObject:comment forKey:@"comment"];
    }
    [paramDict setObject:[NSNumber numberWithInt:needInvoice] forKey:@"is_need_invoice"];
    if (needInvoice == 1) {
        [paramDict setObject:[NSNumber numberWithInt:invoiceType] forKey:@"invoice_type"];
        [paramDict setObject:invoiceTitle forKey:@"invoice_info"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_createOrderFromCart_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//33.
+ (void)createOrderFromGoodBuyWithToken:(NSString *)token
                                 userID:(NSString *)userID
                                 goodID:(NSString *)goodID
                              channelID:(NSString *)channelID
                                  count:(int)count
                              addressID:(NSString *)addressID
                                comment:(NSString *)comment
                            needInvoice:(int)needInvoice
                            invoiceType:(int)invoiceType
                            invoiceInfo:(NSString *)invoiceTitle
                               finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customerId"];
    [paramDict setObject:[NSNumber numberWithInt:[goodID intValue]] forKey:@"goodId"];
    [paramDict setObject:[NSNumber numberWithInt:[channelID intValue]] forKey:@"paychannelId"];
    [paramDict setObject:[NSNumber numberWithInt:count] forKey:@"quantity"];
    [paramDict setObject:[NSNumber numberWithInt:[addressID intValue]] forKey:@"addressId"];
    if (comment) {
        [paramDict setObject:comment forKey:@"comment"];
    }
    [paramDict setObject:[NSNumber numberWithInt:needInvoice] forKey:@"is_need_invoice"];
    if (needInvoice == 1) {
        [paramDict setObject:[NSNumber numberWithInt:invoiceType] forKey:@"invoice_type"];
        [paramDict setObject:invoiceTitle forKey:@"invoice_info"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_createOrderFromGood_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//34.
+ (void)createOrderFromGoodRentWithToken:(NSString *)token
                                  userID:(NSString *)userID
                                  goodID:(NSString *)goodID
                               channelID:(NSString *)channelID
                                   count:(int)count
                               addressID:(NSString *)addressID
                                 comment:(NSString *)comment
                             needInvoice:(int)needInvoice
                             invoiceType:(int)invoiceType
                             invoiceInfo:(NSString *)invoiceTitle
                                finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customerId"];
    [paramDict setObject:[NSNumber numberWithInt:[goodID intValue]] forKey:@"goodId"];
    [paramDict setObject:[NSNumber numberWithInt:[channelID intValue]] forKey:@"paychannelId"];
    [paramDict setObject:[NSNumber numberWithInt:count] forKey:@"quantity"];
    [paramDict setObject:[NSNumber numberWithInt:[addressID intValue]] forKey:@"addressId"];
    if (comment) {
        [paramDict setObject:comment forKey:@"comment"];
    }
    [paramDict setObject:[NSNumber numberWithInt:needInvoice] forKey:@"is_need_invoice"];
    if (needInvoice == 1) {
        [paramDict setObject:[NSNumber numberWithInt:invoiceType] forKey:@"invoice_type"];
        [paramDict setObject:invoiceTitle forKey:@"invoice_info"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_createOrderFromLease_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//35.
+ (void)getTerminalListWithToken:(NSString *)token
                          userID:(NSString *)userID
                        finished:(requestDidFinished)finish {
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",kServiceURL,s_terminalList_method,userID];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
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
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%d/%@/%@/%@/%d/%d",kServiceURL,s_tradeRecord_method,tradeType,terminalNum,startTime,endTime,page,rows];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
    
}

//37.
+ (void)getTradeDetailWithToken:(NSString *)token
                      tradeType:(TradeType)tradeType
                        tradeID:(NSString *)tradeID
                       finished:(requestDidFinished)finish {
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%d/%@",kServiceURL,s_tradeDetail_method,tradeType,tradeID];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//38.
+ (void)getTradeTotalWithToken:(NSString *)token
                     tradeType:(TradeType)tradeType
                terminalNumber:(NSString *)terminalNum
                     startTime:(NSString *)startTime
                       endTime:(NSString *)endTime
                      finished:(requestDidFinished)finish {
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%d/%@/%@/%@",kServiceURL,s_tradeTotal_method,tradeType,terminalNum,startTime,endTime];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//39.
+ (void)getUserInfoWithToken:(NSString *)token
                      userID:(NSString *)userID
                    finished:(requestDidFinished)finish {
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",kServiceURL,s_userInfo_method,userID];
    [[self class] requestWithURL:urlString
                          params:nil
                      httpMethod:HTTP_POST
                        finished:finish];
}

//40.
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
    [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"id"];
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

//41.
+ (void)modifyUserPasswordWithToken:(NSString *)token
                             userID:(NSString *)userID
                    primaryPassword:(NSString *)primayPassword
                        newPassword:(NSString *)newPassword
                           finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"id"];
    [paramDict setObject:[EncryptHelper MD5_encryptWithString:primayPassword] forKey:@"passwordOld"];
    [paramDict setObject:[EncryptHelper MD5_encryptWithString:newPassword] forKey:@"password"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_mofityUserPassword_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//42.
+ (void)getScoreListWithToken:(NSString *)token
                       userID:(NSString *)userID
                         page:(int)page
                         rows:(int)rows
                     finished:(requestDidFinished)finish {
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%d/%d",kServiceURL,s_scoreList_method,userID,page,rows];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//43.
+ (void)getScoreTotalWithToken:(NSString *)token
                        userID:(NSString *)userID
                      finished:(requestDidFinished)finish {
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",kServiceURL,s_scoreTotal_method,userID];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//44.
+ (void)exchangeScoreWithToken:(NSString *)token
                        userID:(NSString *)userID
                   handlerName:(NSString *)handlerName
            handlerPhoneNumber:(NSString *)phoneNumber
                         money:(int)money
                      finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customerId"];
    [paramDict setObject:handlerName forKey:@"name"];
    [paramDict setObject:phoneNumber forKey:@"phone"];
    [paramDict setObject:[NSNumber numberWithInt:money] forKey:@"price"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_exchangeScore_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//45.
+ (void)getAddressListWithToken:(NSString *)token
                         usedID:(NSString *)userID
                       finished:(requestDidFinished)finish {
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/",kServiceURL,s_addressList_method,userID];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//46.
+ (void)addAddressWithToken:(NSString *)token
                     userID:(NSString *)userID
                     cityID:(NSString *)cityID
               receiverName:(NSString *)receiverName
                phoneNumber:(NSString *)phoneNumber
                    zipCode:(NSString *)zipCode
                    address:(NSString *)address
                  isDefault:(AddressType)addressType
                   finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customerId"];
    [paramDict setObject:cityID forKey:@"cityId"];
    [paramDict setObject:receiverName forKey:@"receiver"];
    [paramDict setObject:phoneNumber forKey:@"moblephone"];
    [paramDict setObject:zipCode forKey:@"zipCode"];
    [paramDict setObject:address forKey:@"address"];
    [paramDict setObject:[NSNumber numberWithInt:addressType] forKey:@"isDefault"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_addressAdd_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//47.
+ (void)deleteAddressWithToken:(NSString *)token
                     addressIDs:(NSArray *)addressIDs
                      finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:addressIDs forKey:@"ids"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_addressDelete_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//48.
+ (void)getMerchantListWithToken:(NSString *)token
                          userID:(NSString *)userID
                            page:(int)page
                            rows:(int)rows
                        finished:(requestDidFinished)finish {
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%d/%d",kServiceURL,s_merchantList_method,userID,page,rows];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//49.
+ (void)getMerchantDetailWithToken:(NSString *)token
                        merchantID:(NSString *)merchantID
                          finished:(requestDidFinished)finish {
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",kServiceURL,s_merchantDetail_method,merchantID];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//50.
+ (void)createMerchantWithToken:(NSString *)token
                         userID:(NSString *)userID
                   merchantName:(NSString *)merchantName
                     personName:(NSString *)personName
                       personID:(NSString *)personID
                      licenseID:(NSString *)licenseID
                          taxID:(NSString *)taxID
                       oraganID:(NSString *)organID
                         cityID:(NSString *)cityID
                       bankName:(NSString *)bankName
                         bankID:(NSString *)bankID
                      frontPath:(NSString *)frontPath
                       backPath:(NSString *)backPath
                       bodyPath:(NSString *)bodyPath
                    licensePath:(NSString *)licensePath
                        taxPath:(NSString *)taxPath
                        orgPath:(NSString *)orgPath
                       bankPath:(NSString *)bankPath
                       finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customerId"];
    if (merchantName) {
        [paramDict setObject:merchantName forKey:@"title"];
    }
    if (personName) {
        [paramDict setObject:personName forKey:@"legalPersonName"];
    }
    if (personID) {
        [paramDict setObject:personID forKey:@"legalPersonCardId"];
    }
    if (licenseID) {
        [paramDict setObject:licenseID forKey:@"businessLicenseNo"];
    }
    if (taxID) {
        [paramDict setObject:taxID forKey:@"taxRegisteredNo"];
    }
    if (organID) {
        [paramDict setObject:organID forKey:@"organizationCodeNo"];
    }
    if (cityID) {
        [paramDict setObject:[NSNumber numberWithInt:[cityID intValue]] forKey:@"cityId"];
    }
    if (bankName) {
        [paramDict setObject:bankName forKey:@"accountBankName"];
    }
    if (bankID) {
        [paramDict setObject:bankID forKey:@"bankOpenAccount"];
    }
    if (frontPath) {
        [paramDict setObject:frontPath forKey:@"cardIdFrontPhotoPath"];
    }
    if (backPath) {
        [paramDict setObject:backPath forKey:@"cardIdBackPhotoPath"];
    }
    if (bodyPath) {
        [paramDict setObject:bodyPath forKey:@"bodyPhotoPath"];
    }
    if (licensePath) {
        [paramDict setObject:licensePath forKey:@"licenseNoPicPath"];
    }
    if (taxPath) {
        [paramDict setObject:taxPath forKey:@"taxNoPicPath"];
    }
    if (orgPath) {
        [paramDict setObject:orgPath forKey:@"orgCodeNoPicPath"];
    }
    if (bankPath) {
        [paramDict setObject:bankPath forKey:@"accountPicPath"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_merchantAdd_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//51.
+ (void)modifyMerchantWithToken:(NSString *)token
                 merchantDetail:(MerchantDetailModel *)merchant
                       finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    if (merchant.merchantID) {
        [paramDict setObject:[NSNumber numberWithInt:[merchant.merchantID intValue]] forKey:@"id"];
    }
    if (merchant.merchantName) {
        [paramDict setObject:merchant.merchantName forKey:@"title"];
    }
    if (merchant.merchantPersonName) {
        [paramDict setObject:merchant.merchantPersonName forKey:@"legalPersonName"];
    }
    if (merchant.merchantPersonID) {
        [paramDict setObject:merchant.merchantPersonID forKey:@"legalPersonCardId"];
    }
    if (merchant.merchantBusinessID) {
        [paramDict setObject:merchant.merchantBusinessID forKey:@"businessLicenseNo"];
    }
    if (merchant.merchantTaxID) {
        [paramDict setObject:merchant.merchantTaxID forKey:@"taxRegisteredNo"];
    }
    if (merchant.merchantOrganizationID) {
        [paramDict setObject:merchant.merchantOrganizationID forKey:@"organizationCodeNo"];
    }
    if (merchant.merchantCityID) {
        [paramDict setObject:[NSNumber numberWithInt:[merchant.merchantCityID intValue]] forKey:@"cityId"];
    }
    if (merchant.merchantBank) {
        [paramDict setObject:merchant.merchantBank forKey:@"accountBankName"];
    }
    if (merchant.merchantBankID) {
        [paramDict setObject:merchant.merchantBankID forKey:@"bankOpenAccount"];
    }
    if (merchant.frontPath) {
        [paramDict setObject:merchant.frontPath forKey:@"cardIdFrontPhotoPath"];
    }
    if (merchant.backPath) {
        [paramDict setObject:merchant.backPath forKey:@"cardIdBackPhotoPath"];
    }
    if (merchant.bodyPath) {
        [paramDict setObject:merchant.bodyPath forKey:@"bodyPhotoPath"];
    }
    if (merchant.licensePath) {
        [paramDict setObject:merchant.licensePath forKey:@"licenseNoPicPath"];
    }
    if (merchant.taxPath) {
        [paramDict setObject:merchant.taxPath forKey:@"taxNoPicPath"];
    }
    if (merchant.organizationPath) {
        [paramDict setObject:merchant.organizationPath forKey:@"orgCodeNoPicPath"];
    }
    if (merchant.bankPath) {
        [paramDict setObject:merchant.bankPath forKey:@"accountPicPath"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_merchantModify_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
    
}

+ (void)uploadMerchantImageWithImage:(UIImage *)image
                            finished:(requestDidFinished)finish {
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_merchantUploadImage_method];
    NetworkRequest *request = [[NetworkRequest alloc] initWithRequestURL:urlString
                                                              httpMethod:HTTP_POST
                                                                finished:finish];
    [request uploadImageData:UIImagePNGRepresentation(image)
                   imageName:nil
                         key:@"fileImg"];
    [request start];
}

+ (void)deleteMerchantWithToken:(NSString *)token
                    merchantIDs:(NSArray *)merchantsID
                       finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:merchantsID forKey:@"ids"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_merchantDelete_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//55.
+ (void)getMyMessageListWithToken:(NSString *)token
                           userID:(NSString *)userID
                             page:(int)page
                             rows:(int)rows
                         finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customer_id"];
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_messageList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//56.
+ (void)getMyMessageDetailWithToken:(NSString *)token
                             userID:(NSString *)userID
                          messageID:(NSString *)messageID
                           finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customer_id"];
    [paramDict setObject:[NSNumber numberWithInt:[messageID intValue]] forKey:@"id"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_messageDetail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//57.
+ (void)messageDeleteSingleWithToken:(NSString *)token
                              userID:(NSString *)userID
                           messageID:(NSString *)messageID
                            finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customer_id"];
    [paramDict setObject:[NSNumber numberWithInt:[messageID intValue]] forKey:@"id"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_messageDeleteSingle_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//58.
+ (void)messsageDeleteMultiWithToken:(NSString *)token
                              userID:(NSString *)userID
                          messagesID:(NSArray *)messagesID
                            finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customer_id"];
    [paramDict setObject:messagesID forKey:@"ids"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_messageDeleteMulti_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//59.
+ (void)messageReadWithToken:(NSString *)token
                      userID:(NSString *)userID
                  messagesID:(NSArray *)messagesID
                    finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customer_id"];
    [paramDict setObject:messagesID forKey:@"ids"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_messageRead_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
    
}

//60.
+ (void)getMyOrderListWithToken:(NSString *)token
                         userID:(NSString *)userID
                      orderType:(OrderType)type
                           page:(int)page
                           rows:(int)rows
                       finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customer_id"];
    if (type > OrderTypeAll) {
        [paramDict setObject:[NSNumber numberWithInt:type] forKey:@"p"];
    }
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_myOrderList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//61.
+ (void)getMyOrderDetailWithToken:(NSString *)token
                          orderID:(NSString *)orderID
                         finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:[orderID intValue]] forKey:@"id"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_orderDetail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//62.
+ (void)cancelMyOrderWithToken:(NSString *)token
                       orderID:(NSString *)orderID
                      finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:[orderID intValue]] forKey:@"id"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_orderCancel_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//63.
+ (void)commentMyOrderWithToken:(NSString *)token
                         userID:(NSString *)userID
                        orderID:(NSString *)orderID
                          score:(int)score
                        content:(NSString *)content
                       finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customer_id"];
    [paramDict setObject:[NSNumber numberWithInt:[orderID intValue]] forKey:@"good_id"];
    [paramDict setObject:[NSNumber numberWithInt:score] forKey:@"score"];
    [paramDict setObject:content forKey:@"content"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_orderComment_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

/*
 64.维修记录列表
 68.退货记录列表 
 72.注销记录列表 
 76.换货记录列表 
 80.更新资料记录列表
 83.租赁退还记录列表
 */
+ (void)getCSListWithToken:(NSString *)token
                    userID:(NSString *)userID
                    csType:(CSType)csType
                      page:(int)page
                      rows:(int)rows
                  finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customer_id"];
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *method = nil;
    switch (csType) {
        case CSTypeRepair:
            method = s_repairList_method;
            break;
        case CSTypeReturn:
            method = s_returnList_method;
            break;
        case CSTypeCancel:
            method = s_cancelList_method;
            break;
        case CSTypeChange:
            method = s_changeList_method;
            break;
        case CSTypeUpdate:
            method = s_updateList_method;
            break;
        case CSTypeLease:
            method = s_leaseList_method;
            break;
        default:
            break;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

/*
 65.维修记录取消订单 
 69.退货记录取消申请 
 73.注销记录取消申请 
 78.换货记录取消申请 
 82.更新资料取消申请 
 85.租赁退货取消申请
 */
+ (void)csCancelWithToken:(NSString *)token
                     csID:(NSString *)csID
                   csType:(CSType)csType
                 finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:[csID intValue]] forKey:@"id"];
    //url
    NSString *method = nil;
    switch (csType) {
        case CSTypeRepair:
            method = s_repairCancel_method;
            break;
        case CSTypeReturn:
            method = s_returnCancel_method;
            break;
        case CSTypeCancel:
            method = s_cancelCancel_method;
            break;
        case CSTypeChange:
            method = s_changeCancel_method;
            break;
        case CSTypeUpdate:
            method = s_updateCancel_method;
            break;
        case CSTypeLease:
            method = s_leaseCancel_method;
            break;
        default:
            break;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}


/*
 66.维修记录详情
 70.退货记录详情 
 75.注销记录详情
 77.换货记录详情 
 81.更新资料记录详情
 84.租赁退还记录详情
 */
+ (void)getCSDetailWithToken:(NSString *)token
                        csID:(NSString *)csID
                      csType:(CSType)csType
                    finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:[csID intValue]] forKey:@"id"];
    //url
    NSString *method = nil;
    switch (csType) {
        case CSTypeRepair:
            method = s_repairDetail_method;
            break;
        case CSTypeReturn:
            method = s_returnDetail_method;
            break;
        case CSTypeCancel:
            method = s_cancelDetail_method;
            break;
        case CSTypeChange:
            method = s_changeDetail_method;
            break;
        case CSTypeUpdate:
            method = s_updateDetail_method;
            break;
        case CSTypeLease:
            method = s_leaseDetail_method;
            break;
        default:
            break;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];

}

/*
 67.维修记录物流 
 71.退货记录物流 
 79.换货记录物流 
 86.租赁退还记录物流
 */
+ (void)csLogisticWithToken:(NSString *)token
                     userID:(NSString *)userID
                       csID:(NSString *)csID
                     csType:(CSType)csType
            logisticCompany:(NSString *)companyName
             logisticNumber:(NSString *)number
                   finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customer_id"];
    [paramDict setObject:[NSNumber numberWithInt:[csID intValue]] forKey:@"id"];
    [paramDict setObject:companyName forKey:@"computer_name"];
    [paramDict setObject:number forKey:@"track_number"];
    //url
    NSString *method = nil;
    switch (csType) {
        case CSTypeRepair:
            method = s_repairLogistic_method;
            break;
        case CSTypeReturn:
            method = s_returnLogistic_method;
            break;
        case CSTypeCancel:
            break;
        case CSTypeChange:
            method = s_changeLogistic_method;
            break;
        case CSTypeUpdate:
            break;
        case CSTypeLease:
            method = s_leaseLogistic_method;
            break;
        default:
            break;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
    
}

//74.
+ (void)submitCancelInfoWithToken:(NSString *)token
                             csID:(NSString *)csID
                         finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:token forKey:@"token"];
    [paramDict setObject:[NSNumber numberWithInt:[csID intValue]] forKey:@"id"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_cancelSubmit_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}


+ (void)getHomeImageListFinished:(requestDidFinished)finish {
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_homeImageList_method];
    [[self class] requestWithURL:urlString
                          params:nil
                      httpMethod:HTTP_POST
                        finished:finish];
}

@end
