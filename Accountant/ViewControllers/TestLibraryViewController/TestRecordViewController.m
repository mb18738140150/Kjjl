//
//  TestRecordViewController.m
//  Accountant
//
//  Created by aaa on 2018/1/19.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "TestRecordViewController.h"
#import "TestRecordTableViewCell.h"
#define kCellId @"TestRecordTableViewCellId"
#import "TestChapterQuestionViewController.h"

@interface TestRecordViewController ()<UITableViewDelegate, UITableViewDataSource, TestModule_TestRecord,TestModule_TestRecordQuestion>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSArray * dataArray;

@end

@implementation TestRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kCommonNavigationBarColor;
    
    [self navigationViewSetup];
    [self contentViewInit];
    
    [self startRequest];
}

#pragma mark - ui

- (void)navigationViewSetup
{
    self.navigationItem.title = @"做题记录";
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
    CGRect tableViewRect = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"TestRecordTableViewCell" bundle:nil] forCellReuseIdentifier:kCellId];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self startRequest];
    }];
    
    [self.view addSubview:self.tableView];
}

- (void)startRequest
{
    [SVProgressHUD show];
    [[TestManager sharedManager] didRequestTestRecordWithInfo:@{kTestCategoryId:@(self.courseCategoryId)} andNotifiedObject:self];
}

- (void)requestRecordQuestion:(NSDictionary *)infoDic
{
    [SVProgressHUD show];
    [[TestManager sharedManager] didRequestTestRecordQoestionWithInfo:infoDic andNotifiedObject:self];
}

- (void)didRequestTestRecordSuccess
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    self.dataArray = [[TestManager sharedManager] getTestRecord];
    [self.tableView reloadData];
}

- (void)didRequestTestRecordFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestTestRecordQuestionSuccess
{
    [SVProgressHUD dismiss];
    TestChapterQuestionViewController *vc = [[TestChapterQuestionViewController alloc] init];
    vc.questionType = TestQuestionTypeRecord;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didRequestTestRecordQuestionFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TestRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    NSDictionary * infoDic = [self.dataArray objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        cell.isShowTime = YES;
        cell.isFirst = YES;
    }else
    {
        cell.isFirst = NO;
        NSDictionary * lastInfoDic = [self.dataArray objectAtIndex:indexPath.row - 1];
        if ([[lastInfoDic objectForKey:@"time"] isEqualToString:[infoDic objectForKey:@"time"]]) {
            cell.isShowTime = NO;
        }else
        {
            cell.isShowTime = YES;
        }
    }
    if (indexPath.row == self.dataArray.count - 1) {
        cell.isLast = YES;
    }
    [cell resetWithInfoDic:infoDic];
    __weak typeof(self) weakSelf = self;
    cell.lookBlock = ^(NSDictionary *infoDic) {
        [weakSelf requestRecordQuestion:infoDic];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}


@end
