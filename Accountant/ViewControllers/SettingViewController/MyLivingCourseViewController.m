//
//  MyLivingCourseViewController.m
//  Accountant
//
//  Created by aaa on 2017/11/30.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "MyLivingCourseViewController.h"
#import "HYSegmentedControl.h"
#import "CourseraManager.h"
#import "MainLivingCourseTableViewCell.h"

@interface MyLivingCourseViewController ()<UITableViewDelegate, UITableViewDataSource,CourseModule_LivingSectionDetail,HYSegmentedControlDelegate,UserModule_CancelOrderLivingCourseProtocol,CourseModule_MyLivingCourse,CourseModule_LivingSectionDetail>

@property (nonatomic, strong)HYSegmentedControl * segmentC;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSourseArry;

@property (nonatomic, strong)NSDictionary * selectOrderLivingSectionInfoDic;
@property (nonatomic, strong)NSDictionary * selectLivingCourseInfoDic;

@end

@implementation MyLivingCourseViewController

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
    [self loadOrderedLivingCourse];
    [self tableViewSetup];
    
}

- (void)navigationViewSetup
{
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, kScreenWidth, 64)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"直播";
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

- (void)refreshData
{
    if (self.segmentC.selectIndex == 1) {
        [self loadOrderedLivingCourse];
    }else
    {
        [self loadData];
    }
}

- (void)loadData
{
    [[CourseraManager sharedManager] didRequestMyLivingCourseWithInfo:@{} NotifiedObject:self];
    
    [SVProgressHUD show];
}

- (void)loadOrderedLivingCourse
{
    [SVProgressHUD show];
    NSDictionary * dic = @{kCourseID:@(0),
                           kteacherId:@"",
                           @"month":@([NSString getCurrentMonth])};
    [[CourseraManager sharedManager] didrequestLivingSectionDetailWithInfo:dic andNotifiedObject:self];
}

- (void)tableViewSetup
{
    self.segmentC = [[HYSegmentedControl alloc] initWithOriginY:0 Titles:@[@"学习中",@"预约"] delegate:self drop:NO] ;
    self.segmentC.selectIndex = 1;
//    [self.view addSubview:self.segmentC];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - self.navigationController.navigationBar.hd_height - kStatusBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorFromRGB(0xedf0f0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    [self.tableView registerClass:[MainLivingCourseTableViewCell class] forCellReuseIdentifier:@"mainCellId"];
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourseArry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if (self.segmentC.selectIndex == 1) {
        MainLivingCourseTableViewCell * lCell = (MainLivingCourseTableViewCell *)[self getCellWithCellName:@"mainCellId" inTableView:tableView andCellClass:[MainLivingCourseTableViewCell class]];
        lCell.livingCellType = LivingCellType_Order;
        NSDictionary * infoDic = [[[CourseraManager sharedManager]getLivingOrderedSectionDetailArray] objectAtIndex:indexPath.row];
        
        [lCell resetCellContent: infoDic];
        lCell.mainCountDownFinishBlock = ^{
            [weakSelf loadOrderedLivingCourse];
        };
        
        lCell.cancelOrderLivingCourseBlock = ^{
            
            weakSelf.selectOrderLivingSectionInfoDic = infoDic;
            
            NSDictionary * orderDic = @{@"courseID":[infoDic objectForKey:kCourseID],
                                        @"courseSecondID":[infoDic objectForKey:kCourseSecondID],
                                        @"livingTime":[[[infoDic objectForKey:kLivingTime] componentsSeparatedByString:@"~"] objectAtIndex:0]};
            [[UserManager sharedManager] didRequestCancelOrderLivingCourseOperationWithCourseInfo:orderDic withNotifiedObject:weakSelf];
            
        };
        return lCell;
    }else
    {
        static NSString *courseCellName = @"liveCourseCell";
        __weak typeof(self)weakSelf = self;
        MainLivingCourseTableViewCell * lCell = (MainLivingCourseTableViewCell *)[self getCellWithCellName:courseCellName inTableView:tableView andCellClass:[MainLivingCourseTableViewCell class]];
        [lCell resetCellContent:[[[[CourseraManager sharedManager]getNotStartLivingCourseArray] objectAtIndex:0] objectAtIndex:indexPath.row - 1]];
        lCell.mainCountDownFinishBlock = ^{
            [weakSelf loadData];
        };
        return lCell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segmentC.selectIndex == 1) {
        NSDictionary * infoDic = [[[CourseraManager sharedManager]getLivingOrderedSectionDetailArray] objectAtIndex:indexPath.row];
        self.selectOrderLivingSectionInfoDic = infoDic;
        [SVProgressHUD show];
        NSDictionary * dic1 = @{kCourseID:[infoDic objectForKey:kCourseID],
                                kteacherId:@"",
                                @"month":@(0)};
        [[CourseraManager sharedManager] didrequestLivingSectionDetailWithInfo:dic1 andNotifiedObject:self];
    }else
    {
        [SVProgressHUD show];
        NSDictionary *infoDic = [[[CourseraManager sharedManager]getMyLivingCourseArray] objectAtIndex:indexPath.row] ;
        self.selectLivingCourseInfoDic = infoDic;
        NSDictionary * dic = @{kCourseID:[infoDic objectForKey:kCourseID],
                               kteacherId:@"",
                               @"month":@(0)};
        [[CourseraManager sharedManager] didrequestLivingSectionDetailWithInfo:dic andNotifiedObject:self];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kScreenWidth / 4, kScreenWidth / 2, 20)];
    titleLabel.textColor = UIColorFromRGB(0x666666);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.layer.borderColor = UIColorFromRGB(0x40ffe0).CGColor;
    titleLabel.layer.borderWidth = 1;
    titleLabel.layer.cornerRadius = 3;
    
    return footerView;
}

