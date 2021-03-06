//
//  DownLoadViewController.m
//  Accountant
//
//  Created by aaa on 2017/3/9.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DownLoadViewController.h"
#import "CommonMacro.h"
#import "UIMacro.h"
#import "UIUtility.h"
#import "DownloaderManager.h"
#import "CourseraManager.h"
#import "DownloadRquestOperation.h"
#import "NSString+MD5.h"
#import "SVProgressHUD.h"
#import "DownloadTableViewCell.h"

@interface DownLoadViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView        *contentTableView;

@property (nonatomic,strong) UIView             *downloadView;

@property (nonatomic,strong) NSMutableArray     *selectedArray;

@property (nonatomic,strong) NSMutableDictionary    *selectedInfoDic;

@property (nonatomic,strong) NSDictionary       *playCourseInfoDic;

@end

@implementation DownLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playCourseInfoDic = [[CourseraManager sharedManager] getPlayCourseInfo];
    
    [self contentViewSetup];
    [self navigationViewSetup];
    self.selectedArray = [[NSMutableArray alloc] init];
    self.selectedInfoDic = [[NSMutableDictionary alloc] init];
}

- (void)dissmiss
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)startDownload
{
    NSArray *selectedIds = [self.selectedInfoDic allValues];
    NSArray *sortedArray = [selectedIds sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *str1 = obj1;
        NSString *str2 = obj2;
        NSComparisonResult result = [str1 compare:str2];
        return result == NSOrderedDescending;
    }];
    
    for (NSString *str in sortedArray) {
        NSArray *tmpArray = [str componentsSeparatedByString:@"_"];
        int sec = [[tmpArray objectAtIndex:0] intValue];
        int row = [[tmpArray objectAtIndex:1] intValue];
        NSDictionary *chapterInfo = [self.chapterInfoArray objectAtIndex:sec];
        NSDictionary *videoInfo = [[self.chapterVideoInfoArray objectAtIndex:sec] objectAtIndex:row];
        NSDictionary *courseInfo = self.playCourseInfoDic;
        
        NSString *downloadTaskId = [DownloadRquestOperation getDownloadTaskIdWitChapterId:[chapterInfo objectForKey:kChapterId] andVideoId:[videoInfo objectForKey:kVideoId]];
        
        NSString *videoPath = [[NSString stringWithFormat:@"%@",[videoInfo objectForKey:kVideoId]] MD5];
        NSString *chapterPath = [[NSString stringWithFormat:@"%@",[chapterInfo objectForKey:kChapterId]] MD5];
        NSString *coursePath = [[NSString stringWithFormat:@"%@",[self.playCourseInfoDic objectForKey:kCourseID]] MD5];
        
        NSMutableDictionary *downLoadInfo = [[NSMutableDictionary alloc] init];
        [downLoadInfo setObject:[courseInfo objectForKey:kCourseID] forKey:kCourseID];
        [downLoadInfo setObject:[courseInfo objectForKey:kCourseName] forKey:kCourseName];
        [downLoadInfo setObject:[courseInfo objectForKey:kCourseCover] forKey:kCourseCover];
        [downLoadInfo setObject:coursePath forKey:kCoursePath];
        [downLoadInfo setObject:[videoInfo objectForKey:kVideoId] forKey:kVideoId];
        [downLoadInfo setObject:[videoInfo objectForKey:kVideoName] forKey:kVideoName];
        [downLoadInfo setObject:[videoInfo objectForKey:kVideoSort] forKey:kVideoSort];
        [downLoadInfo setObject:[videoInfo objectForKey:kVideoURL] forKey:kVideoURL];
        [downLoadInfo setObject:@(0) forKey:kVideoPlayTime];
        [downLoadInfo setObject:videoPath forKey:kVideoPath];
        [downLoadInfo setObject:[chapterInfo objectForKey:kChapterId] forKey:kChapterId];
        [downLoadInfo setObject:[chapterInfo objectForKey:kChapterName] forKey:kChapterName];
        [downLoadInfo setObject:[chapterInfo objectForKey:kChapterSort] forKey:kChapterSort];
        [downLoadInfo setObject:chapterPath forKey:kChapterPath];
        [downLoadInfo setObject:[chapterInfo objectForKey:kIsSingleChapter] forKey:kIsSingleChapter];
        [downLoadInfo setObject:downloadTaskId forKey:kDownloadTaskId];
        [downLoadInfo setObject:@(DownloadTaskStateWait) forKey:kDownloadState];
        [downLoadInfo setObject:@(1) forKey:@"type"];
        
        NSLog(@"%@", [downLoadInfo description]);
        
        [[DownloaderManager sharedManager] TY_addDownloadTask:downLoadInfo];
        
    }
    [SVProgressHUD showSuccessWithStatus:@"开始下载"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [self dissmiss];
    });
    
}

