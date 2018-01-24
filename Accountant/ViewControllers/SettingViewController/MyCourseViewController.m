//
//  MyCourseViewController.m
//  Accountant
//
//  Created by aaa on 2017/3/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "MyCourseViewController.h"
#import "UIMacro.h"
#import "CommonMacro.h"
#import "CourseraManager.h"
#import "DownloadedCourseTableViewCell.h"
#import "UIUtility.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "NotificaitonMacro.h"
#import "CoursecategoryTableViewCell.h"
#import "HYSegmentedControl.h"
#import "MyCourseTableViewCell.h"

#define kHeaderViewHeight 45
#define kSegmentHeight 42
@interface MyCourseViewController ()<UITableViewDelegate,UITableViewDataSource,CourseModule_LearningCourseProtocol,CourseModule_CollectCourseProtocol,CourseModule_DeleteCollectCourseProtocol, HYSegmentedControlDelegate,CourseModule_CompleteCourseProtocol>

@property (nonatomic, strong)HYSegmentedControl * segmentC;
@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic,strong) UIView                                 *headerView;

@property (nonatomic,strong) UIButton                               *button1;
@property (nonatomic,strong) UIButton                               *button2;

@property (nonatomic,strong) UITableView                            *learningTableView;
@property (nonatomic,strong) UITableView                            *completeTableView;
@property (nonatomic,strong) UITableView                            *collectTableView;

@property (nonatomic,strong) NSArray                                *learningCourseArray;
@property (nonatomic, strong)NSArray                                *completeCourseArray;
@property (nonatomic,strong) NSArray                                *collectCourseArray;

@end

@implementation MyCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navigationViewSetup];
    [self segmentSetup];
    [self contentViewSetup];
    [self learningCourseRequest];
    [self collectCourseRequest];
}

- (void)learningCourseRequest
{
    [SVProgressHUD show];
    [[CourseraManager sharedManager] didRequestLearningCourseWithInfoDic:@{@"type":@(0)} NotifiedObject:self];
    
}

- (void)collectCourseRequest
{
    [SVProgressHUD show];
    [[CourseraManager sharedManager] didRequestCollectCourseWithNotifiedObject:self];
}

- (void)CompleteCourseRequest
{
    [[CourseraManager sharedManager] didRequestCompleteCourseWithInfoDic:@{@"type":@(1)} NotifiedObject:self];
}

- (void)deleteCollectCourseWithId:(int)courseId
{
    [SVProgressHUD show];
    [[CourseraManager sharedManager] didRequestDeleteCollectCourseWithCourseId:courseId andNotifiedObject:self];
}

#pragma mark - collect delegate
- (void)didRequestCollectCourseSuccessed
{
    [SVProgressHUD dismiss];
    [self.collectTableView.mj_header endRefreshing];
    self.collectCourseArray = [[CourseraManager sharedManager] getCollectCourseInfoArray];
    [self.collectTableView reloadData];
}

- (void)didRequestCollectCourseFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    [self.collectTableView.mj_header endRefreshing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}
#pragma mark - complete delegate
- (void)didRequestCompleteCourseFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    [self.completeTableView.mj_header endRefreshing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestCompleteCourseSuccessed
{
    [SVProgressHUD dismiss];
    [self.completeTableView.mj_header endRefreshing];
    self.completeCourseArray = [[CourseraManager sharedManager] getCompleteCourseInfoArray];
    [self.completeTableView reloadData];
}
#pragma mark - delete delegate
- (void)didRequestDeleteCollectCourseSuccessed
{
    [SVProgressHUD dismiss];
    
    switch (self.segmentC.selectIndex) {
        case 0:
            [self learningCourseRequest];
            break;
        case 1:
            [self CompleteCourseRequest];
            break;
        case 2:
            [self collectCourseRequest];
            break;
            
        default:
            break;
    }
}

- (void)didRequestDeleteCollectCourseFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    [self.collectTableView.mj_header endRefreshing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - learning delegate
- (void)didRequestLearningCourseSuccessed
{
    [SVProgressHUD dismiss];
    [self.learningTableView.mj_header endRefreshing];
    self.learningCourseArray = [[CourseraManager sharedManager] getLearningCourseInfoArray];
    [self.learningTableView reloadData];
}

- (void)didRequestLearningCourseFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    [self.learningTableView.mj_header endRefreshing];
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
    
    self.navigationItem.title = @"我的课程";
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

- (void)segmentSetup
{
    self.segmentC = [[HYSegmentedControl alloc] initWithOriginY:0 Titles:@[@"学习中", @"已学完",@"收藏"] delegate:self];
    [self.view addSubview:self.segmentC];
}

- (void)contentViewSetup
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentC.frame), kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kSegmentHeight)];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * 3, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kSegmentHeight);
    self.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.scrollView];
    
    self.learningTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kSegmentHeight) style:UITableViewStylePlain];
    self.learningTableView.delegate = self;
    self.learningTableView.dataSource = self;
    [self.learningTableView registerClass:[MyCourseTableViewCell class] forCellReuseIdentifier:@"collectVideo"];
    self.learningTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(learningCourseRequest)];
    
    self.completeTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kSegmentHeight) style:UITableViewStylePlain];
    self.completeTableView.delegate = self;
    self.completeTableView.dataSource = self;
    [self.completeTableView registerClass:[MyCourseTableViewCell class] forCellReuseIdentifier:@"collectVideo"];
    self.completeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(CompleteCourseRequest)];
    
    self.collectTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth * 2, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kSegmentHeight) style:UITableViewStylePlain];
    self.collectTableView.delegate = self;
    self.collectTableView.dataSource = self;
    [self.collectTableView registerClass:[MyCourseTableViewCell class] forCellReuseIdentifier:@"collectVideo"];
    self.collectTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(collectCourseRequest)];
    
    [self.scrollView addSubview:self.learningTableView];
    [self.scrollView addSubview:self.completeTableView];
    [self.scrollView addSubview:self.collectTableView];
}

