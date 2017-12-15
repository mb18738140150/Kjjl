//
//  RecommendDetailViewController.m
//  Accountant
//
//  Created by aaa on 2017/12/7.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "RecommendDetailViewController.h"
#import "RecommendViewController.h"
#import "CategoryView.h"

#define kImageHeight kScreenWidth * 1.13

@interface RecommendDetailViewController ()

@property (nonatomic, strong)UILabel * integralLB;

@property (nonatomic, strong)UIScrollView * scrollView;

@end

@implementation RecommendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.navBarBgAlpha = @"0.0";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self navigationViewSetup];
    [self prepareUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getImtegralAction:) name:kNotificationOfGetIntegralClick object:nil];
    
}

- (void)navigationViewSetup
{
    self.navigationItem.title = @"推荐有奖";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
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
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)prepareUI
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -(kStatusBarHeight + kNavigationBarHeight), kScreenWidth, kScreenHeight)];
    self.scrollView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.view addSubview:self.scrollView];
    
    UIImageView * topView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kImageHeight)];
    topView.tag = 1000;
    topView.image = [UIImage imageNamed:@"bg_tjyj"];
    [self.scrollView addSubview:topView];
    
    UIImageView * yaoqingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(topView.hd_width * 0.17, topView.hd_height * 0.18, topView.hd_width * 0.29, topView.hd_height * 0.13)];
    yaoqingImageView.image = [UIImage imageNamed:@"img_jljf"];
    [topView addSubview:yaoqingImageView];
    
    self.integralLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(yaoqingImageView.frame) + 10, yaoqingImageView.hd_y - 8, topView.hd_width * 0.23, topView.hd_height * 0.13 + 8)];
    self.integralLB.font = [UIFont boldSystemFontOfSize:self.integralLB.hd_height];
    self.integralLB.text = @"20";
    self.integralLB.textColor = UIColorFromRGB(0xfff93c);
    self.integralLB.textAlignment = 1;
    [topView addSubview:self.integralLB];
    
    UILabel * jifenLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.integralLB.frame) + 10, topView.hd_height * 0.18, topView.hd_width * 0.08, topView.hd_height * 0.13)];
    jifenLB.textAlignment = 1;
    jifenLB.textColor = UIColorFromRGB(0xfff93c);
    jifenLB.text = @"积分";
    jifenLB.numberOfLines = 0;
    jifenLB.font = [UIFont boldSystemFontOfSize:(jifenLB.hd_height - 20) / 2];
    [topView addSubview:jifenLB];
    
    UIImageView * introduceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.14 * topView.hd_width, CGRectGetMaxY(self.integralLB.frame) + 15, topView.hd_width * 0.72, topView.hd_height * 0.08)];
    introduceImageView.image = [UIImage imageNamed:@"bg_jfms"];
     [topView addSubview:introduceImageView];
    
    UILabel * introduceLB = [[UILabel alloc]initWithFrame:CGRectMake(0.14 * topView.hd_width, CGRectGetMaxY(self.integralLB.frame) + 15, topView.hd_width * 0.72, topView.hd_height * 0.08 - 5)];
    introduceLB.textColor = UIColorFromRGB(0xf71e48);
    introduceLB.textAlignment = 1;
    introduceLB.font = [UIFont systemFontOfSize:16];
    introduceLB.text = @"不设上限  邀请越多  积分越多";
    [topView addSubview:introduceLB];
    
    UIView * middleView = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(introduceImageView.frame) + topView.hd_height * 0.05, topView.hd_width - 30, topView.hd_height * 0.43)];
    middleView.backgroundColor = UIColorFromRGB(0xfef9f0);
    middleView.layer.cornerRadius = 5;
    middleView.layer.masksToBounds = YES;
    [topView addSubview:middleView];
    
    UIImageView * detailImageView = [[UIImageView alloc]initWithFrame:CGRectMake(topView.hd_width * 0.12, middleView.hd_y + topView.hd_height * 0.06, topView.hd_width * 0.76, topView.hd_height * 0.2)];
    detailImageView.image = [UIImage imageNamed:@"img_ktms"];
    [topView addSubview:detailImageView];
    
    UIView * separateLineView = [[UIView alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(detailImageView.frame) + 10, topView.hd_width - 50, 1)];
    separateLineView.backgroundColor = UIColorFromRGB(0xcccccc);
    [topView addSubview:separateLineView];
    
    CGFloat labelWidth = (topView.hd_width - 30) / 3;
    
    UILabel * shareLB = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(separateLineView.frame) + 10, labelWidth, 40)];
    shareLB.textColor = UIColorFromRGB(0xf83b32);
    shareLB.font = [UIFont systemFontOfSize:12];
    shareLB.numberOfLines = 0;
    shareLB.textAlignment = 1;
    shareLB.attributedText = [UIUtility getSpaceLabelStr:@"分享链接\n给好友" withFont:[UIFont systemFontOfSize:12] withAlignment:NSTextAlignmentCenter];
    [topView addSubview:shareLB];
    
    UILabel * bindLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shareLB.frame), CGRectGetMaxY(separateLineView.frame) + 10, labelWidth, 40)];
    bindLB.textColor = UIColorFromRGB(0xf83b32);
    bindLB.font = [UIFont systemFontOfSize:12];
    bindLB.numberOfLines = 0;
    bindLB.textAlignment = 1;
    bindLB.attributedText = [UIUtility getSpaceLabelStr:@"好友通过链接注册并绑定手机号" withFont:[UIFont systemFontOfSize:12] withAlignment:NSTextAlignmentCenter];
    [topView addSubview:bindLB];
    
    UILabel * getILB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bindLB.frame), CGRectGetMaxY(separateLineView.frame) + 10, labelWidth, 40)];
    getILB.textColor = UIColorFromRGB(0xf83b32);
    getILB.font = [UIFont systemFontOfSize:12];
    getILB.numberOfLines = 0;
    getILB.textAlignment = 1;
    getILB.attributedText = [UIUtility getSpaceLabelStr:@"20积分\n归你啦" withFont:[UIFont systemFontOfSize:12] withAlignment:NSTextAlignmentCenter];
    [topView addSubview:getILB];
    
    [self subShareViews];
    
    UIButton * getMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getMoreBtn.frame = CGRectMake(15, CGRectGetMaxY(topView.frame) + 125, kScreenWidth - 30, 40);
    [getMoreBtn setTitle:@"更多邀请方式" forState:UIControlStateNormal];
    [getMoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    getMoreBtn.backgroundColor = UIColorFromRGB(0xf83d33);
    getMoreBtn.layer.cornerRadius = 5;
    getMoreBtn.layer.masksToBounds = YES;
    [self.scrollView addSubview:getMoreBtn];
    [getMoreBtn addTarget:self action:@selector(getMoreAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * recommendDetailLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(getMoreBtn.frame) + 10, kScreenWidth, 15)];
    recommendDetailLB.textColor = UIColorFromRGB(0x666666);
    recommendDetailLB.font = [UIFont systemFontOfSize:12];
    recommendDetailLB.attributedText = [UIUtility getSpaceLabelStr:@"已成功邀请0人，累计获得奖励0积分" withFont:[UIFont systemFontOfSize:12] withAlignment:NSTextAlignmentCenter];
    [self.scrollView addSubview:recommendDetailLB];
    
    UIButton * lookRuleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lookRuleBtn.frame = CGRectMake(kScreenWidth / 2 - 80, CGRectGetMaxY(recommendDetailLB.frame) + 4, 160, 40);
    [lookRuleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    lookRuleBtn.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [lookRuleBtn setTitleColor:UIColorFromRGB(0x1e70fa) forState:UIControlStateNormal];
    lookRuleBtn.layer.cornerRadius = 5;
    lookRuleBtn.layer.masksToBounds = YES;
    [self.scrollView addSubview:lookRuleBtn];
    [lookRuleBtn addTarget:self action:@selector(lookRuleAction) forControlEvents:UIControlEventTouchUpInside];
    [lookRuleBtn setAttributedTitle:[self getAttribureText:@"查看活动规则"] forState:UIControlStateNormal];
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(lookRuleBtn.frame) + 20);
    
}

