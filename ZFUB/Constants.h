//
//  Constants.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/23.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#define kColor(r,g,b,a) [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a]

#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width

#define kScaling  kScreenWidth / 320   //用于计算高度

#define kDeviceVersion [[[UIDevice currentDevice] systemVersion] floatValue]

#define kLineHeight   0.5f

#define kPageSize 10   //分页加载每页行数

#define kCoolDownTime  120   //冷却时间

#define kAppChannel  4

#define kAppVersionType  1   //版本更新

//#define kServiceURL @"http://121.40.224.25:8080/api" //yufa
#define kServiceURL @"http://121.40.84.2:8080/ZFMerchant/api"
//#define kServiceURL @"http://www.ebank007.com/api"   //线上

#define kVideoAuthIP    @"121.40.84.2"      //测试
//#define kVideoAuthIP      @"121.40.64.120"    //线上
#define kVideoAuthPort  8906

//视频提示地址
#define kVideoServiceURL @"http://121.40.84.2:38080/ZFManager/notice/video"
//#define kVideoServiceURL @"http://admin.ebank007.com/notice/video"   //线上

#define kOrderCallBackURL  @"http://121.40.84.2:8080/ZFMerchant/app_notify_url.jsp"
#define kCSCallBackURL     @"http://121.40.84.2:8080/ZFMerchant/repair_app_notify_url.jsp"
//线上
//#define kOrderCallBackURL  @"http://www.ebank007.com/app_notify_url.jsp"
//#define kCSCallBackURL     @"http://www.ebank007.com/repair_app_notify_url.jsp"

#define kMode_Production             @"01" //测试
#define kUnionPayURL  @"http://121.40.84.2:8080/ZFMerchant/unionpay.do" //测试

//#define kMode_Production             @"00"  //线上
//#define kUnionPayURL  @"http://www.ebank007.com/unionpay.do" //线上

//#define kMode_Production             @"00"  //yufa
//#define kUnionPayURL  @"http://121.40.224.25:8080/unionpay.do" //yufa

//#define kBaiduAPIKey  @"18vgfrYe8V4hmFH6m2IHMjbz" //APPstore
#define kBaiduAPIKey @"MTrtGFhYhOXMFLbdvz2nFZM7" //zhangfu


#define kImageName(name) [UIImage imageNamed:name]

#define kServiceReturnWrong  @"服务端数据返回错误"
#define kNetworkFailed       @"网络连接失败"


