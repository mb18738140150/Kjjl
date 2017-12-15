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

@interface BuyDetailViewController ()<UITableViewDelegate, UITableViewDataSource,UserModule_PayOrderProtocol>

@property (nonatomic, strong)NSMutableArray *payTypeArray;
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)UIButton *payBtn;

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

- (void)prepareUI
{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[PayDetailTableViewCell class] forCellReuseIdentifier:@"cellID"];
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
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    NSDictionary *infoDic = [self.payTypeArray objectAtIndex:indexPath.row];
    if ([[infoDic objectForKey:@"payType"] integerValue] != self.payType) {
        self.payType = [[infoDic objectForKey:@"payType"] integerValue];
        [self.tableview reloadData];
    }
}

- (void)payAction
{
    if (self.payType == PayType_weichat) {
        NSLog(@"微信支付");
        
        [[UserManager sharedManager] payOrderWith:@{@"orderId":[self.infoDic objectForKey:kCourseID],@"payType":@(0)} withNotifiedObject:self];
        
    }
    else
    {
        NSLog(@"支付宝支付");
        
        [[UserManager sharedManager] payOrderWith:@{@"orderId":[self.infoDic objectForKey:kCourseID],@"payType":@(1)} withNotifiedObject:self];
    }
}

#pragma mark - payOrderDelegate
- (void)didRequestPayOrderSuccessed
{
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
    
}

- (void)weichatPay
{
    NSDictionary * dict = [[UserManager sharedManager] getPayOrderDetailInfo];
    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
    
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = [dict objectForKey:@"partnerid"];
    req.prepayId            = [dict objectForKey:@"prepayid"];
    req.nonceStr            = [dict objectForKey:@"noncestr"];
    req.timeStamp           = stamp.intValue;
    req.package             = [dict objectForKey:@"package"];
    req.sign                = [dict objectForKey:@"sign"];
    [WXApi sendReq:req];
    
}

- (void)aliPay
{
    
}

@end
