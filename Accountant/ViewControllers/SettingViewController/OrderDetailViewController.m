//
//  OrderDetailViewController.m
//  Accountant
//
//  Created by aaa on 2017/12/4.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "BuyDetailViewController.h"

#define SPACE 10

@interface OrderDetailViewController ()<UserModule_PayOrderProtocol>

@property (nonatomic, strong)UIScrollView * scrollView;

@property (nonatomic, strong)UILabel * orderIdLB;
@property (nonatomic, strong)UILabel * orderTimeLB;
@property (nonatomic, strong)UILabel * orderStateLB;

@property (nonatomic, strong)UIView * orderDetailView;
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *orderTitleLB;
@property (nonatomic, strong)UILabel * priceLB;

@property (nonatomic, strong)UILabel *discountCouponLB;

@property (nonatomic, strong)UILabel * remartLB;
@property (nonatomic, strong)UIView * remarkSeperateView;
@property (nonatomic, strong)UILabel * realityPriceLB;
@property (nonatomic, strong)UIView * realitySeperateView;
@property (nonatomic, strong)UIButton * payBtn;

@property (nonatomic, strong)NSDictionary * payInfoDic;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navigationViewSetup];
    [self loadData];
    [self tableViewSetup];
    
}

- (void)navigationViewSetup
{
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, kScreenWidth, 64)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"订单详情";
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

- (void)loadData
{
    
}

