//
//  VideoPlayViewController.m
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "VideoPlayViewController.h"
#import "ZXVideo.h"
#import "UIMacro.h"
#import "ZXVideoPlayerController.h"
#import "CourseraManager.h"
#import "VideoPlayTableDataSource.h"
#import "CommonMacro.h"
#import "DownLoadViewController.h"
#import "AddVideoNoteViewController.h"
#import "CourseraManager.h"
#import "SVProgressHUD.h"
#import "UserManager.h"
#import "VideoManager.h"
#import "CategoryDetailTableViewCell.h"
#import "CategorySectionHeadView.h"
#import "DownloaderManager.h"
#import "DownloadRquestOperation.h"
#import "VideoFunctionView.h"
#import "CansultTeachersListView.h"
#import "BuyCourseViewController.h"
#import "VideoStateView.h"
#import "LoginViewController.h"

#import "DownloadCenterViewController.h"

@interface VideoPlayViewController ()<UITableViewDelegate,UITableViewDataSource
,CourseModule_AddCollectCourseProtocol, UIAlertViewDelegate, MFoldingSectionHeaderDelegate,UIWebViewDelegate,CourseModule_DetailCourseProtocol>

@property (nonatomic, strong)DownloadCenterViewController * vc;

@property (nonatomic, strong) ZXVideoPlayerController           *videoController;
@property (nonatomic, strong) UITableView                       *chapterTableView;
@property (nonatomic, strong) VideoPlayTableDataSource          *tableDataSource;

@property (nonatomic, strong) NSDictionary                      *playCourseInfo;

@property (nonatomic,strong) NSArray                            *chapterArray;
@property (nonatomic,strong) NSArray                            *chapterVideoInfoArray;

@property (nonatomic,strong) NSString                           *playingCourseName;
@property (nonatomic,strong) NSString                           *playingChapterName;
@property (nonatomic,strong) NSString                           *playingVideoName;
@property (nonatomic,assign) int                                 playingCourseId;
@property (nonatomic,assign) int                                 playingChapterId;
@property (nonatomic,assign) int                                 playingVideoId;

@property (nonatomic,strong) ZXVideo                            *playingVideo;

@property (nonatomic,strong) UIView                             *titleView;

@property (nonatomic,strong) UIButton                           *collectButton;
@property (nonatomic, strong)UIButton                           *cantactTeacherBtn;

@property (nonatomic, strong)VideoFunctionView                  *videoFunctionView;
@property (nonatomic, strong)CansultTeachersListView            *cansultView;

@property (nonatomic, strong)NSDictionary * currentVideoDic;

@property (nonatomic, strong) NSMutableArray *statusArray;
@property (nonatomic,assign) NSInteger               selectedSection;
@property (nonatomic,assign) NSInteger               selectedRow;


@property (nonatomic, strong)VideoStateView                        *videoStateView;

@property (nonatomic, assign)BOOL havePresent;//记录重复点击

@end

@implementation VideoPlayViewController
-(NSMutableArray *)statusArray
{
    if (!_statusArray) {
        _statusArray = [NSMutableArray array];
    }
    if (_statusArray.count) {
        if (_statusArray.count > self.chapterTableView.numberOfSections) {
            [_statusArray removeObjectsInRange:NSMakeRange(self.chapterTableView.numberOfSections - 1, _statusArray.count - self.chapterTableView.numberOfSections)];
        }else if (_statusArray.count < self.chapterTableView.numberOfSections) {
            for (NSInteger i = self.chapterTableView.numberOfSections - _statusArray.count; i < self.chapterTableView.numberOfSections; i++) {
                [_statusArray addObject:[NSNumber numberWithInteger:MFoldingSectionStateShow]];
            }
        }
    }else{
        for (NSInteger i = 0; i < self.chapterTableView.numberOfSections; i++) {
            [_statusArray addObject:[NSNumber numberWithInteger:MFoldingSectionStateShow]];
        }
    }
    return _statusArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.havePresent = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (!self.infoDic) {
        self.view.backgroundColor = [UIColor blackColor];
        self.chapterArray = [[CourseraManager sharedManager] getPlayChapterInfo];
        self.chapterVideoInfoArray = [[CourseraManager sharedManager] getPlayChapterVideoInfo];
        self.playCourseInfo = [[CourseraManager sharedManager] getPlayCourseInfo];
        self.playingCourseId = [[self.playCourseInfo objectForKey:kCourseID] intValue];
        self.playingCourseName = [self.playCourseInfo objectForKey:kCourseName];
        [self initalTable];
    }
    /*
     
     */
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haveLogin:) name:kNotificationOfLoginSuccess object:nil];
}

