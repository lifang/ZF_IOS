//
//  NetworkRequest.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

//回调结果
typedef void (^requestDidFinished)(BOOL success, NSData *response);

@interface NetworkRequest : NSObject<NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSMutableURLRequest *request;

@property (nonatomic, strong) NSURLConnection *requestConnection;

@property (nonatomic, strong)NSMutableData *requestData;

@property (nonatomic, strong) requestDidFinished finishBlock;

- (id)initWithRequestURL:(NSString *)urlString
              httpMethod:(NSString *)method
                finished:(requestDidFinished)finish;

- (void)setPostBody:(NSData *)postData;

- (void)start;

@end