- (void)tableViewSetup
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - self.navigationController.navigationBar.hd_height - kStatusBarHeight)];
    self.scrollView.backgroundColor = UIColorFromRGB(0xedf0f0);
    [self.view addSubview:self.scrollView];
    
    // 订单信息
    UIView * orderView = [[UIView alloc]initWithFrame:CGRectMake(SPACE, 17, kScreenWidth - 2 * SPACE, 197)];
    orderView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:orderView];
    
    UILabel * orderInfomationLB = [[UILabel alloc]initWithFrame:CGRectMake(14, 17, 100, 15)];
    orderInfomationLB.text = @"订单信息";
    orderInfomationLB.textColor = UIColorFromRGB(0x333333);
    orderInfomationLB.font = [UIFont systemFontOfSize:15];
    [orderView addSubview:orderInfomationLB];
    
    UIView * orderInfoSeparateView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(orderInfomationLB.frame) + 17, orderView.hd_width, 1)];
    orderInfoSeparateView.backgroundColor = UIColorFromRGB(0xedf0f0);
    [orderView addSubview:orderInfoSeparateView];
    
    UILabel * orderIdLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 16 + CGRectGetMaxY(orderInfoSeparateView.frame), 60, 15)];
    orderIdLabel.text = @"订单ID";
    orderIdLabel.textColor = UIColorFromRGB(0x666666);
    orderIdLabel.font = kMainFont;
    [orderView addSubview:orderIdLabel];
    
    self.orderIdLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(orderIdLabel.frame) + 30, orderIdLabel.hd_y, orderView.hd_width - 118, 15)];
    self.orderIdLB.text = [self.infoDic objectForKey:kOrderId];
    self.orderIdLB.font = kMainFont;
    self.orderIdLB.textColor = UIColorFromRGB(0x999999);
    [orderView addSubview:self.orderIdLB];
    
    UIView * orderIdSeperateView = [[UIView alloc]initWithFrame:CGRectMake(14, CGRectGetMaxY(self.orderIdLB.frame) + 16, orderView.hd_width - 28, 1)];
    orderIdSeperateView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [orderView addSubview:orderIdSeperateView];
    
    
    UILabel * orderTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, CGRectGetMaxY(orderIdSeperateView.frame) + 16, 60, 15)];
    orderTimeLabel.text = @"下单时间";
    orderTimeLabel.textColor = UIColorFromRGB(0x666666);
    orderTimeLabel.font = kMainFont;
    [orderView addSubview:orderTimeLabel];
    
    self.orderTimeLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(orderTimeLabel.frame) + 30, orderTimeLabel.hd_y, orderView.hd_width - 118, 15)];
    self.orderTimeLB.text = [self.infoDic objectForKey:kOrderTime];
    self.orderTimeLB.font = kMainFont;
    self.orderTimeLB.textColor = UIColorFromRGB(0x999999);
    [orderView addSubview:self.orderTimeLB];
    
    UIView * orderTimeSeperateView = [[UIView alloc]initWithFrame:CGRectMake(14, CGRectGetMaxY(self.orderTimeLB.frame) + 16, orderView.hd_width - 28, 1)];
    orderTimeSeperateView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [orderView addSubview:orderTimeSeperateView];
    
    UILabel * orderStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, CGRectGetMaxY(orderTimeSeperateView.frame) + 16, 60, 15)];
    orderStateLabel.text = @"订单状态";
    orderStateLabel.textColor = UIColorFromRGB(0x666666);
    orderStateLabel.font = kMainFont;
    [orderView addSubview:orderStateLabel];
    
    self.orderStateLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(orderStateLabel.frame) + 30, orderStateLabel.hd_y, orderView.hd_width - 118, 15)];
    
    self.orderStateLB.font = kMainFont;
    self.orderStateLB.textColor = UIColorFromRGB(0x999999);
    [orderView addSubview:self.orderStateLB];
    
    
    // 订单明细
    self.orderDetailView = [[UIView alloc]initWithFrame:CGRectMake(SPACE, CGRectGetMaxY(orderView.frame) + 10, kScreenWidth - 2 * SPACE, 339)];
    self.orderDetailView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.orderDetailView];
    
    UILabel * orderDetailtionLB = [[UILabel alloc]initWithFrame:CGRectMake(14, 17, 100, 15)];
    orderDetailtionLB.text = @"订单明细";
    orderDetailtionLB.textColor = UIColorFromRGB(0x333333);
    orderDetailtionLB.font = [UIFont systemFontOfSize:15];
    [self.orderDetailView addSubview:orderDetailtionLB];
    
    UIView * orderDetailSeparateView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(orderDetailtionLB.frame) + 17, self.orderDetailView.hd_width, 1)];
    orderDetailSeparateView.backgroundColor = UIColorFromRGB(0xedf0f0);
    [self.orderDetailView addSubview:orderDetailSeparateView];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(14, 15 + CGRectGetMaxY(orderDetailSeparateView.frame), 70, 50)];
    [self.orderDetailView addSubview:self.imageView];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[self.infoDic objectForKey:kCourseCover]]];
    
    self.orderTitleLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame) + 11, self.imageView.hd_y, self.orderDetailView.hd_width - 14 * 2 - 70 - 11, 15)];
    self.orderTitleLB.text = [self.infoDic objectForKey:kCourseName];
    self.orderTitleLB.textColor = UIColorFromRGB(0x333333);
    self.orderTitleLB.font = kMainFont;
    [self.orderDetailView addSubview:self.orderTitleLB];
    
    self.priceLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame) + 11, CGRectGetMaxY(self.orderTitleLB.frame) + 20, self.orderDetailView.hd_width - 14 * 2 - 70 - 11, 15)];
    self.priceLB.text = [NSString stringWithFormat:@"%@", [self.infoDic objectForKey:kPrice]];
    self.priceLB.textColor = UIColorFromRGB(0x666666);
    self.priceLB.font = kMainFont;
    [self.orderDetailView addSubview:self.priceLB];
    
    UIView * imageViewSeperateView = [[UIView alloc]initWithFrame:CGRectMake(14, CGRectGetMaxY(self.imageView.frame) + 15, self.orderDetailView.hd_width - 28, 1)];
    imageViewSeperateView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.orderDetailView addSubview:imageViewSeperateView];
    
    
    UILabel * discountCouponLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, CGRectGetMaxY(imageViewSeperateView.frame) + 16, 60, 15)];
    discountCouponLabel.text = @"优惠券";
    discountCouponLabel.textColor = UIColorFromRGB(0x666666);
    discountCouponLabel.font = kMainFont;
    [self.orderDetailView addSubview:discountCouponLabel];
    
    self.discountCouponLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(discountCouponLabel.frame) + 30, discountCouponLabel.hd_y, self.orderDetailView.hd_width - 118, 15)];
    self.discountCouponLB.text = [NSString stringWithFormat:@"优惠%.0f元", [[self.infoDic objectForKey:@"discountCoupon"] doubleValue]];
    self.discountCouponLB.textAlignment = NSTextAlignmentRight;
    self.discountCouponLB.font = kMainFont;
    self.discountCouponLB.textColor = UIColorFromRGB(0x999999);
    [self.orderDetailView addSubview:self.discountCouponLB];
    
    UIView * discountcouponSeperateView = [[UIView alloc]initWithFrame:CGRectMake(14, CGRectGetMaxY(self.discountCouponLB.frame) + 16, self.orderDetailView.hd_width - 28, 1)];
    discountcouponSeperateView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.orderDetailView addSubview:discountcouponSeperateView];
    
    UILabel * remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, CGRectGetMaxY(discountcouponSeperateView.frame) + 16, 60, 15)];
    remarkLabel.text = @"备注";
    remarkLabel.textColor = UIColorFromRGB(0x666666);
    remarkLabel.font = kMainFont;
    [self.orderDetailView addSubview:remarkLabel];
    
    self.remartLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(remarkLabel.frame) + 30, remarkLabel.hd_y, self.orderDetailView.hd_width - 118, 15)];
    self.remartLB.text = [self.infoDic objectForKey:kRemark];
    self.remartLB.numberOfLines = 0;
    self.remartLB.textAlignment = NSTextAlignmentRight;
    self.remartLB.font = kMainFont;
    self.remartLB.textColor = UIColorFromRGB(0x999999);
    [self.orderDetailView addSubview:self.remartLB];
    
    self.remarkSeperateView = [[UIView alloc]initWithFrame:CGRectMake(14, CGRectGetMaxY(self.remartLB.frame) + 16, self.orderDetailView.hd_width - 28, 1)];
    self.remarkSeperateView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.orderDetailView addSubview:self.remarkSeperateView];
    
    self.realityPriceLB = [[UILabel alloc]initWithFrame:CGRectMake(14, CGRectGetMaxY(self.remarkSeperateView.frame) + 16, self.orderDetailView.hd_width - 28, 15)];
    self.realityPriceLB.textColor = UIColorFromRGB( 0x333333);
    self.realityPriceLB.font = kMainFont;
    self.realityPriceLB.textAlignment = NSTextAlignmentRight;
    [self.orderDetailView addSubview:self.realityPriceLB];
    
    self.realitySeperateView = [[UIView alloc]initWithFrame:CGRectMake(14, CGRectGetMaxY(self.realityPriceLB.frame) + 16, self.orderDetailView.hd_width - 28, 1)];
    self.realitySeperateView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.orderDetailView addSubview:self.realitySeperateView];
    
    self.payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.payBtn.frame = CGRectMake(self.orderDetailView.hd_width - 94 - 14, CGRectGetMaxY(self.realitySeperateView.frame) +16, 94, 36);
    
    self.payBtn.backgroundColor = UIColorFromRGB(0xff4f00);
    [self.payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.payBtn.titleLabel.font = kMainFont;
    self.payBtn.layer.cornerRadius = 3;
    self.payBtn.layer.masksToBounds = YES;
    [self.orderDetailView addSubview:self.payBtn];
    
    if ([[self.infoDic objectForKey:kOrderStatus] intValue] == 0) {
        self.orderStateLB.text = @"待付款";
        [self.payBtn setTitle:@"去付款" forState:UIControlStateNormal];
    }else
    {
        self.orderStateLB.text = @"交易成功";
        [self.payBtn setTitle:@"已支付" forState:UIControlStateNormal];
        self.payBtn.backgroundColor = UIColorFromRGB(0x999999);
        self.payBtn.enabled = NO;
    }
    
    [self.payBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(self.orderDetailView.frame) + 20);
    
    [self resetWithInfoDic:self.infoDic];
}

