//
//  ProgressCheckViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ProgressCheckViewController.h"
#import "FormView.h"

@interface ProgressCheckViewController ()

@end

@implementation ProgressCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申请开通进度查询";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat height = [FormView heightWithRowCount:3 hasTitle:YES];
    FormView *formView = [[FormView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    NSArray *titleArray = [NSArray arrayWithObjects:@"交易类",@"费率",@"说明", nil];
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"T+1",@"0",
                           @"0",@"1",
                           @"标准结算，无",@"2",nil];
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"T+2",@"0",
                           @"6%",@"1",
                           @"最低费",@"2",nil];
    NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"T+3",@"0",
                           @"50%",@"1",
                           @"最高费",@"2",nil];
    NSArray *contentArray = [NSArray arrayWithObjects:dict1,dict2,dict3, nil];
    [formView createFormWithTitle:@"交易费率" column:titleArray content:contentArray];
    [self.view addSubview:formView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
