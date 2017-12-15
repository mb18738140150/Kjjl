//
//  MemberDetailViewController.m
//  Accountant
//
//  Created by aaa on 2017/11/8.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "MemberDetailViewController.h"
#import "MSegmentControl.h"
#import "MemberDetailView.h"

@interface MemberDetailViewController ()

@property (nonatomic, strong)MSegmentControl *memberLevelSegment;
@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic, strong)MemberDetailView *memberDetail_K1;
@property (nonatomic, strong)MemberDetailView *memberDetail_K2;
@property (nonatomic, strong)MemberDetailView *memberDetail_K3;
@property (nonatomic, strong)MemberDetailView *memberDetail_K4;
@property (nonatomic, strong)MemberDetailView *memberDetail_K5;

@end

@implementation MemberDetailViewController

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
    
    self.navigationItem.title = @"会员详情";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
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
    self.memberLevelSegment = [[MSegmentControl alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 70) andItems:@[@"K1",@"K2",@"K3",@"K4",@"K5"]];
    [self.view addSubview:self.memberLevelSegment];
    
    __weak typeof(self)weakSelf = self;
    self.memberLevelSegment.segmentClickBlock = ^(int index) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.scrollView setContentOffset:CGPointMake(kScreenWidth * index, 0) animated:YES];
        });
    };
    [self.memberLevelSegment selectWith:2];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.memberLevelSegment.frame), kScreenWidth, kScreenHeight - CGRectGetMaxY(self.memberLevelSegment.frame) - kStatusBarHeight - self.navigationController.navigationBar.frame.size.height)];
    [self.view addSubview:self.scrollView];
    
    // K1
    self.memberDetail_K1 = [[MemberDetailView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.hd_width, self.scrollView.hd_height)];
    [self.memberDetail_K1 refreshUIWith:MemberLevel_K1];
    [self.scrollView addSubview:self.memberDetail_K1];
    
    // K2
    self.memberDetail_K2 = [[MemberDetailView alloc]initWithFrame:CGRectMake( kScreenWidth,0, self.scrollView.hd_width, self.scrollView.hd_height)];
    [self.memberDetail_K2 refreshUIWith:MemberLevel_K2];
    [self.scrollView addSubview:self.memberDetail_K2];
    
    // K3
    self.memberDetail_K3 = [[MemberDetailView alloc]initWithFrame:CGRectMake( kScreenWidth * 2,0, self.scrollView.hd_width, self.scrollView.hd_height)];
    [self.memberDetail_K3 refreshUIWith:MemberLevel_K3];
    [self.scrollView addSubview:self.memberDetail_K3];
    
    // K4
    self.memberDetail_K4 = [[MemberDetailView alloc]initWithFrame:CGRectMake( kScreenWidth * 3,0, self.scrollView.hd_width, self.scrollView.hd_height)];
    [self.memberDetail_K4 refreshUIWith:MemberLevel_K4];
    [self.scrollView addSubview:self.memberDetail_K4];
    
    // K5
    self.memberDetail_K5 = [[MemberDetailView alloc]initWithFrame:CGRectMake( kScreenWidth * 4,0, self.scrollView.hd_width, self.scrollView.hd_height)];
    [self.memberDetail_K5 refreshUIWith:MemberLevel_K5];
    [self.scrollView addSubview:self.memberDetail_K5];
 
    self.scrollView.scrollEnabled = NO;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * 5, self.scrollView.hd_height);
    
    [self disposeAction];
    
}

- (void)disposeAction
{
    __weak typeof(self)weakSelf = self;
    self.memberDetail_K1.memberCansultBlock = ^{
        [weakSelf cansultAction];
    };
    self.memberDetail_K1.memberBuyBlock = ^(MemberLevel level) {
        [weakSelf buyMemberAction:level];
    };
    
    self.memberDetail_K2.memberCansultBlock = ^{
        [weakSelf cansultAction];
    };
    self.memberDetail_K2.memberBuyBlock = ^(MemberLevel level) {
        [weakSelf buyMemberAction:level];
    };
    
    self.memberDetail_K3.memberCansultBlock = ^{
        [weakSelf cansultAction];
    };
    self.memberDetail_K3.memberBuyBlock = ^(MemberLevel level) {
        [weakSelf buyMemberAction:level];
    };
    
    self.memberDetail_K4.memberCansultBlock = ^{
        [weakSelf cansultAction];
    };
    self.memberDetail_K4.memberBuyBlock = ^(MemberLevel level) {
        [weakSelf buyMemberAction:level];
    };
    
    self.memberDetail_K5.memberCansultBlock = ^{
        [weakSelf cansultAction];
    };
    self.memberDetail_K5.memberBuyBlock = ^(MemberLevel level) {
        [weakSelf buyMemberAction:level];
    };
    
}

- (void)cansultAction
{
    NSLog(@"咨询");
}

- (void)buyMemberAction:(MemberLevel)level
{
    NSLog(@"buy %ld", level);
}

@end