#pragma mark - HYSegmentedControlDelegate
- (void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
    if (index == 1) {
        self.dataSourseArry = [[[CourseraManager sharedManager] getLivingOrderedSectionDetailArray] mutableCopy];
        [self.tableView reloadData];
    }else
    {
        self.dataSourseArry = [[[CourseraManager sharedManager] getMyLivingCourseArray] mutableCopy];
        [self.tableView reloadData];
    }
}

#pragma mark - LivingSectionDetailProtocal

- (void)didRequestLivingSectionDetailSuccessed
{
    [SVProgressHUD dismiss];
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    
    if (self.segmentC.selectIndex == 1) {
        if(self.selectOrderLivingSectionInfoDic )
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLivingChatClick object:self.selectOrderLivingSectionInfoDic];;
            self.selectOrderLivingSectionInfoDic = nil;
        }else
        {
            self.dataSourseArry = [[[CourseraManager sharedManager] getLivingOrderedSectionDetailArray] mutableCopy];
            [self.tableView reloadData];
        }
    }else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLivingChatClick object:self.selectLivingCourseInfoDic];;
        self.selectLivingCourseInfoDic = nil;
    }
    [self.tableView reloadData];
}

- (void)didRequestLivingSectionDetailFailed:(NSString *)failedInfo
{
    if ([failedInfo isEqualToString:@"暂无数据"]) {
        failedInfo = @"暂无课程";
    }
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    [SVProgressHUD dismiss];
    
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestCancelOrderLivingSuccessed
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"取消预约成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    
    [[CourseraManager sharedManager] refreshLivingSectionStateOrder_complateWith:self.selectOrderLivingSectionInfoDic];
    self.dataSourseArry = [[[CourseraManager sharedManager] getLivingOrderedSectionDetailArray] mutableCopy];
    [self.tableView reloadData];
}

- (void)didRequestCancelOrderLivingFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - CourseModule_MyLivingCourse
- (void)didRequestMyLivingCourseSuccessed
{
    [SVProgressHUD dismiss];
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    self.dataSourseArry = [[[CourseraManager sharedManager] getMyLivingCourseArray] mutableCopy];
    [self.tableView reloadData];
}

- (void)didRequestMyLivingCourseFailed:(NSString *)failedInfo
{
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - utility
- (UITableViewCell *)getCellWithCellName:(NSString *)reuseName inTableView:(UITableView *)table andCellClass:(Class)cellClass
{
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:reuseName];
    if (cell == nil) {
        cell = [[cellClass alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

@end
