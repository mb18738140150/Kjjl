//
//  AllCourseViewController.m
//  Accountant
//
//  Created by aaa on 2017/3/1.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "AllCourseViewController.h"
#import "CourseraManager.h"
#import "UIMacro.h"
#import "MainViewMacro.h"
#import "AllCourseTableDataSource.h"
#import "CourseModuleProtocol.h"
#import "CourseraManager.h"
#import "SVProgressHUD.h"
#import "UserManager.h"
#import "MJRefresh.h"
#import "CommonMacro.h"

@interface AllCourseViewController ()<UITableViewDelegate,CourseModule_AllCourseProtocol,CourseModule_CourseCategoryDetailProtocol>

@property (nonatomic,strong) UITableView                        *contentTableView;
@property (nonatomic,strong) AllCourseTableDataSource           *dataSource;

@end

@implementation AllCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navigationViewSetup];
    [self contentViewInit];
    
    [self request];
}

- (void)request
{
    if (self.intoType == IntoPageTypeAllCourse) {
        [[CourseraManager sharedManager] didRequestAllCoursesWithNotifiedObject:self];
    }
    if (self.intoType == IntoPageTypeCategoryCourse) {
        [[CourseraManager sharedManager] didRequestCategoryDetailWithCategoryId:self.courseCategoryId andUserId:[[UserManager sharedManager] getUserId] withNotifiedObject:self];
    }
    [SVProgressHUD show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeightOfCourse;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    headView.backgroundColor = UIRGBColor(238, 241, 241);;
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, kScreenWidth - 30, 16)];
    titleLabel.textColor = kMainTextColor;
    titleLabel.text = [[self.dataSource.courseListArray objectAtIndex:section] objectForKey:kCourseSecondName];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [headView addSubview:titleLabel];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.dataSource.courseListArray.count == 1 && [[[self.dataSource.courseListArray objectAtIndex:section] objectForKey:kCourseSecondName] length] == 0) {
        return 0;
    }else
    {
        return 40;
    }
}

#pragma mark - ui
- (void)navigationViewSetup
{
    if (self.intoType == IntoPageTypeAllCourse) {
        self.navigationItem.title = @"全部课程";
    }
    if (self.intoType == IntoPageTypeCategoryCourse) {
        self.navigationItem.title = self.categoryName;
    }
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50};
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    
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
    CGRect tableViewRect = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kTabBarHeight);
    self.contentTableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    self.dataSource = [[AllCourseTableDataSource alloc] init];
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self.dataSource;
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contentTableView.backgroundColor = UIRGBColor(238, 241, 241);
    if (self.intoType == IntoPageTypeAllCourse) {
        self.contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(request)];
    }
    //    self.contentTableView.bounces = NO;
    [self.view addSubview:self.contentTableView];
}

#pragma mark - all course delegate
- (void)didRequestAllCourseSuccessed
{
    [SVProgressHUD dismiss];
    self.dataSource.courseListArray = [[CourseraManager sharedManager] getAllCourseArray];
    [self.contentTableView.mj_header endRefreshing];
    [self.contentTableView reloadData];
}

- (void)didRequestAllCourseFailed
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"网络连接失败，请稍后再试"];
    [self.contentTableView.mj_header endRefreshing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}

#pragma mark - detail course delegate
- (void)didReuquestCourseCategoryDetailSuccessed
{
    [SVProgressHUD dismiss];

    self.dataSource.courseListArray = [[CourseraManager sharedManager] getCategoryCoursesInfo];
    
    for (NSDictionary * dic in self.dataSource.courseListArray) {
        NSLog(@"%@", [dic description]);
    }
    
    [self.contentTableView reloadData];
}

- (void)didReuquestCourseCategoryDetailFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

@end
