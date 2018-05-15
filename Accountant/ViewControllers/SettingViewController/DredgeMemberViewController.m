//
//  DredgeMemberViewController.m
//  Accountant
//
//  Created by aaa on 2017/12/4.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DredgeMemberViewController.h"
#import "DiscountCouponViewController.h"

#import "DredgememberTableViewCell.h"
#import "DredgeMemberSelectDCTableViewCell.h"
#import "DredgeMemberPriceselectTableViewCell.h"
#import "PayDetailTableViewCell.h"
#import "MemberIntroduceTableViewCell.h"
#import "BuyDetailViewController.h"
#import "MemberDetailViewController.h"
#import "PayView.h"
#import "WXApi.h"

@interface DredgeMemberViewController ()<UITableViewDelegate,UITableViewDataSource,UserModule_PayOrderProtocol>

@property (nonatomic, strong)PayView * payView;
@property (nonatomic, strong)UITableView * tableview;
@property (nonatomic, strong)NSMutableArray *payTypeArray;

@property (nonatomic, assign)PayType payType;

@property (nonatomic, strong)NSDictionary * selectMemberLevelInfo;// 会员级别
@property (nonatomic, strong)NSDictionary * discountCouponIinfo;// 优惠券

@end

@implementation DredgeMemberViewController

- (NSMutableArray *)payTypeArray
{
    if (!_payTypeArray) {
        _payTypeArray = [NSMutableArray array];
    }
    return _payTypeArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.payType = PayType_weichat;
    [self navigationViewSetup];
    [self loadPayInfo];
    [self prepareUI];
    [self initPayView];
}

- (void)navigationViewSetup
{
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, kScreenWidth, 64)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"开通会员";
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
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - 50) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerClass:[PayDetailTableViewCell class] forCellReuseIdentifier:@"payEellID"];
    [self.tableview registerClass:[DredgememberTableViewCell class] forCellReuseIdentifier:@"DredgememberTableViewCellID"];
    [self.tableview registerClass:[DredgeMemberSelectDCTableViewCell class] forCellReuseIdentifier:@"DredgeMemberSelectDCTableViewCellID"];
    [self.tableview registerClass:[DredgeMemberPriceselectTableViewCell class] forCellReuseIdentifier:@"DredgeMemberPriceselectTableViewCellID"];
    [self.tableview registerClass:[MemberIntroduceTableViewCell class] forCellReuseIdentifier:@"MemberIntroduceTableViewCellID"];
    
    [self.view addSubview:self.tableview];
    __weak typeof(self)weakSelf = self;
    self.payView = [[PayView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableview.frame), kScreenWidth, 50)];
    [self.view addSubview:self.payView];
    self.payView.payBlock = ^{
        [weakSelf payAction];
    };
    
    self.selectMemberLevelInfo = @{kMemberLevel:[[UserManager sharedManager]getLevelStr]};
    
}

- (void)payAction
{
    NSString * orderId = @"";
    if ([self.selectMemberLevelInfo objectForKey:kMemberLevelId]) {
        orderId = [self.selectMemberLevelInfo objectForKey:kMemberLevelId];
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
                               @"courseType":@(PayCourseType_Member),
                               @"discountCouponId":disCOuntCouponId};
    [[UserManager sharedManager] payOrderWith:infoDic withNotifiedObject:self];
    [SVProgressHUD show];
}


- (void)loadPayInfo
{
    NSDictionary * weichatInfoDic = @{@"imageName":@"icon_wxzf",@"title":@"微信支付",@"payType":@(PayType_weichat)};
    NSDictionary * aliPayInfoDic = @{@"imageName":@"icon_zfb",@"title":@"支付宝支付",@"payType":@(PayType_alipay)};
    [self.payTypeArray addObject:aliPayInfoDic];
    [self.payTypeArray addObject:weichatInfoDic];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3) {
        return self.payTypeArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)wealSelf = self;
    
    if (indexPath.section == 0) {
        DredgememberTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DredgememberTableViewCellID" forIndexPath:indexPath];
        [cell resetCell:[[UserManager sharedManager] getUserInfos]];
        return cell;
    }
    if(indexPath.section == 1 )
    {
        DredgeMemberPriceselectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DredgeMemberPriceselectTableViewCellID" forIndexPath:indexPath];
        cell.memberLevel = [self.selectMemberLevelInfo objectForKey:kMemberLevel];
        [cell resetCell];
        
        cell.lookMemberDetailBlock = ^{
            NSLog(@"查看会员等级详情");
            [wealSelf pushMemberDetailVC];
        };
        cell.memberlevelSelectBlock = ^(NSDictionary *infoDic) {
            NSLog(@"选择会员级别 %@", infoDic);
            wealSelf.selectMemberLevelInfo = infoDic;
            [wealSelf refreshPayView];
        };
        
        return cell;
    }
    
    if (indexPath.section == 2) {
        DredgeMemberSelectDCTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DredgeMemberSelectDCTableViewCellID" forIndexPath:indexPath];
        [cell resetCell:self.discountCouponIinfo];
        return cell;
    }
    
    if (indexPath.section == 3) {
        PayDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"payEellID" forIndexPath:indexPath];
        
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
    
    if (indexPath.section == 4) {
        MemberIntroduceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MemberIntroduceTableViewCellID" forIndexPath:indexPath];
        cell.noPayBtn = YES;
        [cell resetCell];
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if (indexPath.section == 3) {
        NSDictionary *infoDic = [self.payTypeArray objectAtIndex:indexPath.row];
        if ([[infoDic objectForKey:@"payType"] integerValue] != self.payType) {
            self.payType = [[infoDic objectForKey:@"payType"] integerValue];
            [self.tableview reloadData];
        }
    }else if (indexPath.section == 2)
    {
        DiscountCouponViewController * vc = [[DiscountCouponViewController alloc]init];
        vc.myDscountCoupon = NO;
        if ([self.selectMemberLevelInfo objectForKey:kPrice]) {
            vc.price = [[self.selectMemberLevelInfo objectForKey:kPrice] doubleValue];
        }else
        {
            vc.price = 0;
        }
        vc.selectDiscountCouponBlock = ^(NSDictionary *infoDic) {
            weakSelf.discountCouponIinfo = infoDic;
            [weakSelf.tableview reloadData];
            [weakSelf refreshPayView];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    switch (indexPath.section) {
        case 0:
            height = 71;
            break;
        case 1:
            height = 330;
            break;
        case 2:
            height = 48;
            break;
        case 3:
            height = 52;
            break;
        case 4:
            height = 280;
            break;
            
        default:
            break;
    }
    
    return height;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4) {
        return 8;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 8)];
    view.backgroundColor = UIColorFromRGB(0xedf0f0);
    if (section == 0) {
        return nil;
    }
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 8)];
    view.backgroundColor = UIColorFromRGB(0xedf0f0);
    return view;
}

