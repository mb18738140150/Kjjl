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
#define kSettingCellID @"SettingTableViewCellID"

#import "LivingChatViewController.h"

#define headerImageName @"stuhead"

@interface SettingViewController ()<UITableViewDelegate,UIAlertViewDelegate>


@property (nonatomic,strong) SettingViewTableDataSource *tableDataSource;
@property (nonatomic,strong) UITableView                *tableView;

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
    [self navigationViewSetup];
    [self setupContentViews];
}

- (void)logout
{
    [[UserManager sharedManager] logout];
    [self.navigationController.tabBarController setSelectedIndex:0];
}

#pragma mark - ui setup
- (void)navigationViewSetup
{
    self.navigationItem.title = @"我  的";
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.translucent = NO;
    
    UINavigationBar * bar = self.navigationController.navigationBar;
    [bar setShadowImage:[UIImage imageNamed:@"tm"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tm"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.tintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
}

- (void)setupContentViews
{
    self.tableDataSource = [[SettingViewTableDataSource alloc] init];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self.tableDataSource;
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingTableViewCell" bundle:nil] forCellReuseIdentifier:kSettingCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 240;
    }else{
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UserCenterViewController *userCenter = [[UserCenterViewController alloc] init];
        [self.navigationController pushViewController:userCenter animated:YES];
    }
    
    if (indexPath.section == 1 && indexPath.row == 2) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = item;
        MyCourseViewController *vc = [[MyCourseViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1 && indexPath.row == 3) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = item;
        HistoryViewController *vc = [[HistoryViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = item;
        MyQuestionViewController *vc = [[MyQuestionViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1 && indexPath.row == 4) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = item;
        MyNoteViewController *vc = [[MyNoteViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = item;
        DownloadCenterViewController *vc = [[DownloadCenterViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1 && indexPath.row == 5) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = item;
       
        SettingDetailViewController * vc = [[SettingDetailViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.quitBlock = ^(){
            
            [self.navigationController.tabBarController setSelectedIndex:0];
            
        };
        [self.navigationController pushViewController:vc animated:YES];
        
//        LivingChatViewController * chatVC = [[LivingChatViewController alloc]init];
//        chatVC.targetId = @"3202";
//        chatVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:chatVC animated:YES];
        
    }
    
    if (indexPath.section == 2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要退出该账号么" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
        [alert show];
    }
}


#pragma mark - alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self logout];
    }
}

@end
