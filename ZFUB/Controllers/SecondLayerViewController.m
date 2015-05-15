//
//  SecondLayerViewController.m
//  ZFUB
//
//  Created by wufei on 15/5/11.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "SecondLayerViewController.h"

@interface SecondLayerViewController ()

@end

@implementation SecondLayerViewController
@synthesize attributedString;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 0, 20, 44);
       // backBtn.titleLabel.font = IconFontWithSize(16);
        //[backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //[backBtn setTitle:@"\U0000e602" forState:UIControlStateNormal];
        
        //[backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
       // UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:kImageName(@"back.png")
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(goBack)];
        self.navigationItem.leftBarButtonItem = leftItem;

       // self.navigationItem.leftBarButtonItem = leftBarBtn;
    }
    return self;
}
-(void) goBack
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