- (void)playVideo
{
    int tableSelectSection = 0;
    int tableSelectRow = 0;
    
    if (self.isPlayFromLoacation) {
        tableSelectSection = [self getPlayLocationSection];
        tableSelectRow = [self getPlayLocationRowWithSection:tableSelectSection];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary *videoInfo = [NSDictionary dictionary];
        if (self.infoDic) {
            videoInfo = self.infoDic;
        }else
        {
            NSDictionary *chapterInfo = [self.chapterArray objectAtIndex:tableSelectSection];
            NSArray *videoInfos = [self.chapterVideoInfoArray objectAtIndex:tableSelectSection];
            videoInfo = [videoInfos objectAtIndex:tableSelectRow];
            self.playingChapterId = [[chapterInfo objectForKey:kChapterId] intValue];
            self.playingChapterName = [chapterInfo objectForKey:kChapterName];
        }
        
        self.playingVideoId = [[videoInfo objectForKey:kVideoId] intValue];
        self.playingVideoName = [videoInfo objectForKey:kVideoName];
        
        self.playingVideo = [[ZXVideo alloc] init];
        self.playingVideo.playUrl = [videoInfo objectForKey:kVideoURL];
        self.playingVideo.title = [videoInfo objectForKey:kVideoName];
        
        NSLog(@"--- %@", videoInfo);
        
        [self playVideoInfo:videoInfo];
        
        self.tableDataSource.selectedRow = tableSelectRow;
        self.tableDataSource.selectedSection = tableSelectSection;
        self.selectedRow = tableSelectRow;
        self.selectedSection = tableSelectSection;
        [self.chapterTableView reloadData];
        
    });
}

- (void)haveLogin:(NSNotification *)notification
{
    if ([[self.playCourseInfo objectForKey:kCanWatch] intValue] == 0) {
        self.videoStateView.hidden = NO;
        self.videoStateView.state = VideoState_noJurisdiction;
    }else
    {
        [self.videoStateView removeFromSuperview];
    }
    
    [[CourseraManager sharedManager] didRequestDetailCourseWithCourseID:[[self.playCourseInfo objectForKey:kCourseID] intValue] withNotifiedObject:self];
}

- (void)playVideoInfo:(NSDictionary *)videoInfo;
{
    if (self.videoController) {
        [self.videoController changePlayer];
    }
    self.currentVideoDic = videoInfo;
    if (!self.videoController) {
        self.videoController = [[ZXVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, kZXVideoPlayerOriginalWidth, kZXVideoPlayerOriginalHeight)];
    }
    NSDictionary * dic = [[VideoManager sharedManager]getCurrentVideoInfoWithVideoId:[videoInfo objectForKey:kVideoId]];
    if ([dic objectForKey:kVideoPlayTime]) {
        self.playingVideo.playTime = [[dic objectForKey:kVideoPlayTime] intValue];
    }else
    {
        self.playingVideo.playTime = 0;
    }
    self.videoController.video = self.playingVideo;
    
    __weak typeof(self) weakSelf = self;
    self.videoController.videoPlayerGoBackBlock = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.videoController stop];
        strongSelf.videoController = nil;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"ZXVideoPlayer_DidLockScreen"];
        
    };
    self.videoController.videoPlayerGoBackWithPlayTimeBlock = ^(double time){
        NSLog(@"time = %.0f  ** %@", time,[weakSelf.currentVideoDic description]);
        
        NSMutableDictionary * videoInfodic = [NSMutableDictionary dictionary];
        [videoInfodic setValue:[weakSelf.currentVideoDic objectForKey:kVideoId] forKey:kVideoId];
        [videoInfodic setValue:@(time) forKey:kVideoPlayTime];
        [videoInfodic setValue:[weakSelf.currentVideoDic objectForKey:kVideoName] forKey:kVideoName];
        [videoInfodic setValue:[weakSelf.currentVideoDic objectForKey:kVideoURL] forKey:kVideoURL];
        [[VideoManager sharedManager]writeToDB:videoInfodic];
    };
    
    self.videoController.informalBlock = ^{
        NSLog(@"试看结束，请判断是不是正式学员");
        
        if ([[weakSelf.playCourseInfo objectForKey:kCanWatch] intValue] == 0) {
            
            weakSelf.videoStateView.state = VideoState_shikanEnd;
            [weakSelf.view addSubview:weakSelf.videoStateView];
            weakSelf.videoController.video = nil;
            [weakSelf.videoController stop];
            weakSelf.videoController = nil;
        }
    };
    
    [self savePlayingInfo];
    [self.videoController showInView:self.view];
    [self.view insertSubview:self.videoController.view belowSubview:self.videoStateView];
}

