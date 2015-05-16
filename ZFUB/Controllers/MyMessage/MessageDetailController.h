//
//  MessageDetailController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/17.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "MessageModel.h"

static NSString *RefreshMessageListNotification = @"RefreshMessageListNotification";

@interface MessageDetailController : CommonViewController

@property (nonatomic, strong) MessageModel *message;

@property (nonatomic, assign) BOOL isFromPush;  //是否推送进来的

@property (nonatomic, assign) NSString *messageID; //推送需要传的

@end
