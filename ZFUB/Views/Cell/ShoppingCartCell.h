//
//  ShoppingCartCell.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#define kShoppingCartCellHeight  108.f

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "ShoppingCartModel.h"

@class ShoppingCartCell;

@protocol ShoppingCartDelegate <NSObject>

- (void)editOrderForCell:(ShoppingCartCell *)cell;
- (void)minusCountForCell:(ShoppingCartCell *)cell;
- (void)addCountForCell:(ShoppingCartCell *)cell;
- (void)deleteOrderForCell:(ShoppingCartCell *)cell;

@end

//编辑状态
static NSString *shoppingCartIdentifier_edit = @"shoppingCartIdentifierEdit";
//正常状态
static NSString *shoppingCartIdentifier_normal = @"shoppingCartIdentifierNormal";

@interface ShoppingCartCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, assign) id<ShoppingCartDelegate>delegate;

@property (nonatomic, strong) UIButton *selectedButton;

@property (nonatomic, strong) UIImageView *pictureView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *editButton;

@property (nonatomic, strong) UILabel *brandLabel;

@property (nonatomic, strong) UILabel *channelLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) UITextField *numberField;

@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) UIButton *minusButton;

@property (nonatomic, strong) ShoppingCartModel *cartData;

- (IBAction)selectedOrder:(id)sender;

- (void)setShoppingCartData:(ShoppingCartModel *)cart;


@end
