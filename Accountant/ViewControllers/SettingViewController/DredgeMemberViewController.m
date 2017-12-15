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

#import "PayView.h"

@interface DredgeMemberViewController ()<UITableViewDelegate,UITableViewDataSource>

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
    
    self.payType = PayType_alipay;
    [self navigationViewSetup];
    [self loadPayInfo];
    [self prepareUI];
    
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
    
    self.payView = [[PayView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableview.frame), kScreenWidth, 50)];
    [self.view addSubview:self.payView];
    
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
        return 2;
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
        cell.memberLevel = [self.selectMemberLevelInfo objectForKey:@"memberLevel"];
        [cell resetCell];
        
        cell.lookMemberDetailBlock = ^{
            NSLog(@"查看会员等级详情");
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
        vc.selectDiscountCouponBlock = ^(NSDictionary *infoDic) {
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
    if ([self.selectMemberLevelInfo objectForKey:@"realityPrice"]) {
        levelPrice = [[self.selectMemberLevelInfo objectForKey:@"realityPrice"] doubleValue];
    }else
    {
        levelPrice = 0;
    }
    if ([self.discountCouponIinfo objectForKey:@"discount"]) {
        discount = [[self.discountCouponIinfo objectForKey:@"discount"] doubleValue];
    }else
    {
        discount = 0;
    }
    
    self.payView.price = [NSString stringWithFormat:@"%.0f", levelPrice - discount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
