//
//  StudyPlanViewController.m
//  Accountant
//
//  Created by aaa on 2017/12/8.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "StudyPlanViewController.h"
#import "StudyPlanFirstViewController.h"

@interface StudyPlanViewController ()

@property (nonatomic, strong)UIImageView * imageView;
@property (nonatomic, strong)UILabel * detailLB;
@property (nonatomic, strong)UIButton * startBtn;

@end

@implementation StudyPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationViewSetup];
    [self prepareUI];
}

- (void)navigationViewSetup
{
    
    self.navigationItem.title = @"学习计划";
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - (kStatusBarHeight + kNavigationBarHeight) )];
    backView.backgroundColor = UIColorFromRGB(0xedf0f0);
    [self.view addSubview:backView];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(24, 30, kScreenWidth - 48, kScreenWidth - 48)];
    self.imageView.image = [UIImage imageNamed:@"img_xxjh"];
    [backView addSubview:self.imageView];
    
    self.detailLB = [[UILabel alloc]initWithFrame:CGRectMake(24, CGRectGetMaxY(self.imageView.frame) + 45, kScreenWidth - 48, 60)];
    self.detailLB.textColor = UIColorFromRGB(0x333333);
    self.detailLB.font = [UIFont systemFontOfSize:12];
    self.detailLB.numberOfLines = 0;
    [backView addSubview:self.detailLB];
    
    NSString * str = @"为了让您更有效的学习，会计教练专家将给您设计一套学习方案。一定要如实描述自己的情况哦，这样专家才会给您制定更优质适合您的学习方案哦!";
    self.detailLB.attributedText = [UIUtility getSpaceLabelStr:str withFont:[UIFont systemFontOfSize:12] withFirstLineHeadIndent:30];
    
    self.startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.startBtn.frame = CGRectMake(24, backView.hd_height - 95, kScreenWidth - 48, 41);
    [self.startBtn setTitle:@"开始定制" forState:UIControlStateNormal];
    [self.startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.startBtn.backgroundColor = UIColorFromRGB(0x1c71fa);
    self.startBtn.layer.cornerRadius = self.startBtn.hd_height / 2.0;
    self.startBtn.layer.masksToBounds = YES;
    [backView addSubview:self.startBtn];
    [self.startBtn addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)startAction
{
    NSLog(@"开始定制");
    StudyPlanFirstViewController * firstVC = [[StudyPlanFirstViewController alloc]init];
    
    [self.navigationController pushViewController:firstVC animated:YES];
}

@end
