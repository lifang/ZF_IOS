//
//  GoodDetialModel.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/7.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "GoodDetialModel.h"

@implementation GoodDetialModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        id goodInfo = [dict objectForKey:@"goodinfo"];
        if ([goodInfo isKindOfClass:[NSDictionary class]]) {
            if ([goodInfo objectForKey:@"Title"]) {
                _goodName = [NSString stringWithFormat:@"%@",[goodInfo objectForKey:@"Title"]];
            }
            if ([goodInfo objectForKey:@"second_title"]) {
                _detailName = [NSString stringWithFormat:@"%@",[goodInfo objectForKey:@"second_title"]];
            }
            if ([goodInfo objectForKey:@"good_brand"]) {
                _goodBrand = [NSString stringWithFormat:@"%@",[goodInfo objectForKey:@"good_brand"]];
            }
            if ([goodInfo objectForKey:@"Model_number"]) {
                _goodModel = [NSString stringWithFormat:@"%@",[goodInfo objectForKey:@"Model_number"]];
            }
            if ([goodInfo objectForKey:@"category"]) {
                _goodCategory = [NSString stringWithFormat:@"%@",[goodInfo objectForKey:@"category"]];
            }
            if ([goodInfo objectForKey:@"shell_material"]) {
                _goodMaterial = [NSString stringWithFormat:@"%@",[goodInfo objectForKey:@"shell_material"]];
            }
            if ([goodInfo objectForKey:@"battery_info"]) {
                _goodBattery = [NSString stringWithFormat:@"%@",[goodInfo objectForKey:@"battery_info"]];
            }
            if ([goodInfo objectForKey:@"sign_order_way"]) {
                _goodSignWay = [NSString stringWithFormat:@"%@",[goodInfo objectForKey:@"sign_order_way"]];
            }
            if ([goodInfo objectForKey:@"encrypt_card_way"]) {
                _goodEncryptWay = [NSString stringWithFormat:@"%@",[goodInfo objectForKey:@"encrypt_card_way"]];
            }
            if ([goodInfo objectForKey:@"volume_number"]) {
                _goodSaleNumber = [NSString stringWithFormat:@"%@",[goodInfo objectForKey:@"volume_number"]];
            }
            if ([goodInfo objectForKey:@"has_lease"]) {
                _canRent = [goodInfo objectForKey:@"has_lease"];
            }
            if ([goodInfo objectForKey:@"price"]) {
                _goodPrice = [NSString stringWithFormat:@"%@",[goodInfo objectForKey:@"price"]];
            }
        }
        id factoryInfo = [dict objectForKey:@"factory"];
        if ([factoryInfo isKindOfClass:[NSDictionary class]]) {
            if ([factoryInfo objectForKey:@"name"]) {
                _factoryName = [NSString stringWithFormat:@"%@",[factoryInfo objectForKey:@"name"]];
            }
            if ([factoryInfo objectForKey:@"website_url"]) {
                _factoryWebsite = [NSString stringWithFormat:@"%@",[factoryInfo objectForKey:@"website_url"]];
            }
            if ([factoryInfo objectForKey:@"description"]) {
                _factorySummary = [NSString stringWithFormat:@"%@",[factoryInfo objectForKey:@"description"]];
            }
            if ([factoryInfo objectForKey:@"logo_file_path"]) {
                _factoryImagePath = [NSString stringWithFormat:@"%@",[factoryInfo objectForKey:@"logo_file_path"]];
            }
        }
        if ([dict objectForKey:@"commentsCount"]) {
            _goodComment = [NSString stringWithFormat:@"%@",[dict objectForKey:@"commentsCount"]];
        }
        id pictureObject = [dict objectForKey:@"goodPics"];
        if ([pictureObject isKindOfClass:[NSArray class]]) {
            _goodImageList = [[NSMutableArray alloc] init];
            [_goodImageList addObjectsFromArray:pictureObject];
        }
        id defaultChannelObject = [dict objectForKey:@"paychannelinfo"];
        if ([defaultChannelObject isKindOfClass:[NSDictionary class]]) {
            _defaultChannel = [[ChannelModel alloc] initWithParseDictionary:defaultChannelObject];
        }
        id channelObject = [dict objectForKey:@"payChannelList"];
        if ([channelObject isKindOfClass:[NSArray class]]) {
            _channelItem = [[NSMutableArray alloc] init];
            for (int i = 0; i < [channelObject count]; i++) {
                id channelDict = [channelObject objectAtIndex:i];
                if ([channelDict isKindOfClass:[NSDictionary class]]) {
                    ChannelModel *model = [[ChannelModel alloc] initWithParseDictionary:channelDict];
                    [_channelItem addObject:model];
                }
            }
        }
        [self setDownloadStatus];
    }
    return self;
}

- (void)setDownloadStatus {
    ChannelModel *currentChannel = nil;
    for (ChannelModel *model in _channelItem) {
        if (_defaultChannel.channelID && [model.channelID isEqualToString:_defaultChannel.channelID]) {
            currentChannel = model;
            _defaultChannel.isAlreadyLoad = YES;
            break;
        }
    }
    if (currentChannel) {
        [_channelItem removeObject:currentChannel];
        [_channelItem addObject:_defaultChannel];
    }
}

@end
