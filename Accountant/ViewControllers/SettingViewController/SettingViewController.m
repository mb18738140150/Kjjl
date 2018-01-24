//
//  SettingViewController.m
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "SettingViewController.h"
#import "UIMacro.h"
#import "SettingMacro.h"
#import <CoreImage/CoreImage.h>
#import "UserManager.h"
#import "UIImage+Blur.h"
#import "UIImage+Scale.h"
#import "SettingViewTableDataSource.h"
#import "UserCenterViewController.h"
#import "ResetPasswordViewController.h"
#import "DownloadCenterViewController.h"
#import "HistoryViewController.h"
#import "MyQuestionViewController.h"
#import "MyCourseViewController.h"
#import "MyNoteViewController.h"
#import "SettingDetailViewController.h"
#import "SettingTableViewCell.h"
#import "MyLivingCourseViewController.h"
#import "MyOrderListViewController.h"
#import "DiscountCouponViewController.h"
#import "DredgeMemberViewController.h"
#import "IntegralViewController.h"

#import "RecommendDetailViewController.h"
#import "RecommendViewController.h"
#import "StudyPlanViewController.h"
#import "AssistantViewController.h"

#define kSettingCellID @"SettingTableViewCellID"

//#import "LivingChatViewController.h"

#define headerImageName @"stuhead"

@interface SettingViewController ()<UITableViewDelegate,UIAlertViewDelegate,UserModule_CommonProblem>


@property (nonatomic,strong) SettingViewTableDataSource *tableDataSource;
@property (nonatomic,strong) UITableView                *tableView;
@property (nonatomic, strong)NSArray *categoryArray;
@property (nonatomic, strong)NSArray *dataArray;


@end

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navBarBgAlpha = @"0.0";
    self.navigationController.navigationBar.tintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    // 设置导航栏标题和返回按钮颜色
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kCommonMainTextColor_50}];
    
}
#pragma mark - view controller life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
    [self navigationViewSetup];
    [self setupContentViews];
}

- (void)logout
{
    [[UserManager sharedManager] logout];
}

