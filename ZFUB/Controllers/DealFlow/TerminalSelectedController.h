//
//  TerminalSelectedController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/26.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"

@protocol TerminalSelectedDelegate <NSObject>

- (void)getSelectedTerminalNum:(NSString *)terminalNum;

@end

@interface TerminalSelectedController : CommonViewController

@property (nonatomic, assign) id<TerminalSelectedDelegate>delegate;

//终端数组
@property (nonatomic, strong) NSArray *terminalItems;

@end
