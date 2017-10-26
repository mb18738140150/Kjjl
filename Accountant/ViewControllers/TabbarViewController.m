//
//  TabbarViewController.m
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TabbarViewController.h"
#import "MainViewController.h"
#import "SettingViewController.h"
#import "QuestionViewController.h"
#import "LoginViewController.h"
#import "NotificaitonMacro.h"
#import "VideoPlayViewController.h"
#import "UserManager.h"
#import "CourseCategoryViewController.h"
#import "AllCourseViewController.h"
#import "CourseraManager.h"
#import "CommonMacro.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "TestLibraryViewController.h"
#import "DownloadVideoPlayerViewController.h"
#import "ShowPhotoViewController.h"
#import "LivingChatViewController.h"
#import "RCDLiveChatRoomViewController.h"

@interface TabbarViewController ()<UITabBarControllerDelegate,CourseModule_DetailCourseProtocol>

@property (nonatomic,strong) MainViewController             *mainViewController;
@property (nonatomic,strong) SettingViewController          *settingViewController;
@property (nonatomic,strong) QuestionViewController         *questionViewController;
@property (nonatomic,strong) CourseCategoryViewController   *courseCategoryViewController;
@property (nonatomic,strong) TestLibraryViewController      *testLibraryViewController;

@property (nonatomic,strong) AFNetworkReachabilityManager   *netManager;

@property (nonatomic,assign) BOOL                            isPlayFromLoacation;
@property (nonatomic,assign) int                             chapterId;
@property (nonatomic,assign) int                             videoId;

@end

@implementation TabbarViewController


#pragma mark - view controller life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.delegate = self;
    [self setupChildViewControllers];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseClick:) name:kNotificationOfCourseClick object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadCourseClick:) name:kNotificationOfDownloadCourseClick object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quesitonImageClick:) name:kNotificationOfQuestionImageClick object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginClick:) name:kNotificationOfLoginClick object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerClick:) name:kNotificationOfRegisterClick object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(livingChatClick:) name:kNotificationOfLivingChatClick object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(livingPlayBackClick:) name:kNotificationOfLivingPlayBackClick object:nil];
    
    [self startMonitorNet];
}

- (void)requireLogin
{
    LoginViewController *login = [[LoginViewController alloc] init];
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:login];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)playVideo
{
    VideoPlayViewController *vc = [[VideoPlayViewController alloc] init];
    vc.isPlayFromLoacation = self.isPlayFromLoacation;
    if (self.isPlayFromLoacation) {
        vc.beginVideoId = self.videoId;
        vc.beginChapterId = self.chapterId;
    }
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)startMonitorNet
{
    self.netManager = [AFNetworkReachabilityManager manager];
    __block NSString *showString;
    [self.netManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable: {
                showString = @"网络不可用";
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                showString = @"正在使用wifi网络";
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                showString = @"正在使用手机流量";
                break;
            }
                
            case AFNetworkReachabilityStatusUnknown: {
                showString = @"正在使用未知网络";
                break;
            }
                
            default:
                break;
        }
        [SVProgressHUD showInfoWithStatus:showString];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    [self.netManager startMonitoring];
}

#pragma mark - notification func

- (void)livingPlayBackClick:(NSNotification *)notification
{
    NSDictionary * infoDic = notification.object;
    VideoPlayViewController *vc = [[VideoPlayViewController alloc] init];
    vc.infoDic = infoDic;
    vc.isPlayFromLoacation = self.isPlayFromLoacation;
    if (self.isPlayFromLoacation) {
        vc.beginVideoId = self.videoId;
        vc.beginChapterId = self.chapterId;
    }
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)livingChatClick:(NSNotification *)notification
{
    NSDictionary * infoDic = notification.object;
    
    RCDLiveChatRoomViewController *chatRoomVC = [[RCDLiveChatRoomViewController alloc]init];
    
    if (![infoDic objectForKey:kChatRoomID]) {
        if ([infoDic objectForKey:kCourseSecondID] && [[infoDic objectForKey:kCourseSecondID] intValue] == 0) {
            infoDic = [[[CourseraManager sharedManager] getLivingSectionDetailArray] objectAtIndex:0];
        }else
        {
            for (NSDictionary *dic in [[CourseraManager sharedManager] getLivingSectionDetailArray]) {
                if ([[infoDic objectForKey:kCourseSecondID]isEqual:[dic objectForKey:kCourseSecondID]]) {
                    infoDic = dic;
                }
            }
        }
        
        chatRoomVC.isLivingCourse = YES;
    }
    
    chatRoomVC.conversationType = ConversationType_CHATROOM;
    chatRoomVC.targetId = [NSString stringWithFormat:@"%@", [infoDic objectForKey:kChatRoomID]];
//        chatRoomVC.targetId = @"chatRoomId-008";
    chatRoomVC.contentURL = [infoDic objectForKey:kCourseURL];
    chatRoomVC.infoDic = infoDic;
    [self presentViewController:chatRoomVC animated:YES completion:nil];
    
}

- (void)loginClick:(NSNotification *)notification
{
    [self requireLogin];
}

