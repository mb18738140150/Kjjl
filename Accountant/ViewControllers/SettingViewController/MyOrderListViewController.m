//
//  MyOrderListViewController.m
//  Accountant
//
//  Created by aaa on 2017/12/4.
//  Copyright © 2017年 :. All rights reserved.
//

#import "MyOrderListViewController.h"
#import "HYSegmentedControl.h"

#import "OrderDetailViewController.h"
#import "BuyDetailViewController.h"
#import "MyOrderTableViewCell.h"
#define kMyOrderCellID @"MyOrderCellID"

@interface MyOrderListViewController ()<HYSegmentedControlDelegate,UITableViewDelegate,UITableViewDataSource,UserModule_OrderListProtocol,UserModule_PayOrderProtocol>
@property (nonatomic, strong)HYSegmentedControl * segmentC;
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataSourseArry;
@property (nonatomic, strong)NSDictionary * payInfoDic;

@end

@implementation MyOrderListViewController

- (NSMutableArray *)dataSourseArry
{
    if (!_dataSourseArry) {
        _dataSourseArry = [NSMutableArray array];
    }
    return _dataSourseArry;
}

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
    
    self.navigationItem.title = @"我的订单";
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
    [SVProgressHUD show];
    [[UserManager sharedManager] didRequestOrderListWithCourseInfo:@{} withNotifiedObject:self];
}

- (void)tableViewSetup
{
    self.segmentC = [[HYSegmentedControl alloc] initWithOriginY:0 Titles:@[@"全部",@"待付款",@"已付款"] delegate:self drop:NO] ;
    [self.view addSubview:self.segmentC];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentC.frame), kScreenWidth, kScreenHeight - self.navigationController.navigationBar.hd_height - self.segmentC.hd_height - kStatusBarHeight) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyOrderTableViewCell" bundle:nil] forCellReuseIdentifier:kMyOrderCellID];
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourseArry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    
    MyOrderTableViewCell * lCell = [tableView dequeueReusableCellWithIdentifier:kMyOrderCellID forIndexPath:indexPath];
    NSDictionary * infoDic = self.dataSourseArry[indexPath.row];
    [lCell resetWithInfo:infoDic];
    lCell.selectionStyle = UITableViewCellSelectionStyleNone;
    lCell.payOrderBlock = ^(NSDictionary *infoDIc) {
        [weakSelf pay:infoDIc];
    };
    return lCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 175;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailViewController * orderDetailVC = [[OrderDetailViewController alloc]init];
//    orderDetailVC.orderId = @"";
    orderDetailVC.infoDic = self.dataSourseArry[indexPath.row];
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]initWithDictionary:[self.dataSourseArry objectAtIndex:indexPath.row]];
    [infoDic setObject:[infoDic objectForKey:kOrderId] forKey:kOrderId];
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}
   
#pragma mark - HYSegmentedControlDelegate

- (void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
    self.dataSourseArry = [[[[UserManager sharedManager] getMyOrderList] objectAtIndex:index] mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - OrderListProtocal
- (void)didRequestOrderListSuccessed
{
    [SVProgressHUD dismiss];
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    
    self.dataSourseArry = [[[[UserManager sharedManager] getMyOrderList] objectAtIndex:self.segmentC.selectIndex] mutableCopy];
    [self.tableView reloadData];
}

- (void)didRequestOrderListFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)pay:(NSDictionary *)infoDic
{
    self.payInfoDic = infoDic;
    NSDictionary * payInfo = @{kCommand:kPayOrderFromOrderList,
                               kOrderId:[infoDic objectForKey:kOrderId]};
    [[UserManager sharedManager] payOrderWith:payInfo withNotifiedObject:self];
}

#pragma mark - payOrderDelegate
- (void)didRequestPayOrderSuccessed
{
    [SVProgressHUD dismiss];
    
    int payType = [[self.payInfoDic objectForKey:@"payType"] intValue];
    
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

@end
