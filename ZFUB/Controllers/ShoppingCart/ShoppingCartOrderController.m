//
//  ShoppingCartOrderController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ShoppingCartOrderController.h"

@interface ShoppingCartOrderController ()

@end

@implementation ShoppingCartOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setContentsForControls];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request

- (void)createOrderForCart {
    //购物车数组
    NSMutableArray *cartsID = [[NSMutableArray alloc] init];
    for (ShoppingCartModel *model in _shoppingCartItem) {
        if (model.isSelected) {
            [cartsID addObject:[NSNumber numberWithInt:[model.cartID intValue]]];
        }
    }
    //是否需要发票
    int needInvoice = 0;
    if (self.billBtn.isSelected) {
        needInvoice = 1;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface createOrderFromCartWithToken:delegate.token userID:delegate.userID cartsID:cartsID addressID:self.defaultAddress.addressID comment:self.reviewField.text needInvoice:needInvoice invoiceType:self.billType invoiceInfo:self.billField.text finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            NSLog(@"!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail || [errorCode intValue] == RequestShortInventory) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    NSString *orderID = [NSString stringWithFormat:@"%@",[object objectForKey:@"result"]];
                    NSString *titleName = @"";
                    if ([_shoppingCartItem count] > 0) {
                        ShoppingCartModel *model = [_shoppingCartItem objectAtIndex:0];
                        titleName = model.cartTitle;
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshShoppingCartNotification object:nil];
                    PayWayViewController *payWayC = [[PayWayViewController alloc] init];
                    payWayC.orderID = orderID;
                    payWayC.goodName = titleName;
                    payWayC.fromType = PayWayFromCart;
                    payWayC.totalPrice = [self getSummaryPrice];
                    [self.navigationController pushViewController:payWayC animated:YES];
                }
            }
            else {
                //返回错误数据
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
}

#pragma mark - Data

- (void)setContentsForControls {
    self.payLabel.text = [NSString stringWithFormat:@"实付：￥%.2f",[self getSummaryPrice]];
    self.deliveryLabel.text = [NSString stringWithFormat:@"(含配送费：￥%@)",@"0"];
}

//计算总价
- (CGFloat)getSummaryPrice {
    CGFloat summaryPrice = 0.f;
    for (ShoppingCartModel *model in _shoppingCartItem) {
        if (model.isSelected) {
            summaryPrice += (model.cartPrice + model.channelCost) * model.cartCount;
        }
    }
    return summaryPrice;
}

- (int)getSummaryCount {
    int count = 0;
    for (ShoppingCartModel *model in _shoppingCartItem) {
        if (model.isSelected) {
            count += model.cartCount;
        }
    }
    return count;
}

#pragma mark - Action

- (IBAction)ensureOrder:(id)sender {
    if (!self.defaultAddress) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择收件地址";
        return;
    }
    [self createOrderForCart];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_shoppingCartItem count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [_shoppingCartItem count]) {
        //最后一行
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        int count = [self getSummaryCount];
        CGFloat price = [self getSummaryPrice];
        UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        totalLabel.backgroundColor = [UIColor clearColor];
        totalLabel.font = [UIFont systemFontOfSize:11.f];
        totalLabel.adjustsFontSizeToFitWidth = YES;
        totalLabel.text = [NSString stringWithFormat:@"共计：%d件商品",count];
        [cell.contentView addSubview:totalLabel];
        
        UILabel *deliveryLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 100, 20)];
        deliveryLabel.backgroundColor = [UIColor clearColor];
        deliveryLabel.font = [UIFont systemFontOfSize:11.f];
        deliveryLabel.adjustsFontSizeToFitWidth = YES;
        deliveryLabel.text = [NSString stringWithFormat:@"配送费：￥%@",@"0"];
        [cell.contentView addSubview:deliveryLabel];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 10, kScreenWidth - 220, 20)];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.font = [UIFont boldSystemFontOfSize:12.f];
        priceLabel.adjustsFontSizeToFitWidth = YES;
        priceLabel.text = [NSString stringWithFormat:@"合计：￥%.2f",price];
        [cell.contentView addSubview:priceLabel];
        
        self.reviewField.frame = CGRectMake(10, 40, kScreenWidth - 20, 32);
        [cell.contentView addSubview:self.reviewField];
        return cell;
    }
    else {
        static NSString *orderIdentifier = @"orderIdentifier";
        OrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:orderIdentifier];
        if (cell == nil) {
            cell = [[OrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderIdentifier];
        }
        ShoppingCartModel *model = [_shoppingCartItem objectAtIndex:indexPath.row];
        cell.nameLabel.text = model.cartTitle;
        cell.openPriceLabel.text = [NSString stringWithFormat:@"(含开通费￥%.2f)",model.channelCost];
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.cartPrice + model.channelCost];
        cell.numberLabel.text = [NSString stringWithFormat:@"X %d",model.cartCount];
        cell.brandLabel.text = [NSString stringWithFormat:@"品牌型号 %@",model.cartModel];
        cell.channelLabel.text = [NSString stringWithFormat:@"支付通道 %@",model.cartChannel];
        [cell.pictureView sd_setImageWithURL:[NSURL URLWithString:model.cartImagePath]
                            placeholderImage:nil];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [_shoppingCartItem count]) {
        return 90.f;
    }
    return kOrderDetailCellHeight;
}

#pragma mark - UITextField

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.editingField = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.editingField = nil;
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 键盘

- (void)handleKeyboardDidShow:(NSNotification *)paramNotification {
    //获取键盘高度
    CGRect keyboardRect = [[[paramNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect fieldRect = [[self.editingField superview] convertRect:self.editingField.frame toView:self.view];
    CGFloat topHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat offsetY = keyboardRect.size.height - (kScreenHeight - topHeight - fieldRect.origin.y - fieldRect.size.height);
    self.primaryPoint = self.tableView.contentOffset;
    if (offsetY > 0 && self.offset == 0) {
        self.offset = offsetY;
        [self.tableView setContentOffset:CGPointMake(0, self.primaryPoint.y + self.offset) animated:YES];
    }
}

- (void)handleKeyboardDidHidden {
    if (self.offset != 0) {
        [self.tableView setContentOffset:CGPointMake(0, self.primaryPoint.y) animated:YES];
        self.offset = 0;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.editingField) {
        self.offset = 0;
        [self.editingField resignFirstResponder];
    }
}

@end
