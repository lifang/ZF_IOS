//
//  ApplyOpenModel.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/11.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MerchantModel.h"

typedef enum {
    MaterialNone = 0,
    MaterialText,    //文本
    MaterialImage,   //图片
    MaterialList,    //下拉列表
}MaterialType;


//返回对公对私需要提交的材料
@interface MaterialModel : NSObject

@property (nonatomic, strong) NSString *materialID;    //材料id
@property (nonatomic, strong) NSString *materialName;  //材料名
@property (nonatomic, assign) MaterialType materialType;  //数据类型

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end

//返回已提交的材料信息
@interface ApplyInfoModel : NSObject

@property (nonatomic, strong) NSString *targetID;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, assign) MaterialType type;
@property (nonatomic, strong) NSString *levelID;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end

@interface ApplyOpenModel : NSObject

@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) NSString *modelNumber;
@property (nonatomic, strong) NSString *terminalNumber;
@property (nonatomic, strong) NSString *channelName;

@property (nonatomic, strong) NSMutableArray *merchantList;
@property (nonatomic, strong) NSMutableArray *materialList;
@property (nonatomic, strong) NSMutableArray *applyList;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
