//
//  InstitutionSelectedController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/28.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "InstitutionModel.h"

@protocol InstitutionSelectedDelegate <NSObject>

- (void)getSelectedInstitution:(InstitutionModel *)model;

@end

@interface InstitutionSelectedController : CommonViewController

@property (nonatomic, assign) id<InstitutionSelectedDelegate>delegate;

//收单机构数组
@property (nonatomic, strong) NSArray *institutionItems;

@end
