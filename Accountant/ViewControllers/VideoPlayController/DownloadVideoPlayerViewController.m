//
//  DownloadVideoPlayerViewController.m
//  Accountant
//
//  Created by 阴天翔 on 2017/3/12.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DownloadVideoPlayerViewController.h"
#import "ZXVideo.h"
#import "UIMacro.h"
#import "ZXVideoPlayerController.h"
#import "CommonMacro.h"
#import "PathUtility.h"
#import "DownloaderManager.h"

@interface DownloadVideoPlayerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) ZXVideoPlayerController           *videoController;
@property (nonatomic, strong) UITableView                       *chapterTableView;


@property (nonatomic,strong) NSArray                            *chapterArray;
@property (nonatomic,strong) NSMutableArray                     *chapterVideoInfoArray;

@property (nonatomic,strong) ZXVideo                            *playingVideo;

@property (nonatomic,strong) UIView                             *titleView;



@end

@implementation DownloadVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
    self.chapterArray = [self.courseInfoDic objectForKey:kCourseChapterInfos];
    self.chapterVideoInfoArray = [[NSMutableArray alloc] init];
    for (NSDictionary *chapterDic in self.chapterArray) {
        [self.chapterVideoInfoArray addObject:[chapterDic objectForKey:kChapterVideoInfos]];
    }
    
    [self initalTable];
    
    NSArray *videoInfos = [self.chapterVideoInfoArray objectAtIndex:self.selectedSection];
    NSDictionary *videoInfo = [videoInfos objectAtIndex:self.selectedRow];
    
    NSString *docPath = [PathUtility getDocumentPath];
    NSString *path1 = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[self.courseInfoDic objectForKey:kCoursePath]]];
    NSDictionary *chapterInfo = [self.chapterArray objectAtIndex:self.selectedSection];
    NSString *path2 = [path1 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[chapterInfo objectForKey:kChapterPath]]];
    NSString *path3 = [path2 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[videoInfo objectForKey:kVideoPath]]];
    
    NSString *toPath = [docPath stringByAppendingPathComponent:@"1.mp4"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if ([fileManager fileExistsAtPath:toPath]) {
        [fileManager removeItemAtPath:toPath error:nil];
    }
    //    [fileManager copyItemAtPath:path3 toPath:toPath error:&error];
    [fileManager linkItemAtPath:path3 toPath:toPath error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    
    NSURL *pathUrl = [NSURL fileURLWithPath:toPath];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *videoInfos = [self.chapterVideoInfoArray objectAtIndex:self.selectedSection];
        NSDictionary *videoInfo = [videoInfos objectAtIndex:self.selectedRow];
        
        
        self.playingVideo = [[ZXVideo alloc] init];
        self.playingVideo.playUrl = pathUrl.absoluteString;
        self.playingVideo.title = [videoInfo objectForKey:kVideoName];
        self.playingVideo.playTime = [[videoInfo objectForKey:kVideoPlayTime] intValue];
        [self playVideo];
        
    });
    
    
}

- (void)playVideo
{
    
    if (self.videoController) {
        [self.videoController changePlayer];
    }
    self.videoController = [[ZXVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, kZXVideoPlayerOriginalWidth, kZXVideoPlayerOriginalHeight)];
    self.videoController.video = self.playingVideo;
    __weak typeof(self) weakSelf = self;
    self.videoController.videoPlayerGoBackBlock = ^{
        __strong typeof(self) strongSelf = weakSelf;
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"ZXVideoPlayer_DidLockScreen"];
        
        strongSelf.videoController = nil;
    };
    
    NSDictionary * courseInfoDic = self.courseInfoDic;
    NSDictionary * chapterInfo = [weakSelf.chapterArray objectAtIndex:weakSelf.selectedSection];
    NSArray *videoInfos = [weakSelf.chapterVideoInfoArray objectAtIndex:weakSelf.selectedSection];
    NSDictionary *videoInfo = [videoInfos objectAtIndex:weakSelf.selectedRow];
    
    
    self.videoController.videoPlayerGoBackWithPlayTimeBlock = ^(double time){
        NSLog(@"已经播放的时长 %.2f", time);
        NSMutableDictionary *downLoadInfo = [[NSMutableDictionary alloc] init];
        [downLoadInfo setObject:[courseInfoDic objectForKey:kCourseID] forKey:kCourseID];
        [downLoadInfo setObject:[courseInfoDic objectForKey:kCourseName] forKey:kCourseName];
        [downLoadInfo setObject:[courseInfoDic objectForKey:kCourseCover] forKey:kCourseCover];
        [downLoadInfo setObject:[courseInfoDic objectForKey:kCoursePath] forKey:kCoursePath];
        
        [downLoadInfo setObject:[videoInfo objectForKey:kVideoId] forKey:kVideoId];
        [downLoadInfo setObject:[videoInfo objectForKey:kVideoName] forKey:kVideoName];
        [downLoadInfo setObject:[videoInfo objectForKey:kVideoSort] forKey:kVideoSort];
        [downLoadInfo setObject:@((int)time) forKey:kVideoPlayTime];
        [downLoadInfo setObject:[videoInfo objectForKey:kVideoPath] forKey:kVideoPath];
        
        [downLoadInfo setObject:[chapterInfo objectForKey:kChapterId] forKey:kChapterId];
        [downLoadInfo setObject:[chapterInfo objectForKey:kChapterName] forKey:kChapterName];
        [downLoadInfo setObject:[chapterInfo objectForKey:kChapterSort] forKey:kChapterSort];
        [downLoadInfo setObject:[chapterInfo objectForKey:kChapterPath] forKey:kChapterPath];
        [downLoadInfo setObject:[chapterInfo objectForKey:kIsSingleChapter] forKey:kIsSingleChapter];
         
        [[DownloaderManager sharedManager] writeToDBWith:downLoadInfo];
    };
    
    [self.videoController showInView:self.view];
}