- (void)registerClick:(NSNotification *)notification
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"注册？" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)downloadCourseClick:(NSNotification *)notification
{
    NSDictionary *infoDic = notification.object;
    DownloadVideoPlayerViewController *vc = [[DownloadVideoPlayerViewController alloc] init];
    vc.courseInfoDic = [infoDic objectForKey:@"courseInfo"];
    vc.selectedSection = [[infoDic objectForKey:@"section"] intValue];
    vc.selectedRow = [[infoDic objectForKey:@"row"] intValue];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)quesitonImageClick:(NSNotification *)notification
{
    UIImage *image = notification.object;
    ShowPhotoViewController *vc = [[ShowPhotoViewController alloc] initWithImage:image];
    vc.isShowDelete = NO;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)courseClick:(NSNotification *)notification
{
    if ([[UserManager sharedManager] isUserLogin]) {
        NSDictionary *infoDic = notification.object;
        [infoDic objectForKey:kCourseID];
        BOOL isStartFromLoaction = [[infoDic objectForKey:kCourseIsStartFromLoaction] boolValue];
        [CourseraManager sharedManager].courseModuleModel.detailCourseModel.courseModel.courseID = [[infoDic objectForKey:kCourseID] intValue];
        [CourseraManager sharedManager].courseModuleModel.detailCourseModel.courseModel.courseName =[infoDic objectForKey:kCourseName];
        [CourseraManager sharedManager].courseModuleModel.detailCourseModel.courseModel.courseCover = [infoDic objectForKey:kCourseCover];
        [SVProgressHUD show];
        
        if (isStartFromLoaction) {
            self.isPlayFromLoacation = YES;
            self.chapterId = [[infoDic objectForKey:kChapterId] intValue];
            self.videoId = [[infoDic objectForKey:kVideoId] intValue];
        }else{
            self.isPlayFromLoacation = NO;
        }
        [[CourseraManager sharedManager] didRequestDetailCourseWithCourseID:[[infoDic objectForKey:kCourseID] intValue] withNotifiedObject:self];
//        [[CourseraManager sharedManager] didRequestDetailCourseWithCourseID:164 withNotifiedObject:self];
    }
    else{
        [self requireLogin];
    }
    
}

#pragma mark - ui setup
- (void)setupChildViewControllers
{
    self.mainViewController = [[MainViewController alloc] init];
    self.settingViewController = [[SettingViewController alloc] init];
    self.questionViewController = [[QuestionViewController alloc] init];
    self.courseCategoryViewController = [[CourseCategoryViewController alloc] init];
    self.testLibraryViewController = [[TestLibraryViewController alloc] init];
    
    
    /*    self.courseCategoryViewController = [[AllCourseViewController alloc] init];
     self.courseCategoryViewController.intoType = IntoPageTypeAllCourse;*/
    
    UINavigationController *mainNavigation = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
    mainNavigation.tabBarItem.image = [UIImage imageNamed:@"首页-首页(2)"];
    mainNavigation.tabBarItem.selectedImage = [[UIImage imageNamed:@"首页act50-50"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mainNavigation.tabBarItem.title = @"首页";
    
    UINavigationController *categoryNavigation = [[UINavigationController alloc] initWithRootViewController:self.courseCategoryViewController];
    categoryNavigation.tabBarItem.image = [UIImage imageNamed:@"课程50-50"];
    categoryNavigation.tabBarItem.selectedImage = [[UIImage imageNamed:@"课程act50-50"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    categoryNavigation.tabBarItem.title = @"课程";
    
    UINavigationController *questionNavigation = [[UINavigationController alloc] initWithRootViewController:self.questionViewController];
    questionNavigation.tabBarItem.image = [UIImage imageNamed:@"答疑50-50"];
    questionNavigation.tabBarItem.selectedImage = [[UIImage imageNamed:@"答疑act50-50"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    questionNavigation.tabBarItem.title = @"答疑";
    
    UINavigationController *testNavigation = [[UINavigationController alloc] initWithRootViewController:self.testLibraryViewController];
    testNavigation.tabBarItem.image = [UIImage imageNamed:@"题库50-50"];
    testNavigation.tabBarItem.selectedImage = [[UIImage imageNamed:@"act"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    testNavigation.tabBarItem.title = @"题库";
    
    UINavigationController *settingNavigation = [[UINavigationController alloc] initWithRootViewController:self.settingViewController];
    settingNavigation.tabBarItem.image = [UIImage imageNamed:@"me50-50-1"];
    settingNavigation.tabBarItem.selectedImage = [[UIImage imageNamed:@"me-act50-50-2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    settingNavigation.tabBarItem.title = @"我的";
    
    self.viewControllers = @[mainNavigation,categoryNavigation,questionNavigation,testNavigation,settingNavigation];
}


#pragma mark - delegate func
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UINavigationController *nav = (UINavigationController *)viewController;
    if ([nav.topViewController class] == [SettingViewController class]) {
        if (![[UserManager sharedManager] isUserLogin]) {
            [self requireLogin];
            [self setSelectedIndex:0];
        }
    }
    if ([nav.topViewController class] == [TestLibraryViewController class]) {
        if (![[UserManager sharedManager] isUserLogin]) {
            [self requireLogin];
            [self setSelectedIndex:0];
        }
    }
    if ([nav.topViewController class] == [QuestionViewController class]) {
        if (![[UserManager sharedManager] isUserLogin]) {
            [self requireLogin];
            [self setSelectedIndex:0];
        }
    }
}

#pragma mark - course detail func
- (void)didRequestCourseDetailSuccessed
{
    [SVProgressHUD dismiss];
    [self playVideo];
}

- (void)didRequestCourseDetailFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
