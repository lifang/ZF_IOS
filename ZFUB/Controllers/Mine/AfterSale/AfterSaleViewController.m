//
//  AfterSaleViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/30.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "AfterSaleViewController.h"
#import "AfterSaleView.h"
#import "CustomerServiceController.h"

@interface AfterSaleViewController ()

@end

@implementation AfterSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"售后记录";
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
    self.view.backgroundColor = kColor(244, 243, 243, 1);
    CGFloat topSpace = 20.f;
    CGFloat hSpace = 20.f;
    
    CGFloat lineWidth = 1.f;
    CGFloat moduleWidth = (kScreenWidth - 2 * lineWidth - 2 * hSpace) / 3;
    CGFloat moduleHeight = 70.f;
    NSArray *nameArray = [NSArray arrayWithObjects:
                          @"维修记录",
                          @"退货记录",
                          @"注销记录",
                          @"换货记录",
                          @"更新资料记录",
                          @"租赁退还记录",
//                          @"修改到账日期记录",
                          nil];
    CGRect rect = CGRectMake(hSpace, topSpace, moduleWidth, moduleHeight);
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            int index = i * 3 + j;
            if (index > 5) {
                break;
            }
            rect.origin.x = (moduleWidth + lineWidth) * j + hSpace;
            rect.origin.y = (moduleHeight + lineWidth) * i + topSpace;
            AfterSaleView *button = [AfterSaleView buttonWithType:UIButtonTypeCustom];
            button.frame = rect;
            button.tag = index + 1;
            NSString *titleName = [nameArray objectAtIndex:index];
            NSString *imageName = [NSString stringWithFormat:@"after_sale%d.png",index + 1];
            [button setTitleName:titleName imageName:imageName];
            [button addTarget:self action:@selector(selectedModule:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
        }
    }
    //划线
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(hSpace + moduleWidth, topSpace, lineWidth, 2 * moduleHeight + 2 * lineWidth)];
    firstLine.backgroundColor = kColor(224, 223, 223, 1);
    [self.view addSubview:firstLine];
    
    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(hSpace + moduleWidth * 2 + lineWidth, topSpace, lineWidth, 2 * moduleHeight + 2 * lineWidth)];
    secondLine.backgroundColor = kColor(224, 223, 223, 1);
    [self.view addSubview:secondLine];
    
    UIView *thirdLine = [[UIView alloc] initWithFrame:CGRectMake(hSpace, topSpace + moduleHeight, kScreenWidth - 2 * hSpace, lineWidth)];
    thirdLine.backgroundColor = kColor(224, 223, 223, 1);
    [self.view addSubview:thirdLine];
    
//    UIView *forthLine = [[UIView alloc] initWithFrame:CGRectMake(hSpace, topSpace + moduleHeight * 2 + lineWidth, kScreenWidth - 2 * hSpace, lineWidth)];
//    forthLine.backgroundColor = kColor(224, 223, 223, 1);
//    [self.view addSubview:forthLine];
    
}

#pragma mark - Action

- (IBAction)selectedModule:(id)sender {
    AfterSaleView *moduleView = (AfterSaleView *)sender;
    NSLog(@"%ld",moduleView.tag);
    CustomerServiceController *csC = [[CustomerServiceController alloc] init];
    csC.csType = (CSType)moduleView.tag;
    [self.navigationController pushViewController:csC animated:YES];
}

@end