- (void)resetWithInfoDic:(NSDictionary *)infoDic
{
    self.remartLB.text = @"";
    CGFloat height = [UIUtility getHeightWithText:self.remartLB.text font:kMainFont width:self.remartLB.hd_width];
    if (height > 15) {
        self.remartLB.textAlignment = NSTextAlignmentLeft;
    }
    [self.realityPriceLB setAttributedText: [self getRealityPrice:[NSString stringWithFormat:@"%@", [self.infoDic objectForKey:kRealityPrice]]]];
    
    [self refreshUI:height];
}

- (void)refreshUI:(CGFloat )height
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.remartLB.frame = CGRectMake(self.remartLB.hd_x, self.remartLB.hd_y, self.orderDetailView.hd_width - 118, height);
        self.remarkSeperateView.frame = CGRectMake(14, CGRectGetMaxY(self.remartLB.frame) + 16, self.orderDetailView.hd_width - 28, 1);
        self.realityPriceLB.frame = CGRectMake(14, CGRectGetMaxY(self.remarkSeperateView.frame) + 16, self.orderDetailView.hd_width - 28, 15);
        self.realitySeperateView.frame = CGRectMake(14, CGRectGetMaxY(self.realityPriceLB.frame) + 16, self.orderDetailView.hd_width - 28, 1);
        self.payBtn.frame = CGRectMake(self.orderDetailView.hd_width - 94 - 14, CGRectGetMaxY(self.realitySeperateView.frame) +16, 94, 36);
        self.orderDetailView.hd_height = CGRectGetMaxY(self.payBtn.frame) + 20;
        self.scrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(self.orderDetailView.frame) + 20);
    });
}