- (void)addHistory:(NSDictionary *)info
{
    [[CourseraManager sharedManager] didRequestAddCourseHistoryWithInfo:info];
}

- (void)savePlayingInfo
{
    [[CourseraManager sharedManager] getPlayingInfo].courseId = self.playingCourseId;
    [[CourseraManager sharedManager] getPlayingInfo].chapterId = self.playingChapterId;
    [[CourseraManager sharedManager] getPlayingInfo].videoId = self.playingVideoId;
    [[CourseraManager sharedManager] getPlayingInfo].courseName = self.playingCourseName;
    [[CourseraManager sharedManager] getPlayingInfo].chapterName = self.playingChapterName;
    [[CourseraManager sharedManager] getPlayingInfo].videoName = self.playingVideoName;
}

- (void)downLoadVides
{
//    if ([[UserManager sharedManager] getUserLevel] != 3) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您是试用用户，请升级成正式用户后下载观看" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
//        [alert show];
//    }else{
//    
//    }
    [self.videoController pausePlay];
    DownLoadViewController *vc = [[DownLoadViewController alloc] init];
    vc.chapterInfoArray = self.chapterArray;
    vc.chapterVideoInfoArray = self.chapterVideoInfoArray;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)addNote
{
    [self.videoController pausePlay];
}

- (void)collectCourse
{
    [SVProgressHUD show];
    int courseId = 0;
    if (self.infoDic) {
        courseId = [[self.infoDic objectForKey:kVideoId] intValue];
    }else
    {
        courseId = [[self.playCourseInfo objectForKey:kCourseID] intValue];
    }
    
    [[CourseraManager sharedManager] didRequestAddCollectCourseWithCourseId:courseId andNotifiedObject:self];
}

