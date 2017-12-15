//
//  MyOrderListViewController.m
//  Accountant
//
//  Created by aaa on 2017/12/4.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "MyOrderListViewController.h"
#import "HYSegmentedControl.h"

#import "OrderDetailViewController.h"

#import "MyOrderTableViewCell.h"
#define kMyOrderCellID @"MyOrderCellID"

@interface MyOrderListViewController ()<HYSegmentedControlDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)HYSegmentedControl * segmentC;
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataSourseArry;


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
    
}

- (void)tableViewSetup
{
    self.segmentC = [[HYSegmentedControl alloc] initWithOriginY:0 Titles:@[@"全部",@"待付款",@"已付款"] delegate:self drop:NO] ;
    [self.view addSubview:self.segmentC];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentC.frame), kScreenWidth, kScreenHeight - self.navigationController.navigationBar.hd_height - self.segmentC.hd_height - kStatusBarHeight) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyOrderTableViewCell" bundle:nil] forCellReuseIdentifier:kMyOrderCellID];
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    
    MyOrderTableViewCell * lCell = [tableView dequeueReusableCellWithIdentifier:kMyOrderCellID forIndexPath:indexPath];
    [lCell resetWithInfo:@{}];
    lCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return lCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 175;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailViewController * orderDetailVC = [[OrderDetailViewController alloc]init];
    orderDetailVC.orderId = @"";
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

#pragma mark - HYSegmentedControlDelegate

- (void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
    if (index == 1) {
        self.dataSourseArry = [[[[UserManager sharedManager] getMyOrderList] objectAtIndex:1] mutableCopy];
        [self.tableView reloadData];
    }else if (index == 0)
    {
        self.dataSourseArry = [[[[UserManager sharedManager] getMyOrderList] objectAtIndex:0] mutableCopy];
        [self.tableView reloadData];
    }else
    {
        self.dataSourseArry = [[[[UserManager sharedManager] getMyOrderList] objectAtIndex:2] mutableCopy];
        [self.tableView reloadData];
    }
}


@end
