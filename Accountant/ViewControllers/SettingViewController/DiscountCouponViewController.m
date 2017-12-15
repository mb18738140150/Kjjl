//
//  DiscountCouponViewController.m
//  Accountant
//
//  Created by aaa on 2017/12/4.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DiscountCouponViewController.h"
#import "HYSegmentedControl.h"
#import "DiscountCouponDetailViewController.h"

#import "DiscountCouponTableViewCell.h"
#define kDiscountCouponCellID @"discountCouponCellID"


@interface DiscountCouponViewController ()<UITableViewDelegate, UITableViewDataSource,HYSegmentedControlDelegate>

@property (nonatomic, strong)HYSegmentedControl * segmentC;
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataSourseArry;

@property (nonatomic, strong)NSIndexPath *indexPath;

@end

@implementation DiscountCouponViewController

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
    
    self.navigationItem.title = @"优惠券";
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
    self.segmentC = [[HYSegmentedControl alloc] initWithOriginY:0 Titles:@[@"全部",@"未使用",@"已使用",@"已过期"] delegate:self drop:NO] ;
    [self.segmentC resetColor:UIColorFromRGB(0xff4e00)];
    [self.segmentC hideBottomLine];
    CGFloat tableView_y = 0;
    if (self.myDscountCoupon) {
        [self.view addSubview:self.segmentC];
        tableView_y = self.segmentC.hd_height;
    }
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, tableView_y, kScreenWidth, kScreenHeight - self.navigationController.navigationBar.hd_height - kStatusBarHeight) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xedf0f0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscountCouponTableViewCell" bundle:nil] forCellReuseIdentifier:kDiscountCouponCellID];
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    
    DiscountCouponTableViewCell * lCell = [tableView dequeueReusableCellWithIdentifier:kDiscountCouponCellID forIndexPath:indexPath];
    if (self.myDscountCoupon) {
        lCell.useState = DiscountCouponUserState_normal;
    }
    switch (self.segmentC.selectIndex) {
        case 0:
            lCell.useState = DiscountCouponUserState_normal;
            break;
        case 1:
            lCell.useState = DiscountCouponUserState_normal;
            break;
        case 2:
            lCell.useState = DiscountCouponUserState_haveUseed;
            break;
        case 3:
            lCell.useState = DiscountCouponUserState_expire;
            break;
            
        default:
            break;
    }
    
    [lCell resetWithInfo:@{}];
    lCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.indexPath == indexPath) {
        lCell.selectImageView.hidden = NO;
    }else
    {
        lCell.selectImageView.hidden = YES;
    }
    
    return lCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.myDscountCoupon) {
        DiscountCouponDetailViewController * detailVc = [[DiscountCouponDetailViewController alloc]init];
        [detailVc refreshUIWith:@{}];
        [self.navigationController pushViewController:detailVc animated:YES];
        return;
    }
    
    self.indexPath = indexPath;
    
    if (self.selectDiscountCouponBlock) {
        self.selectDiscountCouponBlock(@{});
    }
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.myDscountCoupon) {
        if (section == 0) {
            return 10;
        }
        return 0;
    }
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    headView.backgroundColor = UIColorFromRGB(0xedf0f0);
    
    if (self.myDscountCoupon) {
        if (section == 0) {
            headView.hd_height = 10;
            return headView;
        }
    }
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(10, headView.hd_height / 2, headView.hd_width - 20, 1)];
    lineView.backgroundColor = UIColorFromRGB(0x999999);
    [headView addSubview:lineView];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(headView.hd_centerX - 100, 12, 200, 16)];
    titleLabel.backgroundColor = UIColorFromRGB(0xedf0f0);
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textAlignment = 1;
    titleLabel.text = [NSString stringWithFormat:@"可使用的优惠券(%ld张)", self.dataSourseArry.count];
    CGFloat width = [UIUtility getWidthWithText:titleLabel.text font:[UIFont systemFontOfSize:12] height:16];
    titleLabel.frame = CGRectMake(headView.hd_centerX - (width + 20) / 2, 12, width + 20, 16);
    [headView addSubview:titleLabel];
    
    return headView;
}

- (void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
