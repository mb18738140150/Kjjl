//
//  ProblemContentViewController.m
//  Accountant
//
//  Created by aaa on 2018/1/22.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "ProblemContentViewController.h"

@interface ProblemContentViewController ()

@property (nonatomic, strong)UITextView * contentLB;

@end

@implementation ProblemContentViewController

- (void)viewDidLoad {
    [self navigationViewSetup];
    [self prepareUI];
}

- (void)navigationViewSetup
{
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, kScreenWidth, 64)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    
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
    self.contentLB = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight)];
    self.contentLB.editable = NO;
    self.contentLB.textColor = UIColorFromRGB(0x666666);
    self.contentLB.font = kMainFont;
    [self.view addSubview:self.contentLB];
    
    NSAttributedString * attributeStr = [[NSAttributedString alloc] initWithData:[self.name dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    self.contentLB.attributedText = attributeStr;
}

@end
