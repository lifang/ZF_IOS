//
//  GuideUIViewController.m
//  ZFUB
//
//  Created by wufei on 15/4/29.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "GuideUIViewController.h"

@interface GuideUIViewController ()

@property (nonatomic, strong) UIView *  GuideView;

@end

@implementation GuideUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float wide=[[UIScreen mainScreen] bounds].size.width;
    float high=[[UIScreen mainScreen] bounds].size.height;
    
    
    _GuideView = [[UIView alloc]init];
    _GuideView.frame = CGRectMake(0, 0, wide, high);
    _GuideView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_GuideView];
    
    NSArray *arr=[NSArray arrayWithObjects:@"iphone1",@"iphone2",@"iphone3",@"iphone4", nil];
    //数组内存放的是我要显示的假引导页面图片
    UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize=CGSizeMake(wide*arr.count, high);
    scrollView.pagingEnabled=YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    [_GuideView addSubview:scrollView];
    for (int i=0; i<arr.count; i++) {
        UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(i*wide, 0, wide, high)];
        img.image=[UIImage imageNamed:arr[i]];
        [scrollView addSubview:img];
    }
    
    /*
    UIButton *applyBtn=[[UIButton alloc] init];
    applyBtn.frame=CGRectMake(24+wide*3, high-60-50, (wide-48-50)/2.0, 50);
    applyBtn.layer.masksToBounds=YES;
    applyBtn.layer.borderWidth=1.0;
    applyBtn.layer.cornerRadius=8.0;
    // applyBtn.layer.borderColor=[UIColor colorWithHexString:@"006fd5"].CGColor;
    applyBtn.layer.borderColor=[UIColor colorWithRed:0 green:0.435 blue:0.835 alpha:1].CGColor;
    [applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [applyBtn setTitle:@"申请成为代理商" forState:UIControlStateNormal];
    //[applyBtn setBackgroundColor:[UIColor colorWithHexString:@"006fd5"]];
    [applyBtn setBackgroundColor:[UIColor colorWithRed:0 green:0.435 blue:0.835 alpha:1]];
    [applyBtn addTarget:self action:@selector(applyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:applyBtn];
     */
    
    UIButton *useBtn=[[UIButton alloc] init];
    useBtn.frame=CGRectMake(24+wide*3+(wide-48-50)/2.0+50, high-60-50, (wide-48-50)/2.0, 50);
    useBtn.layer.masksToBounds=YES;
    useBtn.layer.borderWidth=1.0;
    useBtn.layer.cornerRadius=8.0;
    useBtn.layer.borderColor=[UIColor colorWithRed:0 green:0.435 blue:0.835 alpha:1].CGColor;
    [useBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [useBtn setTitle:@"马上使用" forState:UIControlStateNormal];
    // [useBtn setBackgroundColor:[UIColor colorWithHexString:@"006fd5"]];
    [useBtn setBackgroundColor:[UIColor colorWithRed:0 green:0.435 blue:0.835 alpha:1]];
    [useBtn addTarget:self action:@selector(useBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:useBtn];
    
    
}

-(void)useBtnClick:(id)sender
{
    [_GuideView removeFromSuperview];
    //[[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    
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
