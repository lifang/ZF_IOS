//
//  NetworkRequest.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "NetworkRequest.h"

@implementation NetworkRequest

- (id)initWithRequestURL:(NSString *)urlString
              httpMethod:(NSString *)method
                finished:(requestDidFinished)finish {
    if (self = [super init]) {
        NSURL *url = [NSURL URLWithString:urlString];
        _request = [[NSMutableURLRequest alloc] initWithURL:url
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                            timeoutInterval:30.0];
        _finishBlock = finish;
        if (method) {
            [_request setHTTPMethod:method];
        }
    }
    return self;
}

- (void)setPostBody:(NSData *)postData {
    [_request setHTTPMethod:@"POST"];
    NSString *postLength = [NSString stringWithFormat:@"%ld",[postData length]];
    [_request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [_request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    [_request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [_request setHTTPBody:postData];
}

- (void)start {
    _requestConnection = [[NSURLConnection alloc] initWithRequest:_request
                                                         delegate:self
                                                 startImmediately:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _requestData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_requestData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (_finishBlock) {
        _finishBlock(YES,_requestData);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"error = %@",error);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (_finishBlock) {
        _finishBlock(NO,_requestData);
    }
}

@end
