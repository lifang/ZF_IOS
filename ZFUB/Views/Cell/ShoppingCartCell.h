//
//  ShoppingCartCell.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#define kShoppingCartCellHeight  108.f

#import <UIKit/UIKit.h>

//编辑状态
static NSString *shoppingCartIdentifier_edit = @"shoppingCartIdentifierEdit";
//正常状态
static NSString *shoppingCartIdentifier_normal = @"shoppingCartIdentifierNormal";

@interface ShoppingCartCell : UITableViewCell

@property (nonatomic, strong) UIButton *selectedButton;

@property (nonatomic, strong) UIImageView *pictureView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *editButton;

@property (nonatomic, strong) UITextField *inputField;

@property (nonatomic, strong) UILabel *brandLabel;

@property (nonatomic, strong) UILabel *channelLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) UITextField *numberField;

@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) UIButton *minusButton;

- (IBAction)selectedOrder:(id)sender;


@end
