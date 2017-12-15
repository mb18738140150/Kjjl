//
//  IntegralViewController.m
//  Accountant
//
//  Created by aaa on 2017/12/6.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "IntegralViewController.h"
#import "IntegralRuleViewController.h"
#import "GetMoreIntegralViewController.h"


@interface IntegralViewController ()
@property (weak, nonatomic) IBOutlet UIView *whiteBackView;

@property (weak, nonatomic) IBOutlet UIView *integralView;
@property (weak, nonatomic) IBOutlet UILabel *integralLB;


@end

@implementation IntegralViewController

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
    
    self.navigationItem.title = @"积分";
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

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50};
}

- (void)prepareUI
{
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.integralLB.frame;
    gradientLayer.colors = @[(id)UIColorFromRGB(0x1da0f8).CGColor,(id)UIColorFromRGB(0x1c77fa).CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    [self.whiteBackView.layer addSublayer:gradientLayer];
    gradientLayer.mask = self.integralLB.layer;
    self.integralLB.frame = gradientLayer.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)lookIntegralRule:(id)sender {
    
    IntegralRuleViewController * ruleVC = [[IntegralRuleViewController alloc]init];
    
    [self.navigationController pushViewController:ruleVC animated:YES];
}
- (IBAction)getMoreIntegral:(id)sender {
    
    GetMoreIntegralViewController * getMoreVC = [[GetMoreIntegralViewController alloc]init];
    [self.navigationController pushViewController:getMoreVC animated:YES];
    
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
