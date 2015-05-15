//
//  BaseApi.m
//  AbroadNoFree
//
//  Created by 草泥马 on 14-11-3.
//  Copyright (c) 2014年 woshabi. All rights reserved.
//

#import "BaseApi.h"

@implementation BaseApi
+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize) size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+(void)EndEditing
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];

    
}


@end
