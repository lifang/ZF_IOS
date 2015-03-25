//
//  OrderCommentCell.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/18.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewModel.h"
#import "UIImageView+WebCache.h"

#define kCommentCellHeight 230.f

@interface OrderCommentCell : UITableViewCell<UITextViewDelegate>

@property (nonatomic, strong) UIImageView *pictureView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *brandLabel;

@property (nonatomic, strong) UILabel *channelLabel;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UILabel *placeholderLabel;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) ReviewModel *goodModel;

- (void)setContentsWithData:(ReviewModel *)data;

@end