#pragma mark - table delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"downloadCell";
    
    DownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[DownloadTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell resetSubviews];
    
    NSArray *videos = [self.chapterVideoInfoArray objectAtIndex:indexPath.section];
    NSDictionary *videoDic = [videos objectAtIndex:indexPath.row];
    NSDictionary *chapterDic = [self.chapterInfoArray objectAtIndex:indexPath.section];
    
    NSString *taskId = [DownloadRquestOperation getDownloadTaskIdWitChapterId:[chapterDic objectForKey:kChapterId] andVideoId:[videoDic objectForKey:kVideoId]];
    NSString *selectedId = [NSString stringWithFormat:@"%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    cell.nameLabel.text = [videoDic objectForKey:kVideoName];
    cell.downloadDetailLabel.text = nil;
    
    NSMutableDictionary *videoD = [[NSMutableDictionary alloc]initWithDictionary:videoDic];
    [videoD setObject:@(1) forKey:@"type"];
    if ([[DownloaderManager sharedManager] isVideoIsDownloadedWithVideoId:videoD]) {
        cell.downloadDetailLabel.text = @"已下载";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if ([[DownloaderManager sharedManager] TY_isTaskAddToDownloadedQueue:[videoDic objectForKey:kVideoURL]]) {
        cell.downloadDetailLabel.text = @"已添加";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if ([[self.selectedInfoDic allValues] containsObject:selectedId]) {
        cell.downloadDetailLabel.text = nil;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.downloadDetailLabel.text = @"未下载";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DownloadTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSArray *videos = [self.chapterVideoInfoArray objectAtIndex:indexPath.section];
    NSDictionary *videoDic = [videos objectAtIndex:indexPath.row];
    NSDictionary *chapterDic = [self.chapterInfoArray objectAtIndex:indexPath.section];
    NSString *downloadTaskId = [DownloadRquestOperation getDownloadTaskIdWitChapterId:[chapterDic objectForKey:kChapterId] andVideoId:[videoDic objectForKey:kVideoId]];
    NSString *selectedId = [NSString stringWithFormat:@"%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    
    NSMutableDictionary *videoD = [[NSMutableDictionary alloc]initWithDictionary:videoDic];
    [videoD setObject:@(1) forKey:@"type"];
    if ([[DownloaderManager sharedManager] isVideoIsDownloadedWithVideoId:videoD]) {
        return;
    }
    
    if ([[DownloaderManager sharedManager] TY_isTaskAddToDownloadedQueue:[videoDic objectForKey:kVideoURL]]) {
        return;
    }
    
    if ([[self.selectedInfoDic allKeys] containsObject:downloadTaskId]) {
        [self.selectedInfoDic removeObjectForKey:downloadTaskId];
        cell.downloadDetailLabel.text = @"未下载";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        [self.selectedInfoDic setObject:selectedId forKey:downloadTaskId];
        cell.downloadDetailLabel.text = nil;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *chapterDic = [self.chapterInfoArray objectAtIndex:section];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    bgView.backgroundColor = [UIColor whiteColor];
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(10, 0, kScreenWidth, 40);
    headerLabel.font = [UIFont systemFontOfSize:15];
    headerLabel.text = [chapterDic objectForKey:kChapterName];
    headerLabel.backgroundColor = [UIColor clearColor];
    
    [bgView addSubview:headerLabel];
    return bgView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.chapterInfoArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *videos = [self.chapterVideoInfoArray objectAtIndex:section];
    return videos.count;
}

- (void)contentViewSetup
{
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kTabBarHeight) style:UITableViewStylePlain];
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.contentTableView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.downloadView = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentTableView.frame.origin.y + self.contentTableView.frame.size.height, kScreenWidth, kTabBarHeight)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, kScreenWidth, kTabBarHeight);
    [btn setTitle:@"下  载" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(startDownload) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    lineView.backgroundColor = kTableViewCellSeparatorColor;
    [btn addSubview:lineView];
    
    [self.downloadView addSubview:btn];
    
    [self.view addSubview:self.downloadView];
}

- (void)navigationViewSetup
{
    self.navigationItem.title = @"下载列表";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGB(0x333333)};
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"close-2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(dissmiss)];
    self.navigationItem.leftBarButtonItem = item;
}

@end