#pragma park - refreshPayView
- (void)refreshPayView
{
    CGFloat levelPrice,discount;
    if ([self.selectMemberLevelInfo objectForKey:kPrice]) {
        levelPrice = [[self.selectMemberLevelInfo objectForKey:kPrice] doubleValue];
    }else
    {
        levelPrice = 0;
    }
    // 判断是否有优惠券
    if ([self.discountCouponIinfo objectForKey:kPrice]) {
        discount = [[self.discountCouponIinfo objectForKey:kPrice] doubleValue];
    }else
    {
        discount = 0;
    }
    
    self.payView.price = [NSString stringWithFormat:@"%.0f", levelPrice - discount];
}

- (void)initPayView
{
    NSArray * array = [[[UserManager sharedManager] getLevelDetailList] mutableCopy];
    NSString * memberLevel = [self.selectMemberLevelInfo objectForKey:kMemberLevel];
    
    for (int i = 0; i < array.count; i++) {
        
        if ([[array[i] objectForKey:kMemberLevel] isEqualToString:memberLevel]) {
            self.selectMemberLevelInfo = array[i];
            [self refreshPayView];
            break;
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pushMemberDetailVC
{
    MemberDetailViewController * vc = [[MemberDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
    
    // 测试签名
//    NSString * signStr = [self createMD5SingForPayWithAppID:req.openID partnerid:req.partnerId prepayid:req.prepayId package:req.package noncestr:req.nonceStr timestamp:req.timeStamp];
//    if ([signStr isEqualToString:[req.sign MD5]]) {
//        NSLog(@"签名正确: ***   %@\n%@",signStr,  req.sign);
//    }else
//    {
//        NSLog(@"签名错误:  ***  %@\n%@",signStr,  req.sign);
//    }
    
    if ([WXApi sendReq:req]) {
        NSLog(@"调起微信支付成功");
    }else
    {
        NSLog(@"调起微信支付失败");
    }
    
}

- (void)aliPay
{
    NSDictionary * dict = [[UserManager sharedManager] getPayOrderDetailInfo];
    NSString * orderString = [dict objectForKey:@"orderString"];
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"2018011601908402" callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
    }];
}

-(NSString *)createMD5SingForPayWithAppID:(NSString *)appid_key partnerid:(NSString *)partnerid_key prepayid:(NSString *)prepayid_key package:(NSString *)package_key noncestr:(NSString *)noncestr_key timestamp:(UInt32)timestamp_key{
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject:appid_key forKey:@"appid"];//微信appid 例如wxfb132134e5342
    [signParams setObject:noncestr_key forKey:@"noncestr"];//随机字符串
    [signParams setObject:package_key forKey:@"package"];//扩展字段  参数为 Sign=WXPay
    [signParams setObject:partnerid_key forKey:@"partnerid"];//商户账号
    [signParams setObject:prepayid_key forKey:@"prepayid"];//此处为统一下单接口返回的预支付订单号
    [signParams setObject:[NSString stringWithFormat:@"%u",timestamp_key] forKey:@"timestamp"];//时间戳
    
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [signParams allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[signParams objectForKey:categoryId] isEqualToString:@""]
            && ![[signParams objectForKey:categoryId] isEqualToString:@"sign"]
            && ![[signParams objectForKey:categoryId] isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [signParams objectForKey:categoryId]];
        }
    }
    //添加商户密钥key字段  API 密钥
    [contentString appendFormat:@"key=%@", @"6ef7237c1c320f9faac8331175686b7d"];
    NSString *result = [contentString MD5];//md5加密
    return result;
}



@end
