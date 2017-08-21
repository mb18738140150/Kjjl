//
//  HistoryViewController.m
//  Accountant
//
//  Created by aaa on 2017/3/17.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryViewTableDataSource.h"
#import "SettingMacro.h"
#import "MJRefresh.h"
#import "CommonMacro.h"
#import "UIMacro.h"
#import "HistoryTableHeaderView.h"
#import "SVProgressHUD.h"
#import "CourseraManager.h"
#import "NotificaitonMacro.h"
#import "UIUtility.h"

@interface HistoryViewController ()<UITableViewDelegate,CourseModule_HistoryCourseProtocol>

@property (nonatomic,strong) UITableView                        *contentTableView;
@property (nonatomic,strong) HistoryViewTableDataSource         *tableDataSource;

@property (nonatomic,strong) NSArray                            *infosArray;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self navigationViewSetup];
    [self contentViewSetup];
    [self requestHistoryInofs];
}

- (void)requestHistoryInofs
{
    [SVProgressHUD show];
    [[CourseraManager sharedManager] didRequestCourseHistoryWithNotifiedObject:self];
}

#pragma mark - history delegate
- (void)didRequestHistroyCourseSuccessed
{
    [SVProgressHUD dismiss];
    [self.contentTableView.mj_header endRefreshing];
    self.infosArray = [[CourseraManager sharedManager] getHistoryInfoArray];
    self.tableDataSource.historyInfos = self.infosArray;
    [self.contentTableView reloadData];
}

- (void)didRequestHistroyCourseFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.contentTableView.mj_header endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - ui

- (void)navigationViewSetup
{
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, kScreenWidth, 64)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"学习记录";
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

- (void)contentViewSetup
{
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    self.contentTableView.backgroundColor = UIRGBColor(230, 230, 230);
    self.contentTableView.delegate = self;
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestHistoryInofs)];
    self.tableDataSource = [[HistoryViewTableDataSource alloc] init];
    self.contentTableView.dataSource = self.tableDataSource;
    [self.view addSubview:self.contentTableView];
}

#pragma mark - table delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * str = @"";
    NSDictionary *dic = [self.infosArray objectAtIndex:indexPath.section];
    NSArray *array = [dic objectForKey:kHistoryInfos];
    NSDictionary *infoDic = [array objectAtIndex:indexPath.row];
    if ([[infoDic objectForKey:kVideoName] length] != 0) {
        str = [infoDic objectForKey:kVideoName];
    }else
    {
        str = [infoDic objectForKey:kChapterName];
    }
    CGFloat contentHeight = [UIUtility getHeightWithText:str font:[UIFont systemFontOfSize:14] width:kScreenWidth - 80];
    if (contentHeight > 20) {
        return kHistoryCellHeight + contentHeight - 20;
    }else
    {
        return kHistoryCellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHistoryHeaderHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.infosArray objectAtIndex:indexPath.section];
    NSArray *array = [dic objectForKey:kHistoryInfos];
    NSDictionary *info = [array objectAtIndex:indexPath.row];
    
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] initWithDictionary:info];
    [infoDic setObject:@(YES) forKey:kCourseIsStartFromLoaction];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfCourseClick object:infoDic];
    
    NSLog(@"%@ = %@, %@ = %@, %@ = %@", [info objectForKey:kCourseName], [info objectForKey:kCourseID], [info objectForKey:kChapterName], [info objectForKey:kChapterId], [info objectForKey:kVideoName], [info objectForKey:kVideoId]);
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HistoryTableHeaderView *headerView = [[HistoryTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHistoryCellHeight)];
    NSDictionary *dic = [self.infosArray objectAtIndex:section];
    [headerView setTime:[dic objectForKey:kHistoryTime]];
    return headerView;
}

@end