- (NSMutableAttributedString *)getRealPrice:(NSString *)price
{
    NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc]initWithString:price];
    NSDictionary * attribute = @{NSFontAttributeName:kMainFont,NSForegroundColorAttributeName:UIColorFromRGB(0xff4f00)};
    [mStr addAttributes:attribute range:NSMakeRange(3, price.length - 3)];
    return mStr;
}

- (void)payAction
{
    NSDictionary * payInfo = @{kCommand:kPayOrderFromOrderList,
                               kOrderId:[self.infoDic objectForKey:kOrderId]};
    [[UserManager sharedManager] payOrderWith:payInfo withNotifiedObject:self];
}

#pragma mark - payOrderDelegate
- (void)didRequestPayOrderSuccessed
{
    [SVProgressHUD dismiss];
    
    int payType = [[self.infoDic objectForKey:@"payType"] intValue];
    
    switch (payType) {
        case 1:
            [self weichatPay];
            break;
        case 2:
            [self aliPay];
            break;
        default:
            break;
    }
}

- (void)didRequestPayOrderFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)weichatPay
{
    NSDictionary * dict = [[UserManager sharedManager] getPayOrderDetailInfo];
    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
    
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = [dict objectForKey:@"appid"];
    req.partnerId           = [dict objectForKey:@"partnerid"];
    req.prepayId            = [dict objectForKey:@"prepayid"];
    req.nonceStr            = [dict objectForKey:@"noncestr"];
    req.timeStamp           = stamp.intValue;
    req.package             = [dict objectForKey:@"packageValue"];
    req.sign                = [dict objectForKey:@"sign"];
    [WXApi sendReq:req];
}

- (void)aliPay
{
    NSDictionary * dict = [[UserManager sharedManager] getPayOrderDetailInfo];
    NSString * orderString = [dict objectForKey:@"orderString"];
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"2018011601908402" callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
    }];
}

- (NSMutableAttributedString *)getRealityPrice:(NSString *)priceStr
{
    NSString * str = [NSString stringWithFormat:@"实付:￥%@", priceStr];
    NSMutableAttributedString * mPriceStr = [[NSMutableAttributedString alloc]initWithString:str];
    [mPriceStr setAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xff4f00)} range:NSMakeRange(3, priceStr.length + 1)];
    return mPriceStr;
}

@end