- (void)writeNote
{
    [self.videoController pausePlay];
    AddVideoNoteViewController *vc = [[AddVideoNoteViewController alloc] init];
    
    NSInteger sec = self.selectedSection;
    NSInteger row = self.selectedRow;
    NSDictionary *chapterInfo = [self.chapterArray objectAtIndex:sec];
    NSDictionary *videoInfo = [[self.chapterVideoInfoArray objectAtIndex:sec] objectAtIndex:row];
    NSDictionary *courseInfo = self.playCourseInfo;
    
    vc.courseName = [courseInfo objectForKey:kCourseName];
    vc.chapterName = [chapterInfo objectForKey:kChapterName];
    vc.videoName = [videoInfo objectForKey:kVideoName];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (int)getPlayLocationSection
{
    for (int i = 0; i < self.chapterArray.count; i++) {
        NSDictionary *dic = [self.chapterArray objectAtIndex:i];
        if ([[dic objectForKey:kChapterId] intValue] == self.beginChapterId) {
            return i;
        }
    }
    return 0;
}

- (int)getPlayLocationRowWithSection:(int)section
{
    NSArray *videoInfos = [self.chapterVideoInfoArray objectAtIndex:section];
    for (int i = 0; i < videoInfos.count; i++) {
        NSDictionary *videoInfo = [videoInfos objectAtIndex:i];
        if ([[videoInfo objectForKey:kVideoId] intValue] == self.beginVideoId) {
            return i;
        }
    }
    return 0;
}

#pragma mark - add course delegate
- (void)didRequestAddCollectCourseSuccessed
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    [self.collectButton setTitle:@"已收藏" forState:UIControlStateNormal];
    [self.collectButton setTitleColor:kCommonMainTextColor_100 forState:UIControlStateNormal];
    [self.collectButton removeTarget:self action:@selector(collectCourse) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didRequestAddCollectCourseFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - ui

- (void)initalTable
{
    __weak typeof(self)weakSelf = self;
    self.videoStateView = [[VideoStateView alloc] initWithFrame:CGRectMake(0, 0, kZXVideoPlayerOriginalWidth, kZXVideoPlayerOriginalHeight)];
    [self.view addSubview:self.videoStateView];
    [self.videoStateView resetWithInfoDic:self.playCourseInfo];
    
    self.videoStateView.loginClickBlock = ^(VideoState videoState, NSDictionary *infoDic) {
        
        switch (videoState) {
            case VideoState_notLogin:
            {
                LoginViewController *login = [[LoginViewController alloc] init];
                
                UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:login];
                
                [weakSelf presentViewController:nav animated:YES completion:nil];
            }
                break;
            case VideoState_noJurisdiction:
            {
                [weakSelf playVideo];
                [weakSelf.videoStateView removeFromSuperview];
            }
                break;
            case VideoState_haveJurisdiction:
            {
                
            }
                break;
                
            default:
                break;
        }
        
    };
    self.videoStateView.BackClickBlock = ^{
        [weakSelf.videoController stop];
        weakSelf.videoController = nil;
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    if (![[UserManager sharedManager] isUserLogin]) {
        self.videoStateView.hidden = NO;
    }else
    {
        self.videoStateView.hidden = YES;
        if ([[self.playCourseInfo objectForKey:kCanWatch] intValue] == 0) {
            self.videoStateView.hidden = NO;
            self.videoStateView.state = VideoState_noJurisdiction;
        }else
        {
            [self playVideo];
        }
    }
    
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, kZXVideoPlayerOriginalHeight, kScreenWidth, 50)];
    self.titleView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
    titleLabel.text = @"目 录";
    titleLabel.textColor = kMainTextColor;
    titleLabel.font = [UIFont systemFontOfSize:18];
    
    UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downloadButton.frame = CGRectMake(kScreenWidth - 70, 10, 60, 30);
    [downloadButton setTitle:@"下载" forState:UIControlStateNormal];
    downloadButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [downloadButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [downloadButton addTarget:self action:@selector(downLoadVides) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *noteButton = [UIButton buttonWithType: UIButtonTypeCustom];
    noteButton.frame = CGRectMake(kScreenWidth - 70, 10, 60, 30);
    [noteButton setTitle:@"笔记" forState:UIControlStateNormal];
    noteButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [noteButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [noteButton addTarget:self action:@selector(writeNote) forControlEvents:UIControlEventTouchUpInside];
    
    self.collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collectButton.frame = CGRectMake(kScreenWidth - 130, 10, 60, 30);
    self.collectButton.titleLabel.font =[UIFont systemFontOfSize:15];
    if ([[self.playCourseInfo objectForKey:kCourseIsCollect] boolValue]) {
        [self.collectButton setTitle:@"已收藏" forState:UIControlStateNormal];
        [self.collectButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    }else{
        [self.collectButton setTitle:@"收藏" forState:UIControlStateNormal];
        [self.collectButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [self.collectButton addTarget:self action:@selector(collectCourse) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    UIView *separeLine1 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 70, 10, 1, 25)];
    separeLine1.backgroundColor = kTableViewCellSeparatorColor;
    
    UIView *separeLine2 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 130, 10, 1, 25)];
    separeLine2.backgroundColor = kTableViewCellSeparatorColor;

    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, kScreenWidth, 5)];
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = bottomLineView.bounds;
    layer.startPoint = CGPointMake(0.5, 0);
    layer.endPoint = CGPointMake(0.5, 1);
    layer.colors = [NSArray arrayWithObjects:(id)kTableViewCellSeparatorColor.CGColor,(id)[UIColor whiteColor].CGColor, nil];
    layer.locations = @[@(0.3f)];
    [bottomLineView.layer addSublayer:layer];
    
    [self.titleView addSubview:titleLabel];
    [self.titleView addSubview:noteButton];
    [self.titleView addSubview:self.collectButton];
    [self.titleView addSubview:separeLine1];
//    [self.titleView addSubview:separeLine2];
//    [self.titleView addSubview:downloadButton];
    [self.titleView addSubview:bottomLineView];
    [self.view addSubview:self.titleView];
    
    self.chapterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.titleView.frame.origin.y + self.titleView.frame.size.height, kZXVideoPlayerOriginalWidth, kScreenHeight - kZXVideoPlayerOriginalHeight - self.titleView.frame.size.height) style:UITableViewStylePlain];
    [self.chapterTableView registerClass:[CategoryDetailTableViewCell class] forCellReuseIdentifier:@"playVideoTitleCell"];

    self.chapterTableView.dataSource = self;
    self.chapterTableView.delegate = self;
    self.chapterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.chapterTableView];
    
    // 联系老师
    if (![[self.playCourseInfo objectForKey:kCanWatch] intValue]) {
        
        BOOL isBuy = NO;
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] && [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
            isBuy = YES;
        }
        
        self.videoFunctionView = [[VideoFunctionView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50) andIsBuy:isBuy];
        [self.videoFunctionView refreshWithInfoDic:self.playCourseInfo];
        if (isBuy) {
            self.chapterTableView.hd_height -= 50;
            [self.view addSubview:self.videoFunctionView];
        }
        self.videoFunctionView.cansultBlock = ^{
            [weakSelf.videoController pausePlay];
            AppDelegate * delegate = [UIApplication sharedApplication].delegate;
            weakSelf.cansultView.teachersArray  = [[UserManager sharedManager] getAssistantList];
            [delegate.window addSubview:weakSelf.cansultView];
        };
        
        self.videoFunctionView.buyBlock = ^{
            BuyCourseViewController * buyVC = [[BuyCourseViewController alloc]init];
            buyVC.infoDic = weakSelf.playCourseInfo;
            [weakSelf.videoController pausePlay];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:buyVC];
            [weakSelf presentViewController:nav animated:YES completion:nil];
        };
    }
    
    self.cansultView = [[CansultTeachersListView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andTeachersArr:[[UserManager sharedManager] getAssistantList]];
    self.cansultView.dismissBlock = ^{
        [weakSelf.cansultView removeFromSuperview];
    };
    self.cansultView.cansultBlock = ^(NSDictionary *infoDic) {
        [weakSelf cantactTeacherAction:infoDic];
    };
    
}

