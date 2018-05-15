//
//  DiscountCouponDetailViewController.m
//  Accountant
//
//  Created by aaa on 2017/12/6.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DiscountCouponDetailViewController.h"

@interface DiscountCouponDetailViewController ()

@property (nonatomic, strong)UIView * backView;
@property (nonatomic, strong)UIImageView * backImageView;

@property (nonatomic, strong)UILabel * priceLB;
@property (nonatomic, strong)UILabel * stateLB;

@property (nonatomic, strong)UILabel * titleLB;
@property (nonatomic, strong)UILabel * detailLB;

@property (nonatomic, strong)UILabel *expireTimeLB;

@property (nonatomic, strong)UIButton *useBtn;

@end

@implementation DiscountCouponDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self navigationViewSetup];
    [self prepareUI];
    [self refreshUIWith:self.infoDic];
}

- (void)navigationViewSetup
{
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, kScreenWidth, 64)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"卡券详情";
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
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight)];
    [self.view addSubview:self.backView];
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.backView.bounds;
    gradientLayer.colors = @[(id)UIColorFromRGB(0x55abf4).CGColor,(id)UIColorFromRGB(0x7374f3).CGColor];
    gradientLayer.locations = @[@0,@0.5,@1];
    [gradientLayer setStartPoint:CGPointMake(0.5, 0)];
    [gradientLayer setEndPoint:CGPointMake(0.5, 1)];
    [self.backView.layer addSublayer:gradientLayer];
    
    self.backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 36, kScreenWidth - 40, self.backView.hd_height - 72)];
    self.backImageView.userInteractionEnabled = YES;
    self.backImageView.image = [UIImage imageNamed:@"bg_yhqxq"];
    [self.backView addSubview:self.backImageView];
    
    self.priceLB = [[UILabel alloc]initWithFrame:CGRectMake(0, self.backImageView.hd_height * 0.3 * 4 / 15, self.backImageView.hd_width, self.backImageView.hd_height * 0.45 * 0.3)];
    self.priceLB.font = [UIFont systemFontOfSize:33];
    self.priceLB.textAlignment = 1;
    self.priceLB.textColor = UIColorFromRGB(0xff5000);
    [self.backImageView addSubview:self.priceLB];
    
    self.stateLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.priceLB.frame) + 10, self.backImageView.hd_width, 15)];
    self.stateLB.font = [UIFont systemFontOfSize:14];
    self.stateLB.textAlignment = 1;
    self.stateLB.textColor = UIColorFromRGB(0xff5000);
    [self.backImageView addSubview:self.stateLB];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, self.backImageView.hd_height * 0.3 + self.backImageView.hd_height * 0.3 * 0.2, self.backImageView.hd_width, 20)];
    self.titleLB.font = [UIFont systemFontOfSize:18];
    self.titleLB.textAlignment = 1;
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    [self.backImageView addSubview:self.titleLB];
    
    self.detailLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLB.frame) + 20, self.backImageView.hd_width, self.backImageView.hd_height * 0.3 * 0.67 - 40)];
    self.detailLB.font = [UIFont systemFontOfSize:14];
    self.detailLB.textAlignment = 1;
    self.detailLB.numberOfLines = 0;
    self.detailLB.textColor = UIColorFromRGB(0x666666);
    [self.backImageView addSubview:self.detailLB];
    
    self.expireTimeLB = [[UILabel alloc]initWithFrame:CGRectMake(0, self.backImageView.hd_height * 0.6 + 30, self.backImageView.hd_width, 40)];
    self.expireTimeLB.font = [UIFont systemFontOfSize:12];
    self.expireTimeLB.textAlignment = 1;
    self.expireTimeLB.numberOfLines = 0;
    self.expireTimeLB.textColor = UIColorFromRGB(0x666666);
    [self.backImageView addSubview:self.expireTimeLB];
    
    self.useBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.useBtn.frame = CGRectMake(self.backImageView.hd_width / 2 - 80, CGRectGetMaxY(self.expireTimeLB.frame) + self.backImageView.hd_height * 0.4 * 0.125, 160, 45);
    [self.useBtn setTitle:@"去使用" forState:UIControlStateNormal];
    self.useBtn.backgroundColor = UIColorFromRGB(0x2fb4fe);
    self.useBtn.layer.cornerRadius = 5;
    self.useBtn.layer.masksToBounds = YES;
    self.useBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [self.backImageView addSubview:self.useBtn];
}

- (void)refreshUIWith:(NSDictionary *)infoDic
{
    self.priceLB.attributedText = [self getPriceText:[infoDic objectForKey:@"CouponPrice"]];
    switch ([[infoDic objectForKey:@"State"] intValue]) {
        case 0:
            self.stateLB.text = @"未使用";
            break;
        case 1:
            self.stateLB.text = @"已使用";
            break;
        case 2:
            self.stateLB.text = @"已过期";
            break;
        default:
            break;
    }
    self.titleLB.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"CouponName"]];
    self.detailLB.attributedText = [UIUtility getSpaceLabelStr:[NSString stringWithFormat:@"使用条件：最低消费%@\n消费仅限会员购买使用，消费不低于%@元", [infoDic objectForKey:@"Area"],[infoDic objectForKey:@"Area"]] withFont:[UIFont systemFontOfSize:14]  withAlignment:NSTextAlignmentCenter];
    self.expireTimeLB.attributedText = [UIUtility getSpaceLabelStr:[NSString stringWithFormat:@"有效期：%@\n不允许和其他抵用券叠加使用", [infoDic objectForKey:@"EndDate"]] withFont:[UIFont systemFontOfSize:12]  withAlignment:NSTextAlignmentCenter];
    
}

- (NSMutableAttributedString *)getPriceText:(NSString *)priceStr
{
    NSString * str = [NSString stringWithFormat:@"￥%@", priceStr];
    NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSDictionary * attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:self.priceLB.hd_height]};
    [mStr addAttributes:attribute range:NSMakeRange(1, str.length - 1)];
    return mStr;
}

@end
