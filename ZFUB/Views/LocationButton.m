//
//  LocationButton.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/23.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "LocationButton.h"

@interface LocationButton ()

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation LocationButton

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initAndLayoutUI];
    }
    return self;
}


#pragma mark - UI

- (void)initAndLayoutUI {
    CGFloat centerY = self.frame.size.height / 2 + self.frame.origin.y;
    UIImageView *locationView = [[UIImageView alloc] initWithFrame:CGRectMake(0, centerY - 7, 11, 15)];
    locationView.image = kImageName(@"home_location.png");
    [self addSubview:locationView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(locationView.bounds.size.width, 0, 50, self.bounds.size.height)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont systemFontOfSize:14.f];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.text = @"上海市";
    [self addSubview:_nameLabel];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x + _nameLabel.frame.size.width, centerY - 2, 9, 5)];
    arrowView.image = kImageName(@"home_arrow.png");
    [self addSubview:arrowView];
}

#pragma mark - Rewriten

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        _nameLabel.textColor = [UIColor grayColor];
    }
    else {
        _nameLabel.textColor = [UIColor blackColor];
    }
}

@end
