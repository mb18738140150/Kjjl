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

@interface MyLivingCourseViewController ()<UITableViewDelegate, UITableViewDataSource,CourseModule_LivingSectionDetail,HYSegmentedControlDelegate,UserModule_CancelOrderLivingCourseProtocol>

@property (nonatomic, strong)HYSegmentedControl * segmentC;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSourseArry;

@property (nonatomic, strong)NSDictionary * selectOrderLivingSectionInfoDic;

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
    [self loadData];
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

- (void)loadData
{
    NSDictionary * dic = @{kCourseID:@(0),
                           kteacherId:@"",
                           @"month":@([NSString getCurrentMonth])};
    [[CourseraManager sharedManager] didrequestLivingSectionDetailWithInfo:dic andNotifiedObject:self];
    
    [SVProgressHUD show];
}

- (void)tableViewSetup
{
    self.segmentC = [[HYSegmentedControl alloc] initWithOriginY:0 Titles:@[@"学习中",@"预约"] delegate:self drop:NO] ;
    [self.view addSubview:self.segmentC];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentC.frame), kScreenWidth, kScreenHeight - self.navigationController.navigationBar.hd_height - self.segmentC.hd_height - kStatusBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorFromRGB(0xedf0f0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
#warning **** no operation action countDown
        };
        
        lCell.cancelOrderLivingCourseBlock = ^{
            
            weakSelf.selectOrderLivingSectionInfoDic = infoDic;
            
            NSDictionary * orderDic = @{@"courseID":[infoDic objectForKey:kCourseID],
                                        @"courseSecondID":[infoDic objectForKey:kCourseSecondID],
                                        @"livingTime":[[[infoDic objectForKey:kLivingTime] componentsSeparatedByString:@"~"] objectAtIndex:0]};
            [[UserManager sharedManager] didRequestCancelOrderLivingCourseOperationWithCourseInfo:orderDic withNotifiedObject:weakSelf];
            
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
    }
}

#pragma mark - HYSegmentedControlDelegate

- (void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
    if (index == 1) {
        self.dataSourseArry = [[[CourseraManager sharedManager] getLivingOrderedSectionDetailArray] mutableCopy];
        [self.tableView reloadData];
    }else
    {
        
    }
}

#pragma mark - LivingSectionDetailProtocal

- (void)didRequestLivingSectionDetailSuccessed
{
    [SVProgressHUD dismiss];
    
    if (self.segmentC.selectIndex == 1) {
        if(self.selectOrderLivingSectionInfoDic )
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLivingChatClick object:self.selectOrderLivingSectionInfoDic];
            self.selectOrderLivingSectionInfoDic = nil;
        }else
        {
            self.dataSourseArry = [[[CourseraManager sharedManager] getLivingOrderedSectionDetailArray] mutableCopy];
            [self.tableView reloadData];
        }
    }
    
}

- (void)didRequestLivingSectionDetailFailed:(NSString *)failedInfo
{
    if ([failedInfo isEqualToString:@"暂无数据"]) {
        failedInfo = @"暂无课程";
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