#pragma mark - table delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.learningTableView) {
        return self.learningCourseArray.count;
    }
    if (tableView == self.collectTableView) {
        return self.collectCourseArray.count;
    }
    if (tableView == self.completeTableView) {
        return self.completeCourseArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyCourseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"collectVideo" forIndexPath:indexPath];
    if ([tableView isEqual:self.collectTableView]) {
        cell.myCourseType = MyCourseCategoryType_collection;
        [cell resetCellContent:[self.collectCourseArray objectAtIndex:indexPath.row]];
    }else if ([tableView isEqual:self.completeTableView]){
        cell.myCourseType = MyCourseCategoryType_complate;
        [cell resetCellContent:[self.completeCourseArray objectAtIndex:indexPath.row]];
    }else
    {
        cell.myCourseType = MyCourseCategoryType_learning;
        [cell resetCellContent:[self.learningCourseArray objectAtIndex:indexPath.row]];
    }
    __weak typeof(self)weakSelf = self;
    cell.DeleteCourseBlock = ^(NSDictionary *infoDic, MyCourseCategoryType type) {
        switch (type) {
            case MyCourseCategoryType_learning:
                [weakSelf deleteLearningCourse:infoDic];
                break;
            case MyCourseCategoryType_complate:
                [weakSelf deleteCompleteCourse:infoDic];
                break;
            case MyCourseCategoryType_collection:
                [weakSelf deleteCollectionCourse:infoDic];
                break;
                
            default:
                break;
        }
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.learningTableView) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfCourseClick object:[self.learningCourseArray objectAtIndex:indexPath.row]];
    }
    if (tableView == self.collectTableView) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfCourseClick object:[self.collectCourseArray objectAtIndex:indexPath.row]];
    }
    if (tableView == self.completeTableView) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfCourseClick object:[self.completeCourseArray objectAtIndex:indexPath.row]];
    }
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (tableView == self.collectTableView) {
//        return NO;
//    }
//    return NO;
//}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (tableView == self.collectTableView) {
//        return UITableViewCellEditingStyleDelete;
//    }
//    return UITableViewCellEditingStyleNone;
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete && tableView == self.collectTableView) {
//        NSDictionary *dic = [self.collectCourseArray objectAtIndex:indexPath.row];
//        [self deleteCollectCourseWithId:[[dic objectForKey:kCourseID] intValue]];
//    }
//}

#pragma mark - deleteCourse
- (void)deleteLearningCourse:(NSDictionary *)infoDic
{
    NSDictionary * dic = @{kCourseID:[infoDic objectForKey:kCourseID],
                           @"type":@(0)};
    [SVProgressHUD show];
    [[CourseraManager sharedManager] didRequestDeleteMyLearningCourseWithCourseInfo:dic andNotifiedObject:self];
}

- (void)deleteCompleteCourse:(NSDictionary *)infoDic
{
    NSDictionary * dic = @{kCourseID:[infoDic objectForKey:kCourseID],
                           @"type":@(1)};
    
    [SVProgressHUD show];
    [[CourseraManager sharedManager] didRequestDeleteMyLearningCourseWithCourseInfo:dic andNotifiedObject:self];
}

- (void)deleteCollectionCourse:(NSDictionary *)infoDic
{
    [SVProgressHUD show];
    [[CourseraManager sharedManager] didRequestDeleteCollectCourseWithCourseId:[[infoDic objectForKey:kCourseID] intValue] andNotifiedObject:self];
}

#pragma mark - HYSegmentedControl 代理方法
- (void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
    if (index == 1) {
        if (self.completeCourseArray.count == 0) {
            [self CompleteCourseRequest];
        }else
        {
            [self.completeTableView reloadData];
        }
    }else if (index == 2)
    {
        [self.collectTableView reloadData];
    }else
    {
        [self.learningTableView reloadData];
    }
    
    [self.scrollView setContentOffset:CGPointMake(index * _scrollView.hd_width, 0) animated:NO];
}
@end
