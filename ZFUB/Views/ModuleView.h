//
//  ModuleView.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/23.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

/***********模块按钮***********/

typedef enum {
    ModuleNone = 0,
    ///选择POS机
    ModuleBuyPOS,
    ///开通认证
    ModuleAuthentication,
    ///终端管理
    ModuleManageTerminal,
    ///交易流水
    ModuletDealFlow,
    ///我要贷款
    ModuleLoan,
    ///我要理财
    ModuleFinancial,
    ///系统公告
    ModuleSystemAnnouncement,
    ///联系我们
    ModuleContact,
}ModuleViewTag;

#import <UIKit/UIKit.h>

@interface ModuleView : UIButton

@property (nonatomic, strong) NSString *imageName;

@property (nonatomic, strong) NSString *titleName;

- (void)setTitleName:(NSString *)titleName
           imageName:(NSString *)imageName;

@end