- (void)subShareViews
{
    
    NSArray *infoArray = @[@{kCourseCategoryName:@"微信好友",
                             kCourseCategoryCoverUrl:@"img_wx",
                             kCourseCategoryId:@(1)},
                           @{kCourseCategoryName:@"微信朋友圈",
                             kCourseCategoryCoverUrl:@"img_pyq",
                             kCourseCategoryId:@(2)},
                           @{kCourseCategoryName:@"QQ好友",
                             kCourseCategoryCoverUrl:@"img_qq",
                             kCourseCategoryId:@(3)},
                           @{kCourseCategoryName:@"扫码推荐",
                             kCourseCategoryCoverUrl:@"img_sm",
                             kCourseCategoryId:@(4)}
                           ];
    
    UIImageView * topView = (UIImageView *)[self.view viewWithTag:1000];
    
    for (int i = 0; i < infoArray.count; i++) {
        CategoryView *cateView = [[CategoryView alloc] initWithFrame:CGRectMake(i%4 * ((kScreenWidth)/4), i/4 * (kCellHeightOfCategoryView+10) + 25 + CGRectGetMaxY(topView.frame), ((kScreenWidth)/4), kCellHeightOfCategoryView)];
        NSDictionary *cateInfo = [infoArray objectAtIndex:i];
        cateView.categoryId = [[cateInfo objectForKey:kCourseCategoryId] intValue];
        cateView.pageType = Page_getIntegral;
        cateView.categoryName = [cateInfo objectForKey:kCourseCategoryName];
        cateView.categoryCoverUrl = [cateInfo objectForKey:kCourseCategoryCoverUrl];
        [cateView setupContents];
        cateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [self.scrollView addSubview:cateView];
        
    }
}

- (void)getMoreAction
{
    NSLog(@"更多邀请方式");
}

- (void)lookRuleAction
{
    RecommendViewController * vc = [[RecommendViewController alloc]initWithNibName:@"RecommendViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableAttributedString *)getAttribureText:(NSString *)str
{
    NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSDictionary * attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:UIColorFromRGB(0x1e70fa),NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],NSBaselineOffsetAttributeName:@(-2)};
    [mStr setAttributes:attribute range:NSMakeRange(0, str.length)];
    return mStr;
}

#pragma mark - getIntegral
- (void)getImtegralAction:(NSNotification *)notification
{
    NSDictionary * infoDic = notification.object;
    
    NSLog(@"%@", infoDic);
    
}

@end