#pragma mark - ui setup
- (void)navigationViewSetup
{
    self.navigationItem.title = @"我的";
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.translucent = NO;
    
    UINavigationBar * bar = self.navigationController.navigationBar;
    [bar setShadowImage:[UIImage imageNamed:@"tm"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tm"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.tintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setupAction)];
    self.navigationItem.rightBarButtonItem = item;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateSelected];
    
}

- (void)setupContentViews
{
    
    self.tableDataSource = [[SettingViewTableDataSource alloc] init];
    self.tableDataSource.catoryDataSourceArray = self.categoryArray;
    self.tableDataSource.dataSourceArray = self.dataArray;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, kScreenWidth, kScreenHeight + 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self.tableDataSource;
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingTableViewCell" bundle:nil] forCellReuseIdentifier:kSettingCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseCategoryClick:) name:kNotificationOfMainPageCategoryClick object:nil];
    __weak typeof(self)weakSelf = self;
    self.tableDataSource.upgradeMemberLevelBlock = ^{
        [weakSelf upgradeMemberLevel];
    };
    
}

- (void)loadData
{
    self.categoryArray = @[@{kCourseCategoryName:@"课程",
                             kCourseCategoryCoverUrl:@"icon_kc",
                             kCourseCategoryId:@(1)},
                           @{kCourseCategoryName:@"直播",
                             kCourseCategoryCoverUrl:@"icon_zb",
                             kCourseCategoryId:@(2)},
                           @{kCourseCategoryName:@"答疑",
                             kCourseCategoryCoverUrl:@"icon_dy",
                             kCourseCategoryId:@(3)},
                           @{kCourseCategoryName:@"笔记",
                             kCourseCategoryCoverUrl:@"icon_bj",
                             kCourseCategoryId:@(4)}
                           ];
    
    
    self.dataArray = @[@[@{@"imageName":@"icon_hy",@"title":[[UserManager sharedManager] getLevelStr],@"tip":@""}],@[@{@"imageName":@"icon_dd",@"title":@"订单",@"tip":@""},@{@"imageName":@"icon_xz1",@"title":@"下载",@"tip":@""}],@[@{@"imageName":@"icon_jf",@"title":@"积分",@"tip":@""},@{@"imageName":@"icon_kq",@"title":@"卡券",@"tip":@""},@{@"imageName":@"icon_ewm",@"title":@"推广二维码",@"tip":@""}],@[@{@"imageName":@"icon_kf",@"title":@"客服中心",@"tip":@""}]];
}

- (void)courseCategoryClick:(NSNotification *)notifier
{
    NSDictionary *infoDic = notifier.object;
    switch ([[infoDic objectForKey:kCourseCategoryId] intValue]) {
        case 1:
        {
            NSLog(@"课程");
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
            self.navigationItem.backBarButtonItem = item;
            MyCourseViewController *vc = [[MyCourseViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            NSLog(@"直播");
            MyLivingCourseViewController * vc = [[MyLivingCourseViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            NSLog(@"答疑");
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
            self.navigationItem.backBarButtonItem = item;
            MyQuestionViewController *vc = [[MyQuestionViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            NSLog(@"笔记");
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
            self.navigationItem.backBarButtonItem = item;
            MyNoteViewController *vc = [[MyNoteViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - upgradeMemberLevel
- (void)upgradeMemberLevel
{
    DredgeMemberViewController * vc = [[DredgeMemberViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 139;
    }else if (indexPath.section == 1)
    {
        return 98;
    }
    else{
        return 38;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 7;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 7)];
    view.backgroundColor = UIColorFromRGB(0xedf0f0);
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                UserCenterViewController *userCenter = [[UserCenterViewController alloc] init];
                userCenter.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:userCenter animated:YES];
            }else
            {
                if ([WXApi isWXAppSupportApi] && [WXApi isWXAppInstalled]) {
                    [self upgradeMemberLevel];
                }
            }
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            NSDictionary * infoDic = [NSDictionary dictionary];
            if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
                infoDic = [self.dataArray[indexPath.section - 1] objectAtIndex:indexPath.row];
            }else
            {
                infoDic = [self.dataArray[indexPath.section - 1] objectAtIndex:indexPath.row + 1];
            }
            
            NSString * title = [infoDic objectForKey:@"title"];
            if ([title isEqualToString:@"订单"]) {
                UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
                self.navigationItem.backBarButtonItem = item;
                MyOrderListViewController *vc = [[MyOrderListViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([title isEqualToString:@"学习计划"])
            {
                NSLog(@"学习计划");
                StudyPlanViewController * studyVC = [[StudyPlanViewController alloc]init];
                studyVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:studyVC animated:YES];
            }else if ([title isEqualToString:@"下载"])
            {
                NSLog(@"下载");
                UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
                self.navigationItem.backBarButtonItem = item;
                DownloadCenterViewController *vc = [[DownloadCenterViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 3:
        {
            if (indexPath.row == 0) {
                NSLog(@"积分");
                IntegralViewController * integralVC = [[IntegralViewController alloc]initWithNibName:@"IntegralViewController" bundle:nil];
                integralVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:integralVC animated:YES];
                
            }else if (indexPath.row == 1)
            {
                NSLog(@"卡券");
                DiscountCouponViewController * discountVC = [[DiscountCouponViewController alloc]init];
                discountVC.myDscountCoupon = YES;
                discountVC.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:discountVC animated:YES];
            }else
            {
                NSLog(@"推广二维码");
                RecommendDetailViewController * recommenVC = [[RecommendDetailViewController alloc]init];
                recommenVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:recommenVC animated:YES];
            }
        }
            break;
        case 4:
        {
            NSLog(@"客服中心");
            [SVProgressHUD show];
            [[UserManager sharedManager] didRequestCommonProblemWithInfo:@{} withNotifiedObject:self];
        }
            break;
            
        default:
            break;
    }
    
    /*
     
     if (indexPath.section == 2 && indexPath.row == 2) {
     UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
     self.navigationItem.backBarButtonItem = item;
     MyCourseViewController *vc = [[MyCourseViewController alloc] init];
     vc.hidesBottomBarWhenPushed = YES;
     [self.navigationController pushViewController:vc animated:YES];
     }
     if (indexPath.section == 2 && indexPath.row == 3) {
     UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
     self.navigationItem.backBarButtonItem = item;
     HistoryViewController *vc = [[HistoryViewController alloc] init];
     vc.hidesBottomBarWhenPushed = YES;
     [self.navigationController pushViewController:vc animated:YES];
     }
     if (indexPath.section == 2 && indexPath.row == 1) {
     UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
     self.navigationItem.backBarButtonItem = item;
     MyQuestionViewController *vc = [[MyQuestionViewController alloc] init];
     vc.hidesBottomBarWhenPushed = YES;
     [self.navigationController pushViewController:vc animated:YES];
     }
     if (indexPath.section == 2 && indexPath.row == 4) {
     UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
     self.navigationItem.backBarButtonItem = item;
     MyNoteViewController *vc = [[MyNoteViewController alloc] init];
     vc.hidesBottomBarWhenPushed = YES;
     [self.navigationController pushViewController:vc animated:YES];
     }
     if (indexPath.section == 2 && indexPath.row == 0) {
     UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
     self.navigationItem.backBarButtonItem = item;
     DownloadCenterViewController *vc = [[DownloadCenterViewController alloc] init];
     vc.hidesBottomBarWhenPushed = YES;
     
     [self.navigationController pushViewController:vc animated:YES];
     }
     if (indexPath.section == 2 && indexPath.row == 5) {
     UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
     self.navigationItem.backBarButtonItem = item;
     
     __weak typeof(self)weakSelf = self;
     
     SettingDetailViewController * vc = [[SettingDetailViewController alloc]init];
     vc.hidesBottomBarWhenPushed = YES;
     vc.quitBlock = ^(){
     
     [weakSelf performSelector:@selector(changeSelectIndex) withObject:nil afterDelay:0.1];
     };
     [self.navigationController pushViewController:vc animated:YES];
     
     }
     */
    
    
}



- (void)setupAction
{
    __weak typeof(self)weakSelf = self;
    
    SettingDetailViewController * vc = [[SettingDetailViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.quitBlock = ^(){
        [weakSelf logout];
        [weakSelf performSelector:@selector(changeSelectIndex) withObject:nil afterDelay:0.1];
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)changeSelectIndex
{
    [self.navigationController.tabBarController setSelectedIndex:0];
}

#pragma mark - alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self logout];
    }
}

#pragma mark - commonProblemDelegate
- (void)didRequestCommonProblemSuccessed
{
    [SVProgressHUD dismiss];
    AssistantViewController * assistantVC = [[AssistantViewController alloc]init];
    assistantVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:assistantVC animated:YES];
}

- (void)didRequestCommonProblemFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    AssistantViewController * assistantVC = [[AssistantViewController alloc]init];
    assistantVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:assistantVC animated:YES];
}

@end