#pragma mark - table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [self.chapterVideoInfoArray objectAtIndex:section];
    return array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.chapterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"playVideoTitleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    NSInteger section = indexPath.section;
    NSArray *videoArray = [self.chapterVideoInfoArray objectAtIndex:section];
    NSDictionary *videoInfo = [videoArray objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = [videoInfo objectForKey:kVideoName];
    if (indexPath.section == self.selectedSection && indexPath.row == self.selectedRow) {
        cell.textLabel.textColor = kCommonMainColor;
        cell.imageView.image = [UIImage imageNamed:@"bluetitle.png"];
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
        cell.imageView.image = [UIImage imageNamed:@"greytitle.png"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *videoInfos = [self.chapterVideoInfoArray objectAtIndex:indexPath.section];
    NSDictionary *videoInfo = [videoInfos objectAtIndex:indexPath.row];
    
    NSString *docPath = [PathUtility getDocumentPath];
    NSString *path1 = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[self.courseInfoDic objectForKey:kCoursePath]]];
    NSDictionary *chapterInfo = [self.chapterArray objectAtIndex:indexPath.section];
    NSString *path2 = [path1 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[chapterInfo objectForKey:kChapterPath]]];
    NSString *path3 = [path2 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[videoInfo objectForKey:kVideoPath]]];
    
    NSString *toPath = [path2 stringByAppendingPathComponent:@"1.mp4"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if ([fileManager fileExistsAtPath:toPath]) {
        [fileManager removeItemAtPath:toPath error:nil];
    }
//    [fileManager copyItemAtPath:path3 toPath:toPath error:&error];
    [fileManager linkItemAtPath:path3 toPath:toPath error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    
    NSURL *pathUrl = [NSURL fileURLWithPath:toPath];
    
    self.playingVideo = [[ZXVideo alloc] init];
    self.playingVideo.playUrl = pathUrl.absoluteString;
    self.playingVideo.title = [videoInfo objectForKey:kVideoName];
    self.playingVideo.playTime = [[videoInfo objectForKey:kVideoPlayTime] intValue];
    [self playVideo];
    
    self.selectedSection = indexPath.section;
    self.selectedRow = indexPath.row;
    
    [tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *chapterDic = [self.chapterArray objectAtIndex:section];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


#pragma mark - ui setup

- (void)initalTable
{
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, kZXVideoPlayerOriginalHeight, kScreenWidth, 50)];
    self.titleView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
    titleLabel.text = @"目 录";
    titleLabel.textColor = kCommonNavigationBarColor;
    titleLabel.font = [UIFont systemFontOfSize:18];

    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, kScreenWidth, 5)];
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = bottomLineView.bounds;
    layer.startPoint = CGPointMake(0.5, 0);
    layer.endPoint = CGPointMake(0.5, 1);
    layer.colors = [NSArray arrayWithObjects:(id)kTableViewCellSeparatorColor.CGColor,(id)[UIColor whiteColor].CGColor, nil];
    layer.locations = @[@(0.3f)];
    [bottomLineView.layer addSublayer:layer];
    
    [self.titleView addSubview:titleLabel];
    [self.titleView addSubview:bottomLineView];
    [self.view addSubview:self.titleView];
    
    self.chapterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.titleView.frame.origin.y + self.titleView.frame.size.height, kZXVideoPlayerOriginalWidth, kScreenHeight - kZXVideoPlayerOriginalHeight - self.titleView.frame.size.height) style:UITableViewStylePlain];
    self.chapterTableView.dataSource = self;
    self.chapterTableView.delegate = self;
    self.chapterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.chapterTableView];
}



@end
