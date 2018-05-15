//
//  SearchReaultViewController.m
//  Accountant
//
//  Created by aaa on 2017/7/5.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "SearchReaultViewController.h"
#import "CourseraManager.h"
#import "LivingCourseViewController.h"
#import "CoursecategoryTableViewCell.h"
#import "ClassroomLivingTableViewCell.h"
#define kClassroomcellId @"ClassroomVideoTableViewCellID"
#define kClassroomLivingcellId @"ClassroomLivingTableViewCellID"
#define OrderAlerttag 2000

@interface SearchReaultViewController ()<UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate,UserModule_OrderLivingCourseProtocol,CourseModule_LivingSectionDetail>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSArray * dataArray;
@property (nonatomic, assign)int orderCourseId;
@property (nonatomic, strong)NSDictionary * selectCourseInfoDic;

@end

@implementation SearchReaultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.searchResultType == SearchResultType_videoCourse) {
        self.dataArray = [[CourseraManager sharedManager] getSearchVideoCourseArray];
    }else
    {
        self.dataArray = [[CourseraManager sharedManager] getSearchLiveStreamArray];
    }
    
    [self navigationViewSetup];
    [self contentViewInit];
    
}

#pragma mark - ui
- (void)navigationViewSetup
{
   
    self.navigationItem.title = @"搜索结果";
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
    CGRect tableViewRect = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIRGBColor(238, 241, 241);
    
    [self.tableView registerClass:[CoursecategoryTableViewCell class] forCellReuseIdentifier:kClassroomcellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"ClassroomLivingTableViewCell" bundle:nil] forCellReuseIdentifier:kClassroomLivingcellId];
    
    [self.view addSubview:self.tableView];
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
    CoursecategoryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kClassroomcellId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.courseType = CourseCategoryType_nomal;
    [cell resetCellContent:[self.dataArray objectAtIndex:indexPath.row]];
    return cell;
    if (self.searchResultType == SearchResultType_videoCourse) {
    }else
    {
//        ClassroomLivingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kClassroomLivingcellId forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell resetWithDic:[self.dataArray objectAtIndex:indexPath.row]];
//        return cell;
        
        CoursecategoryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kClassroomcellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.courseType = CourseCategoryType_nomal;
        [cell resetCellContent:[self.dataArray objectAtIndex:indexPath.row]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [self.dataArray objectAtIndex:indexPath.row];
    self.selectCourseInfoDic = info;
    self.orderCourseId = [[info objectForKey:kCourseID] intValue];
    if (self.searchResultType == SearchResultType_videoCourse) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfCourseClick object:info];
    }else
    {
        if ([[UserManager sharedManager] isUserLogin]){
            
            [SVProgressHUD show];
            NSDictionary * dic1 = @{kCourseID:[info objectForKey:kCourseID],
                                    kteacherId:@"",
                                    @"month":@(0)};
            [[CourseraManager sharedManager] didrequestLivingSectionDetailWithInfo:dic1 andNotifiedObject:self];
            
        }else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLoginClick object:nil];
        }
//        跟我学成本核算
        return;
        
    }
}
#pragma mark - alertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == OrderAlerttag) {
        if (buttonIndex == 1) {
            [SVProgressHUD showWithStatus:@"预约中"];
//            [[UserManager sharedManager] didRequestOrderLivingCourseOperationWithCourseId:self.orderCourseId withNotifiedObject:self];
        }
    }
}


#pragma mark - LivingSectionDetailProtocal

- (void)didRequestLivingSectionDetailSuccessed
{
    [SVProgressHUD dismiss];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLivingChatClick object:self.selectCourseInfoDic];
}

- (void)didRequestLivingSectionDetailFailed:(NSString *)failedInfo
{
    if ([failedInfo isEqualToString:@"暂无数据"]) {
        failedInfo = @"暂无课程";
    }
    
    [SVProgressHUD dismiss];
}

#pragma mark - orderLivingCourseProtocal
- (void)didRequestOrderLivingSuccessed
{
    [SVProgressHUD showWithStatus:@"预约成功"];
    [self performSelector:@selector(orderSuccess) withObject:nil afterDelay:0.7];
}

- (void)didRequestOrderLivingFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:failedInfo delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    [alert performSelector:@selector(dismiss) withObject:nil afterDelay:0.7];
}

- (void)orderSuccess
{
    [SVProgressHUD dismiss];
}

@end
