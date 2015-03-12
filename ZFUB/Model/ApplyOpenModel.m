//
//  ApplyOpenModel.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/11.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ApplyOpenModel.h"

@implementation MaterialModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _materialID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"name"]) {
            _materialName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
        }
        if ([dict objectForKey:@"info_type"]) {
            _materialType = [[dict objectForKey:@"info_type"] intValue];
        }
    }
    return self;
}

@end

@implementation ApplyInfoModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"target_id"]) {
            _targetID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"target_id"]];
        }
        if ([dict objectForKey:@"key"]) {
            _key = [NSString stringWithFormat:@"%@",[dict objectForKey:@"key"]];
        }
        if ([dict objectForKey:@"value"]) {
            _value = [NSString stringWithFormat:@"%@",[dict objectForKey:@"value"]];
        }
        if ([dict objectForKey:@"preliminary_verify_user_id"]) {
            _levelID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"preliminary_verify_user_id"]];
        }
        if ([dict objectForKey:@"types"]) {
            _type = [[dict objectForKey:@"types"] intValue];
        }
    }
    return self;
}

@end

@implementation ApplyOpenModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        id terminalDict = [dict objectForKey:@"applyDetails"];
        if ([terminalDict isKindOfClass:[NSDictionary class]]) {
            if ([terminalDict objectForKey:@"brandName"]) {
                _brandName = [NSString stringWithFormat:@"%@",[terminalDict objectForKey:@"brandName"]];
            }
            if ([terminalDict objectForKey:@"model_number"]) {
                _modelNumber = [NSString stringWithFormat:@"%@",[terminalDict objectForKey:@"model_number"]];
            }
            if ([terminalDict objectForKey:@"serial_num"]) {
                _terminalNumber = [NSString stringWithFormat:@"%@",[terminalDict objectForKey:@"serial_num"]];
            }
            if ([terminalDict objectForKey:@"channelName"]) {
                _channelName = [NSString stringWithFormat:@"%@",[terminalDict objectForKey:@"channelName"]];
            }
        }
        id matList = [dict objectForKey:@"materialName"];
        if ([matList isKindOfClass:[NSArray class]]) {
            _materialList = [[NSMutableArray alloc] init];
            for (int i = 0; i < [matList count]; i++) {
                id materialDict = [matList objectAtIndex:i];
                if ([materialDict isKindOfClass:[NSDictionary class]]) {
                    MaterialModel *model = [[MaterialModel alloc] initWithParseDictionary:materialDict];
                    [_materialList addObject:model];
                }
            }
        }
        id merList = [dict objectForKey:@"merchants"];
        if ([merList isKindOfClass:[NSArray class]]) {
            _merchantList = [[NSMutableArray alloc] init];
            for (int i = 0; i < [merList count]; i++) {
                id merDict = [merList objectAtIndex:i];
                if ([merDict isKindOfClass:[NSDictionary class]]) {
                    MerchantModel *model = [[MerchantModel alloc] initWithParseDictionary:merDict];
                    [_merchantList addObject:model];
                }
            }
        }
        id appList = [dict objectForKey:@"applyFor"];
        if ([appList isKindOfClass:[NSArray class]]) {
            _applyList = [[NSMutableArray alloc] init];
            for (int i = 0; i < [appList count]; i++) {
                id appDict = [appList objectAtIndex:i];
                if ([appDict isKindOfClass:[NSDictionary class]]) {
                    ApplyInfoModel *model = [[ApplyInfoModel alloc] initWithParseDictionary:appDict];
                    [_applyList addObject:model];
                }
            }
        }
        NSArray *sort = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"materialType" ascending:NO]];
        _materialList = [NSMutableArray arrayWithArray:[_materialList sortedArrayUsingDescriptors:sort]];
    }
    return self;
}

@end
