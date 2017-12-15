//
//  RecommendViewController.m
//  Accountant
//
//  Created by aaa on 2017/12/6.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "RecommendViewController.h"

@interface RecommendViewController ()
@property (weak, nonatomic) IBOutlet UILabel *activityIntroduceLB;

@property (weak, nonatomic) IBOutlet UILabel *activityDetailLB;


@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationViewSetup];
    [self prepareUI];
}

- (void)navigationViewSetup
{
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, kScreenWidth, 64)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"活动规则";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //    self.navigationController.navigationBarHidden = YES;
    
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50};
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"public-返回"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareUI
{
    self.activityIntroduceLB.attributedText = [UIUtility getSpaceLabelStr:self.activityIntroduceLB.text withFont:kMainFont];
    self.activityDetailLB.attributedText = [UIUtility getSpaceLabelStr:self.activityDetailLB.text withFont:kMainFont];
}

@end
