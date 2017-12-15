//
//  IntegralRuleViewController.m
//  Accountant
//
//  Created by aaa on 2017/12/6.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "IntegralRuleViewController.h"

@interface IntegralRuleViewController ()

@property (nonatomic, strong)UILabel * ruleLB;

@end

@implementation IntegralRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self navigationViewSetup];
    [self prepareUI];
}

- (void)navigationViewSetup
{
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, kScreenWidth, 64)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"积分规则";
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
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backView.backgroundColor = UIColorFromRGB(0xedf0f0);
    [self.view addSubview:backView];
    
    NSString * str = @"1、即日起，通过活动页面分享会计教练给您的朋友，当他们完成注册首次登陆会计教练后，您将获得30积分。\n2、绑定手机号，您将获得30积分。\n3、通过反馈页面说出你对会计教练产品的建议和不足之处，您将获得10积分。\n4、课程学习过程中，进行笔记的记录，您将获得2积分。\n5、在答疑页面，发布您的疑难问题，您将获得2积分。";
    CGFloat height = [UIUtility getLineSpaceLabelHeght:str font:kMainFont width:kScreenWidth - 40];
    
    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, height + 60)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    self.ruleLB = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, kScreenWidth - 40, height + 10)];
    self.ruleLB.numberOfLines = 0;
    self.ruleLB.font = kMainFont;
    self.ruleLB.textColor = UIColorFromRGB(0x333333);
    self.ruleLB.attributedText = [UIUtility getLineSpaceLabelStr:[[NSMutableAttributedString alloc] initWithString:str] withFont:kMainFont];
    [whiteView addSubview:self.ruleLB];
}

@end
