//
//  BuyDetailViewController.m
//  Accountant
//
//  Created by aaa on 2017/11/21.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "BuyDetailViewController.h"
#import "PayDetailTableViewCell.h"
#import "WXApi.h"
#import "DredgeMemberSelectDCTableViewCell.h"
#import "DiscountCouponViewController.h"

@interface BuyDetailViewController ()<UITableViewDelegate, UITableViewDataSource,UserModule_PayOrderProtocol>

@property (nonatomic, strong)NSMutableArray *payTypeArray;
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)UIButton *payBtn;
@property (nonatomic, strong)NSDictionary * discountCouponIinfo;
@property (nonatomic, assign)PayType payType;

@end

@implementation BuyDetailViewController

- (NSMutableArray *)payTypeArray
{
    if (!_payTypeArray) {
        _payTypeArray = [NSMutableArray array];
    }
    return _payTypeArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.payType = PayType_weichat;
    [self navigationViewSetup];
    [self loadPayInfo];
    [self prepareUI];
    
}

- (void)navigationViewSetup
{
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, kScreenWidth, 64)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"购买详情";
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

- (void)loadPayInfo
{
    NSDictionary * weichatInfoDic = @{@"imageName":@"icon_wxzf",@"title":@"微信支付",@"payType":@(PayType_weichat)};
    NSDictionary * aliPayInfoDic = @{@"imageName":@"icon_zfb",@"title":@"支付宝支付",@"payType":@(PayType_alipay)};
    [self.payTypeArray addObject:weichatInfoDic];
    [self.payTypeArray addObject:aliPayInfoDic];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFinish) name:@"weichatPay" object:nil];
}

- (void)payFinish
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareUI
{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 150) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[PayDetailTableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.tableview registerClass:[DredgeMemberSelectDCTableViewCell class] forCellReuseIdentifier:@"DredgeMemberSelectDCTableViewCellID"];
    [self.view addSubview:self.tableview];
    
    self.payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.payBtn.frame = CGRectMake(20, CGRectGetMaxY(self.tableview.frame) + 20, kScreenWidth - 40, 40);
    [self.payBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [self.payBtn setTitleColor:kMainTextColor forState:UIControlStateNormal];
    self.payBtn.titleLabel.font = kMainFont;
    self.payBtn.layer.cornerRadius = 4;
    self.payBtn.layer.masksToBounds = YES;
    [self.payBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.payBtn];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        return self.payTypeArray.count + 1;
    }
    return self.payTypeArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.payTypeArray.count) {
        DredgeMemberSelectDCTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DredgeMemberSelectDCTableViewCellID" forIndexPath:indexPath];
        [cell resetCell:self.discountCouponIinfo];
        return cell;
    }
    
    PayDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    
    if (self.payType == [[self.payTypeArray[indexPath.row] objectForKey:@"payType"] integerValue]) {
        cell.isSelect = YES;
    }else
    {
        cell.isSelect = NO;
    }
    
    [cell resetUIWith:self.payTypeArray[indexPath.row]];
    
    __weak typeof(self)weakSelf = self;
    cell.payBlock = ^(PayType payType) {
        if (payType != weakSelf.payType) {
            weakSelf.payType = payType;
            [weakSelf.tableview reloadData];
        }
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if (indexPath.row == self.payTypeArray.count) {
        DiscountCouponViewController * vc = [[DiscountCouponViewController alloc]init];
        vc.myDscountCoupon = NO;
        vc.price = [[self.infoDic objectForKey:kPrice] doubleValue];
        vc.selectDiscountCouponBlock = ^(NSDictionary *infoDic) {
            weakSelf.discountCouponIinfo = infoDic;
            [weakSelf.tableview reloadData];
            
        };
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    NSDictionary *infoDic = [self.payTypeArray objectAtIndex:indexPath.row];
    if ([[infoDic objectForKey:@"payType"] integerValue] != self.payType) {
        self.payType = [[infoDic objectForKey:@"payType"] integerValue];
        [self.tableview reloadData];
    }
}

- (void)payAction
{
    NSString * orderId = @"";
    if (self.payCourseType == PayCourseType_Course) {
        orderId = [self.infoDic objectForKey:kCourseID];
    }else if (self.payCourseType == PayCourseType_LivingCourse)
    {
        orderId = [self.infoDic objectForKey:kCourseID];
    }
    else
    {
        orderId = [self.infoDic objectForKey:kMemberLevelId];
    }
    
    NSString * disCOuntCouponId = @"";
    if ([self.discountCouponIinfo objectForKey:@"CouponId"]) {
        disCOuntCouponId = [self.discountCouponIinfo objectForKey:@"CouponId"];
    }
    
    NSNumber *payType = @1;
    if (self.payType == PayType_weichat) {
    }
    else
    {
        payType = @2;
    }
    NSDictionary * infoDic = @{@"courseId":orderId,
                               @"payType":payType,
                               @"courseType":@(self.payCourseType),
                               @"discountCouponId":disCOuntCouponId};
    [[UserManager sharedManager] payOrderWith:infoDic withNotifiedObject:self];
    [SVProgressHUD show];
}

#pragma mark - payOrderDelegate
- (void)didRequestPayOrderSuccessed
{
    [SVProgressHUD dismiss];
    switch (self.payType) {
        case PayType_weichat:
            [self weichatPay];
            break;
        case PayType_alipay:
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

@end
