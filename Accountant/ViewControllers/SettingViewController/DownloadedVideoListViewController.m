//
//  DownloadedVideoListViewController.m
//  Accountant
//
//  Created by 阴天翔 on 2017/3/12.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DownloadedVideoListViewController.h"
#import "UIMacro.h"
#import "CommonMacro.h"
#import "UIUtility.h"
#import "NotificaitonMacro.h"
#import "DBManager.h"
#import "PathUtility.h"
#import "DownloadVideoPlayerViewController.h"

@interface DownloadedVideoListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView            *contentTableView;

@property (nonatomic,assign) int                     courseId;

@end

@implementation DownloadedVideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navigationViewSetup];
    [self contentTableSetup];
    self.courseId = [[self.courseInfoDic objectForKey:kCourseID] intValue];
}

- (void)refreshTables
{
    self.courseInfoDic = [[DBManager sharedManager] getCourseInfosWithCourseId:@(self.courseId)];
    [self.contentTableView reloadData];
}

- (void)navigationViewSetup
{
    if (self.isPresent) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        [self addTopView];
        
        return;
    }
    
    self.navigationItem.title = [self.courseInfoDic objectForKey:kCourseName];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //    self.navigationController.navigationBarHidden = YES;
    
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50};
    
    [self editButtonEdit];
   /* UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = item;*/
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"public-返回"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editButtonEdit
{
    [self.contentTableView setEditing:NO animated:YES];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonDone)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)editButtonDone
{
    [self.contentTableView setEditing:YES animated:YES];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonEdit)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)contentTableSetup
{
    CGFloat presentHeight = 0;
    if (self.isPresent) {
        presentHeight = 64;
    }
    
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 + presentHeight, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    [self.view addSubview:self.contentTableView];
}

#pragma mark - table delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSArray *chapters = [self.courseInfoDic objectForKey:kCourseChapterInfos];
    return chapters.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *chapters = [self.courseInfoDic objectForKey:kCourseChapterInfos];
    NSDictionary *chapterInfo = [chapters objectAtIndex:section];
    NSArray *videoInfos = [chapterInfo objectForKey:kChapterVideoInfos];
    return videoInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UIUtility getCellWithCellName:@"alreadyDownloadCell" inTableView:tableView andCellClass:[UITableViewCell class]];
    NSArray *chapters = [self.courseInfoDic objectForKey:kCourseChapterInfos];
    NSDictionary *chapterInfo = [chapters objectAtIndex:indexPath.section];
    NSArray *videoInfos = [chapterInfo objectForKey:kChapterVideoInfos];
    NSDictionary *videoInfo = [videoInfos objectAtIndex:indexPath.row];
    cell.textLabel.text = [videoInfo objectForKey:kVideoName];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    label.backgroundColor = [UIColor whiteColor];
    NSArray *chapters = [self.courseInfoDic objectForKey:kCourseChapterInfos];
    NSDictionary *chapterInfo = [chapters objectAtIndex:section];
    label.text = [chapterInfo objectForKey:kChapterName];
    label.textColor = [UIColor grayColor];
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, kScreenWidth, 1)];
    bottomLineView.backgroundColor = kTableViewCellSeparatorColor;
    [label addSubview:bottomLineView];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = @{@"section":@(indexPath.section),
                          @"row":@(indexPath.row),
                          @"courseInfo":self.courseInfoDic};
    if (self.isPresent) {
        DownloadVideoPlayerViewController *vc = [[DownloadVideoPlayerViewController alloc] init];
        vc.courseInfoDic = [dic objectForKey:@"courseInfo"];
        vc.selectedSection = [[dic objectForKey:@"section"] intValue];
        vc.selectedRow = [[dic objectForKey:@"row"] intValue];
        [self presentViewController:vc animated:YES completion:nil];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfDownloadCourseClick object:dic];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *chapters = [self.courseInfoDic objectForKey:kCourseChapterInfos];
        NSDictionary *chapterInfo = [chapters objectAtIndex:indexPath.section];
        NSArray *videoInfos = [chapterInfo objectForKey:kChapterVideoInfos];
        NSDictionary *videoInfo = [videoInfos objectAtIndex:indexPath.row];
        [[DBManager sharedManager] deleteVideos:videoInfo];
        
        NSString *docPath = [PathUtility getDocumentPath];
        NSString *path1 = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[self.courseInfoDic objectForKey:kCoursePath]]];
        
        NSString *path2 = [path1 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[chapterInfo objectForKey:kChapterPath]]];
        NSString *path3 = [path2 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[videoInfo objectForKey:kVideoPath]]];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        if ([fileManager fileExistsAtPath:path3]) {
            [fileManager removeItemAtPath:path3 error:&error];
        }
        
        [self refreshTables];
    }
}

- (void)addTopView
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - 100, 20, 200, 44)];
    titleLabel.text = [self.courseInfoDic objectForKey:kCourseName];
    titleLabel.textColor = kCommonMainTextColor_50;
    titleLabel.textAlignment = 1;
    [topView addSubview:titleLabel];
    
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(15, 22 + 12, 20, 20);
    [backBT setImage:[UIImage imageNamed:@"public-返回"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBT];
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 63, kScreenWidth, 0.5)];
    bottomView.backgroundColor = kCommonMainTextColor_200;
    [topView addSubview:bottomView];
}

- (void)backAction
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionReveal;
    [self.view.window.layer addAnimation:animation forKey:nil ];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
