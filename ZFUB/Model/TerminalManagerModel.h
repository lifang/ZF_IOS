//
//  TerminalManagerModel.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/27.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

/*终端管理列表*/
#import <Foundation/Foundation.h>

typedef enum {
    TerminalStatusNone = 0,
    TerminalStatusOpened,       //已开通
    TerminalStatusPartOpened,   //部分开通
    TerminalStatusUnOpened,     //未开通
    TerminalStatusCanceled,     //已注销
    TerminalStatusStopped,      //已停用
}TerminalStatus;

@interface TerminalManagerModel : NSObject

@property (nonatomic, strong) NSString *TM_ID;      //终端记录id

@property (nonatomic, strong) NSString *TM_status;  //终端记录状态

@property (nonatomic, strong) NSString *TM_serialNumber;  //终端号

@property (nonatomic, assign) BOOL hasVideoAuth;

@property (nonatomic, strong) NSString *protocol;

//是否为自助开通 2为自助开通
@property (nonatomic, assign) int type;

//未开通状态 值为2时 提示
@property (nonatomic, assign) int openStatus;

/*
 未开通状态，若无appid，开通申请；
 若有appid，重新开通申请，若openstatus为6，点击重新开通申请弹出提示
 若有值，状态为未开通，无同步操作
 */
@property (nonatomic, strong) NSString *appID;

- (id)initWithParseDictionary:(NSDictionary *)dict;

- (NSString *)getStatusString;

@end