#pragma mark - cantactTeacher
- (void)cantactTeacherAction:(NSDictionary *)teacherInfo
{
    NSString  *qqNumber=[teacherInfo objectForKey:@"assistantQQ"];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectZero];
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qqNumber]];
        
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        webView.delegate = self;
        [webView loadRequest:request];
        [self.view addSubview:webView];
    }else
    {
        [SVProgressHUD showErrorWithStatus:@"对不起，您还没安装QQ"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![[UserManager sharedManager] isUserLogin]) {
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }
    
    if ([[self.playCourseInfo objectForKey:kCanWatch] intValue] == 0) {
        [SVProgressHUD showErrorWithStatus:@"暂无观看权限"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }
    
    NSDictionary *chapterDic = [self.chapterArray objectAtIndex:indexPath.section];
    NSArray *videoInfos = [self.chapterVideoInfoArray objectAtIndex:indexPath.section];
    NSDictionary *videoInfo = [videoInfos objectAtIndex:indexPath.row];
    
    NSDictionary *history;
    if ([[chapterDic objectForKey:kIsSingleChapter] boolValue] == YES) {
        history = @{kCourseID:[self.playCourseInfo objectForKey:kCourseID],
                    kChapterId:[chapterDic objectForKey:kChapterId],
                    kVideoId:@(0)};
    }else{
        history = @{kCourseID:[self.playCourseInfo objectForKey:kCourseID],
                    kChapterId:[chapterDic objectForKey:kChapterId],
                    kVideoId:[videoInfo objectForKey:kVideoId]};
    }
    
    self.playingChapterId = [[chapterDic objectForKey:kChapterId] intValue];
    self.playingChapterName = [chapterDic objectForKey:kChapterName];
    self.playingVideoId = [[videoInfo objectForKey:kVideoId] intValue];
    self.playingVideoName = [videoInfo objectForKey:kVideoName];
    [self addHistory:history];
    
    self.playingVideo = [[ZXVideo alloc] init];
    self.playingVideo.playUrl = [videoInfo objectForKey:kVideoURL];
    self.playingVideo.title = [videoInfo objectForKey:kVideoName];
    
    [self playVideoInfo:videoInfo];
    
    self.selectedSection = indexPath.section;
    self.selectedRow = indexPath.row;
    
    [tableView reloadData];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *chapterDic = [self.chapterArray objectAtIndex:section];
    
    CategorySectionHeadView * view = [[CategorySectionHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64) withTag:section];
    BOOL currentIsOpen = ((NSNumber *)self.statusArray[section]).boolValue;
    
    MFoldingSectionState state = 0;
    if (currentIsOpen) {
        state = MFoldingSectionStateShow;
    }else
    {
        state = MFoldingSectionStateFlod;
    }
    
    [view setupVideoWithBackgroundColor:UIRGBColor(245, 245, 245) titleString:[chapterDic objectForKey:kChapterName] titleColor:kCommonMainTextColor_50 titleFont:kMainFont arrowImage:[UIImage imageNamed:@"tiku_plus"] learnImage:[UIImage imageNamed:@"tiku_text"] arrowPosition:MFoldingSectionHeaderArrowPositionLeft sectionState:state];
    view.tapDelegate = self;
    view.lineView.hidden = YES;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (((NSNumber *)self.statusArray[section]).integerValue == MFoldingSectionStateShow) {
        NSArray *array = [self.chapterVideoInfoArray objectAtIndex:section];
        return array.count;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    footerView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    footerView.layer.cornerRadius = 3;
    footerView.layer.masksToBounds = YES;
    footerView.layer.borderColor = UIColorFromRGB(0xeeeeee).CGColor;
    footerView.layer.borderWidth = 1;
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"playVideoTitleCell";
    CategoryDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    NSInteger section = indexPath.section;
    NSArray *videoArray = [self.chapterVideoInfoArray objectAtIndex:section];
    NSDictionary *videoInfo = [videoArray objectAtIndex:indexPath.row];
    
    NSDictionary * chapterDic = [self.chapterArray objectAtIndex:indexPath.section];
    NSString *taskId = [DownloadRquestOperation getDownloadTaskIdWitChapterId:[chapterDic objectForKey:kChapterId] andVideoId:[videoInfo objectForKey:kVideoId]];
    
    NSMutableDictionary * mVideoInfo = [[NSMutableDictionary alloc]initWithDictionary:videoInfo];
    
    [mVideoInfo setObject:@(0) forKey:@"isDownload"];
    [mVideoInfo setObject:@(1) forKey:@"type"];
    
    if ([[DownloaderManager sharedManager] isVideoIsDownloadedWithVideoId:mVideoInfo]) {
        [mVideoInfo setObject:@(1) forKey:@"isDownload"];
    }
    
    if ([[DownloaderManager sharedManager] isTaskAddToDownloadedQueue:taskId]) {
        [mVideoInfo setObject:@(1) forKey:@"isDownload"];
    }
    
    cell.cellType = CellType_video;
    if (indexPath.row == videoArray.count - 1) {
        [cell resetisLast:YES withDicInfo:mVideoInfo];
    }else
    {
        [cell resetisLast:NO withDicInfo:mVideoInfo];
    }
    
    if (indexPath.section == self.selectedSection && self.selectedRow == indexPath.row) {
        cell.titleLabel.textColor = UIColorFromRGB(0xff740e);
    }else
    {
        cell.titleLabel.textColor = kCommonMainTextColor_50;
    }
    
    if ([[self.playCourseInfo objectForKey:kCanWatch] intValue] == 0) {
        if (indexPath.row == 0 && indexPath.section == 0) {
            [cell shikanAction];
        }else
        {
            [cell lockVideo];
        }
    }
    
    __weak typeof(self) weakSelf = self;
    cell.downloadBlock = ^(VideoDownloadState downloadState){
        if (![[UserManager sharedManager] isUserLogin]) {
            [SVProgressHUD showErrorWithStatus:@"请先登录"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            return;
        }
        
        
        if ([[weakSelf.playCourseInfo objectForKey:kCourseCanDownLoad] intValue] == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"暂无下载权限，请升级套餐或购买课程" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert show];
        }else{
            
            if (downloadState == DownloadState_unDownload) {
                [weakSelf downLoadVide:indexPath];
            }else{
                [weakSelf pushDownloadCenter];
            }
        }
    };
    
    cell.shikanBlock = ^{
        [weakSelf playVideo];
        [weakSelf.videoStateView removeFromSuperview];
    };
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.chapterArray.count;
}

#pragma mark - YUFoldingSectionHeaderDelegate

-(void)MFoldingSectionHeaderTappedAtIndex:(NSInteger)index
{
    BOOL currentIsOpen = ((NSNumber *)self.statusArray[index]).boolValue;
    
    [self.statusArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:!currentIsOpen]];
    
    NSArray *array = [self.chapterVideoInfoArray objectAtIndex:index ];
    NSInteger numberOfRow = array.count;
    NSMutableArray *rowArray = [NSMutableArray array];
    if (numberOfRow) {
        for (NSInteger i = 0; i < numberOfRow; i++) {
            [rowArray addObject:[NSIndexPath indexPathForRow:i inSection:index]];
        }
    }
    if (rowArray.count) {
        if (currentIsOpen) {
            [self.chapterTableView deleteRowsAtIndexPaths:[NSArray arrayWithArray:rowArray] withRowAnimation:UITableViewRowAnimationTop];
        }else{
            [self.chapterTableView insertRowsAtIndexPaths:[NSArray arrayWithArray:rowArray] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
}

#pragma mark - CourseDetail delegate
- (void)didRequestCourseDetailSuccessed
{
    [SVProgressHUD dismiss];
    self.chapterArray = [[CourseraManager sharedManager] getPlayChapterInfo];
    self.chapterVideoInfoArray = [[CourseraManager sharedManager] getPlayChapterVideoInfo];
    self.playCourseInfo = [[CourseraManager sharedManager] getPlayCourseInfo];
    self.playingCourseId = [[self.playCourseInfo objectForKey:kCourseID] intValue];
    self.playingCourseName = [self.playCourseInfo objectForKey:kCourseName];
    [self.chapterTableView reloadData];
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

#pragma mark - dowmload
- (void)downLoadVide:(NSIndexPath*)indexpath
{
    int sec = (int)indexpath.section;
    int row = (int)indexpath.row;
    NSDictionary *chapterInfo = [self.chapterArray objectAtIndex:sec];
    NSDictionary *videoInfo = [[self.chapterVideoInfoArray objectAtIndex:sec] objectAtIndex:row];
    NSDictionary *courseInfo = self.playCourseInfo;
    NSString *downloadTaskId = [DownloadRquestOperation getDownloadTaskIdWitChapterId:[chapterInfo objectForKey:kChapterId] andVideoId:[videoInfo objectForKey:kVideoId]];
    
    if ([[DownloaderManager sharedManager] isVideoIsDownloadedWithVideoId:videoInfo] || [[DownloaderManager sharedManager] TY_isTaskAddToDownloadedQueue:[videoInfo objectForKey:kVideoURL]]) {
        
        [self pushDownloadCenter];
        return;
    }
    
    NSString *videoPath = [[NSString stringWithFormat:@"%@",[videoInfo objectForKey:kVideoId]] MD5];
    NSString *chapterPath = [[NSString stringWithFormat:@"%@",[chapterInfo objectForKey:kChapterId]] MD5];
    NSString *coursePath = [[NSString stringWithFormat:@"%@",[courseInfo objectForKey:kCourseID]] MD5];
    
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

    [SVProgressHUD showSuccessWithStatus:@"开始下载"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [self pushDownloadCenter];
    });
}

- (void)pushDownloadCenter
{
    if (self.havePresent) {
        self.havePresent = NO;
        [self.videoController pausePlay];
        if (!self.vc) {
            self.vc = [[DownloadCenterViewController alloc]init];
        }
        self.vc.isPresent = YES;
        CATransition *animation = [CATransition animation];
        animation.duration = 0.3;
        
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionReveal;
        animation.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:animation forKey:nil];
        
        [self presentViewController:self.vc animated:NO completion:nil];
    }
}

- (void)dismissStiop
{
    [self.videoController backstop];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationOfLoginSuccess object:nil];
    NSLog(@"课程界面销毁了*******");
}

@end
