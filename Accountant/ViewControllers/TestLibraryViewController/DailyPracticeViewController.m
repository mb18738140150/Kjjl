//
//  DailyPracticeViewController.m
//  Accountant
//
//  Created by aaa on 2018/1/20.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "DailyPracticeViewController.h"
#import "HYSegmentedControl.h"
#import "TestChapterQuestionViewController.h"
#import "TestRecordTableViewCell.h"
#define kCellId @"TestRecordTableViewCellId"
#import "DailyPracticeTableViewCell.h"
#define kDailyCellId @"DailyPracticeTableViewCellID"
#define kSegmentHeight 42
@interface DailyPracticeViewController ()<HYSegmentedControlDelegate,UITableViewDelegate, UITableViewDataSource,TestModule_TestDailyPractice,TestModule_TestDailyPracticeQuestion,TestModule_AddHistoryProtocol>

@property (nonatomic, strong)HYSegmentedControl * segmentControl;
@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic, strong)UITableView * dailyTableView;
@property (nonatomic, strong)UITableView * recordTableView;
@property (nonatomic, strong)NSArray * dailyArray;
@property (nonatomic, strong)NSArray * recordArray;
@property (nonatomic, assign)int logId;
@property (nonatomic, strong)NSDictionary * selectInfoDic;

@end

@implementation DailyPracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationViewSetup];
    [self contentViewInit];
    [self startRequest];
}


#pragma mark - ui

- (void)navigationViewSetup
{
    self.navigationItem.title = @"每日一练";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50,NSFontAttributeName:[UIFont systemFontOfSize:17]};
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"public-返回"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
}

- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)contentViewInit
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.segmentControl = [[HYSegmentedControl alloc] initWithOriginY:0 Titles:@[@"今日练习", @"往期记录"] delegate:self];
    [self.view addSubview:self.segmentControl];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kSegmentHeight, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kSegmentHeight)];
    [self.view addSubview:self.scrollView];
    self.scrollView.scrollEnabled = NO;
    
    CGRect simulateTableViewRect = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kSegmentHeight);
    self.recordTableView = [[UITableView alloc] initWithFrame:simulateTableViewRect style:UITableViewStylePlain];
    self.recordTableView.delegate = self;
    self.recordTableView.dataSource = self;
    self.recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.recordTableView registerNib:[UINib nibWithNibName:@"TestRecordTableViewCell" bundle:nil] forCellReuseIdentifier:kCellId];
    self.recordTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self startRequest];
    }];
    
    [self.scrollView addSubview:self.recordTableView];
    
    CGRect tableViewRect = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kSegmentHeight);
    self.dailyTableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    self.dailyTableView.delegate = self;
    self.dailyTableView.dataSource = self;
    self.dailyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.dailyTableView registerNib:[UINib nibWithNibName:@"DailyPracticeTableViewCell" bundle:nil] forCellReuseIdentifier:kDailyCellId];
    self.dailyTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self startRequest];
    }];
    
    [self.scrollView addSubview:self.dailyTableView];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kSegmentHeight - 37);
}

- (void)startRequest
{
    [SVProgressHUD show];
    [[TestManager sharedManager] didRequestTestDailyPracticeWithInfo:@{kTestCategoryId:@(self.courseCategoryId)} andNotifiedObject:self];
}

- (void)addHistory:(NSDictionary *)infoDic
{
    self.selectInfoDic = infoDic;
    NSDictionary *d = @{kLID:@(self.lid),
                        kKID:@(self.courseCategoryId),
                        kTestSimulateId:@([[infoDic objectForKey:@"id"] intValue]),
                        kTestChapterId:@(0),
                        kTestSectionId:@(0),
                        kLogName:@"每日一练"};
    [[TestManager sharedManager] didRequestAddTestHistoryWithInfo:d andNotifiedObject:self];
}

- (void)didRequestAddHistorySuccess
{
    NSDictionary *dic = self.selectInfoDic;
    self.logId = [[TestManager sharedManager] getLogId];
    [self requestDailyPracticeQuestionQuestion:dic];;
}
- (void)didRequestAddHistoryFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)requestDailyPracticeQuestionQuestion:(NSDictionary *)infoDic
{
    [SVProgressHUD show];
    
    NSDictionary * Dic = @{kTestSectionId:@([[infoDic objectForKey:@"id"] intValue]),
                           @"category":@(3)};
    
    [[TestManager sharedManager] didRequestTestDailyPracticeQoestionWithInfo:Dic andNotifiedObject:self];
}

#pragma mark - dailyPracticeDelagate
- (void)didRequestTestDailyPracticeSuccess
{
    [SVProgressHUD dismiss];
    [self.dailyTableView.mj_header endRefreshing];
    [self.recordTableView.mj_header endRefreshing];
    self.dailyArray = [[[TestManager sharedManager] getTestDailyPractice] objectAtIndex:0];
    self.recordArray = [[[TestManager sharedManager] getTestDailyPractice] objectAtIndex:1];
    [self.dailyTableView reloadData];
    [self.recordTableView reloadData];
}

- (void)didRequestTestDailyPracticeFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.dailyTableView.mj_header endRefreshing];
    [self.recordTableView.mj_header endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestTestDailyPracticeQuestionSuccess
{
    [SVProgressHUD dismiss];
    TestChapterQuestionViewController *vc = [[TestChapterQuestionViewController alloc] init];
    vc.questionType = TestQuestionTypeDailyPractice;
    vc.hidesBottomBarWhenPushed = YES;
    vc.logId = self.logId;
    
//    vc.currentDBourseInfoDic = self.currentDBCourseInfoDic;
//    vc.currentsectionQuestionInfoDic = self.currentSectionQuestionInfoDic;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didRequestTestDailyPracticeQuestionFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.dailyTableView.mj_header endRefreshing];
    [self.recordTableView.mj_header endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.dailyTableView]) {
        return self.dailyArray.count;
    }
    return self.recordArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    if ([tableView isEqual:self.dailyTableView]) {
        DailyPracticeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kDailyCellId forIndexPath:indexPath];
        
        NSDictionary * infoDic = [self.dailyArray objectAtIndex:indexPath.row];
        [cell resetWithInfoDic:infoDic];
        cell.PracticeBlock = ^(NSDictionary *infoDic) {
            [weakSelf addHistory:infoDic];
        };
        return cell;
    }
    
    TestRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    NSDictionary * infoDic = [self.recordArray objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        cell.isShowTime = YES;
        cell.isFirst = YES;
    }else
    {
        cell.isFirst = NO;
        NSDictionary * lastInfoDic = [self.recordArray objectAtIndex:indexPath.row - 1];
        if ([[lastInfoDic objectForKey:@"time"] isEqualToString:[infoDic objectForKey:@"time"]]) {
            cell.isShowTime = NO;
        }else
        {
            cell.isShowTime = YES;
        }
    }
    if (indexPath.row == self.recordArray.count - 1) {
        cell.isLast = YES;
    }
    cell.isDailyPractice = YES;
    [cell resetWithInfoDic:infoDic];
    
    cell.lookBlock = ^(NSDictionary *infoDic) {
        [weakSelf addHistory:infoDic];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.dailyTableView]) {
        return 66;
    }
    return 65;
}


#pragma mark - HYsegmentDelegate
- (void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
    [self.scrollView setContentOffset:CGPointMake(kScreenWidth * index, 0) animated:NO];
}

@end
