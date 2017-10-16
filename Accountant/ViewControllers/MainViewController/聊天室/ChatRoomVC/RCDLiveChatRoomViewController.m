//
//  ChatRoomViewController.m
//  RongChatRoomDemo
//
//  Created by 杜立召 on 16/4/6.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import "RCDLiveChatRoomViewController.h"
#import "RCDLiveMessageCell.h"
#import "RCDLiveTextMessageCell.h"
#import "RCDLiveGiftMessageCell.h"
#import "RCDLiveGiftMessage.h"
#import "RCDLiveTipMessageCell.h"
#import "RCDLiveMessageModel.h"
#import "RCDLive.h"
#import "RCDLiveCollectionViewHeader.h"
#import "RCDLiveKitUtility.h"
#import "RCDLiveKitCommonDefine.h"
#import <RongIMLib/RongIMLib.h>
#import <objc/runtime.h>
#import "RCDLiveTipMessageCell.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "RCDLivePortraitViewCell.h"
#import "LivingCourseListView.h"
#import "CourseraManager.h"
#import "LoginViewController.h"

#import "LivingStateView.h"
//#import "KSYLivePlaying.h"
//#import "UCLOUDLivePlaying.h"
//#import "LELivePlaying.h"
//#import "QINIULivePlaying.h"
//#import "QCLOUDLivePlaying.h"

#import "LivingChatViewController.h"

#import "UIView+RCDDanmaku.h"
#import "RCDDanmaku.h"
#import "RCDDanmakuManager.h"

#import "ZXVideo.h"
#import "ZXVideoPlayerController.h"
#import "HYSegmentedControl.h"

#define kRandomColor [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1]

//输入框的高度
#define MinHeight_InputView 50.0f
#define kBounds [UIScreen mainScreen].bounds.size



@interface RCDLiveChatRoomViewController () <
UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout, RCDLiveMessageCellDelegate, UIGestureRecognizerDelegate,
UIScrollViewDelegate, UINavigationControllerDelegate,RCTKInputBarControlDelegate,RCConnectionStatusChangeDelegate,UIAlertViewDelegate,HYSegmentedControlDelegate,UserModule_OrderLivingCourseProtocol,CourseModule_LivingSectionDetail>

@property(nonatomic, strong)RCDLiveCollectionViewHeader *collectionViewHeader;

@property (nonatomic, strong) ZXVideoPlayerController           *videoController;
@property (nonatomic,strong) ZXVideo                            *playingVideo;
@property (nonatomic, strong)LivingStateView                        *stateImageView;
@property (nonatomic, strong)UIButton                           *backBT;
@property (nonatomic, strong)HYSegmentedControl * segmentC;
@property (nonatomic, strong)LivingChatViewController * chatVC;
@property (nonatomic, strong)LivingCourseListView              *livingListView;


/**
 *  存储长按返回的消息的model
 */
@property(nonatomic, strong) RCDLiveMessageModel *longPressSelectedModel;

/**
 *  是否需要滚动到底部
 */
@property(nonatomic, assign) BOOL isNeedScrollToButtom;

/**
 *  是否正在加载消息
 */
@property(nonatomic) BOOL isLoading;

/**
 *  会话名称
 */
@property(nonatomic,copy) NSString *navigationTitle;

/**
 *  点击空白区域事件
 */
@property(nonatomic, strong) UITapGestureRecognizer *resetBottomTapGesture;

/**
 *  金山视频播放器manager
 */
//@property(nonatomic, strong) KSYLivePlaying *livePlayingManager;

/**
 *  直播互动文字显示
 */
@property(nonatomic,strong) UIView *titleView ;

/**
 *  播放器view
 */
@property(nonatomic,strong) UIView *liveView;

/**
 *  底部显示未读消息view
 */
@property (nonatomic, strong) UIView *unreadButtonView;
@property(nonatomic, strong) UILabel *unReadNewMessageLabel;

/**
 *  滚动条不在底部的时候，接收到消息不滚动到底部，记录未读消息数
 */
@property (nonatomic, assign) NSInteger unreadNewMsgCount;

/**
 *  当前融云连接状态
 */
@property (nonatomic, assign) RCConnectionStatus currentConnectionStatus;

/**
 *  返回按钮
 */
@property (nonatomic, strong) UIButton *backBtn;

/**
 *  鲜花按钮
 */
@property(nonatomic,strong)UIButton *flowerBtn;

/**
 *  评论按钮
 */
@property(nonatomic,strong)UIButton *feedBackBtn;

/**
 *  掌声按钮
 */
@property(nonatomic,strong)UIButton *clapBtn;

@property(nonatomic,strong)UICollectionView *portraitsCollectionView;

@property(nonatomic,strong)NSMutableArray *userList;

@property (nonatomic, strong)UILocalNotification *localNotice;
@property (nonatomic, strong)NSTimer * timer;

@property (nonatomic, strong)NSDictionary *selectOrderLivingSectionInfoDic;// 预约课

@end

/**
 *  文本cell标示
 */
static NSString *const rctextCellIndentifier = @"rctextCellIndentifier";

/**
 *  小灰条提示cell标示
 */
static NSString *const RCDLiveTipMessageCellIndentifier = @"RCDLiveTipMessageCellIndentifier";

/**
 *  礼物cell标示
 */
static NSString *const RCDLiveGiftMessageCellIndentifier = @"RCDLiveGiftMessageCellIndentifier";

@implementation RCDLiveChatRoomViewController


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self rcinit];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self rcinit];
    }
    return self;
}

- (void)rcinit {
    self.conversationDataRepository = [[NSMutableArray alloc] init];
    self.userList = [[NSMutableArray alloc] init];
    self.conversationMessageCollectionView = nil;
    self.targetId = nil;
    [self registerNotification];
    self.defaultHistoryMessageCountOfChatRoom = 10;
//    if ([[UserManager sharedManager] isUserLogin]) {
//        [[RCIMClient sharedRCIMClient]setRCConnectionStatusChangeDelegate:self];
//    }
}

/**
 *  注册监听Notification
 */
- (void)registerNotification {
    //注册接收消息
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCDLiveKitDispatchMessageNotification
     object:nil];
}

/**
 *  注册cell
 *
 *  @param cellClass  cell类型
 *  @param identifier cell标示
 */
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    [self.conversationMessageCollectionView registerClass:cellClass
                               forCellWithReuseIdentifier:identifier];
}

/**
 *  页面加载
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    //默认进行弹幕缓存，不过量加载弹幕，如果想要同时大批量的显示弹幕，设置为yes，弹幕就不会做弹道检测和缓存
    RCDanmakuManager.isAllowOverLoad = NO;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.userList = [NSMutableArray array];
    //初始化UI
    
    [self initializedSubViews];
    [self segmentSetup];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary *videoInfo = [NSDictionary dictionary];
        
        if (!self.playingVideo) {
            self.playingVideo = [[ZXVideo alloc] init];
        }
        if ([[UserManager sharedManager] isUserLogin]) {
            if ([[self.infoDic objectForKey:kLivingState] intValue] == 3) {
                if (!self.isLivingCourse) {
                    self.playingVideo.playUrl = [self.infoDic objectForKey:kPlayBackUrl];
                }
            }else{
                self.playingVideo.playUrl = [self.infoDic objectForKey:kCourseURL];
            }
        }
        self.playingVideo.title = [self.infoDic objectForKey:kCourseName];
        
        NSLog(@"--- %@", videoInfo);
        if ([[self.infoDic objectForKey:kIsLivingCourseFree] intValue] == 0 && [[self.infoDic objectForKey:kHaveJurisdiction] intValue] == 0) {
            [SVProgressHUD showErrorWithStatus:@"暂无观看权限"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                self.playingVideo.playUrl = @"";
            });
        }
        [self playVideo:videoInfo];
        [self setPlayStateViewIsLogin:YES];
    });
    
    [self.portraitsCollectionView registerClass:[RCDLivePortraitViewCell class] forCellWithReuseIdentifier:@"portraitcell"];
    __weak RCDLiveChatRoomViewController *weakSelf = self;
    
    //聊天室类型进入时需要调用加入聊天室接口，退出时需要调用退出聊天室接口
    if (ConversationType_CHATROOM == self.conversationType && [[UserManager sharedManager] isUserLogin]) {
        
        [[RCIMClient sharedRCIMClient]
         joinChatRoom:self.targetId
         messageCount:self.defaultHistoryMessageCountOfChatRoom
         success:^{
             dispatch_async(dispatch_get_main_queue(), ^{
//                 self.livePlayingManager = [[KSYLivePlaying alloc] initPlaying:self.contentURL];
                 //                 self.livePlayingManager = [[LELivePlaying alloc] initPlaying:@"201604183000000z4"];
                 //                 self.livePlayingManager = [[QINIULivePlaying alloc] initPlaying:@"rtmp://live.hkstv.hk.lxdns.com/live/hks"];
                 //                 self.livePlayingManager = [[QCLOUDLivePlaying alloc] initPlaying:@"http://2527.vod.myqcloud.com/2527_117134a2343111e5b8f5bdca6cb9f38c.f20.mp4"];
                 [self initializedLiveSubViews];
//                 [self.livePlayingManager startPlaying];
                 RCInformationNotificationMessage *joinChatroomMessage = [[RCInformationNotificationMessage alloc]init];
                 joinChatroomMessage.message = [NSString stringWithFormat: @"%@加入了聊天室",[RCDLive sharedRCDLive].currentUserInfo.name];
//                 [self sendMessage:joinChatroomMessage pushContent:nil];
             });
         }
         error:^(RCErrorCode status) {
             
             NSLog(@"%ld",(long)status);
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (status == KICKED_FROM_CHATROOM) {
                     [weakSelf loadErrorAlert:NSLocalizedStringFromTable(@"JoinChatRoomRejected", @"RongCloudKit", nil)];
                 } else {
                     [weakSelf loadErrorAlert:NSLocalizedStringFromTable(@"JoinChatRoomFailed", @"RongCloudKit", nil)];
                 }
             });
         }];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(livingStart:) name:kLocalNitificationOfLivingStart object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haveLogin:) name:kNotificationOfLoginSuccess object:nil];
    
    [[NSUserDefaults standardUserDefaults]setObject:[self.infoDic objectForKey:kAssistantID] forKey:kAssistantID];
    
}


- (void)playVideo:(NSDictionary *)videoInfo;
{
    
    if (!self.videoController) {
        self.videoController = [[ZXVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, kZXVideoPlayerOriginalWidth, kZXVideoPlayerOriginalHeight)];
    }
    
    self.videoController.video = self.playingVideo;
    
    __weak typeof(self) weakSelf = self;
    self.videoController.videoPlayerGoBackBlock = ^{
        __strong typeof(self) strongSelf = weakSelf;
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"退出聊天室？" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertview show];
        [weakSelf quitConversationViewAndClear];
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"ZXVideoPlayer_DidLockScreen"];
        
        strongSelf.videoController = nil;
    };
    
    [self.videoController showInView:self.view];
    
}

#pragma mark - LocalNotification
- (void)addLocalNotification:(NSDictionary *)infoDic
{
    
    NSInteger date = [self getDate:infoDic];
    
    NSLog(@"******%ld",(long)date);
    
    // 1. 创建本地通知
    if (self.localNotice) {
        return;
    }
    self.localNotice = [[UILocalNotification alloc] init];
    
    // 1.1 设置通知内容
    _localNotice.alertBody = @"直播课开始啦";
    
    // 1.2 设置通知发送时间
    _localNotice.fireDate = [NSDate dateWithTimeIntervalSinceNow:date];
    
    // 1.3 设置通知的时区(使用默认时区就可以)
    _localNotice.timeZone = [NSTimeZone defaultTimeZone];
    
    
    /** --------额外属性补充---------- */
    // 设置重复周期(最小重复周期是一分钟)
    //    localNotice.repeatInterval = NSCalendarUnitMinute;
    
    
    // 2. 发送本地通知
    // 通知是一个应用程序级别操作
    //    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotice]; // 立即发送一个通知
    [[UIApplication sharedApplication] scheduleLocalNotification:_localNotice]; // 计划发送一个通知
}

- (void)livingStart:(NSNotification *)notification
{
    if (!self.timer) {
        
        __weak typeof(self)weakSelf = self;
        
        self.timer = [NSTimer timerWithTimeInterval:1 repeats:NO block:^(NSTimer * _Nonnull timer) {
            NSDictionary * infoDic = notification.object;
            
            if ([[infoDic objectForKey:@"key"] isEqualToString:@"直播开始了"]) {
                
                NSDictionary * dic1 = @{kCourseID:[self.infoDic objectForKey:kCourseID],
                                        kteacherId:@"",
                                        @"month":@(0)};
                [[CourseraManager sharedManager] didrequestLivingSectionDetailWithInfo:dic1 andNotifiedObject:self];
                
                if (weakSelf.videoController.playbackState != MPMoviePlaybackStatePlaying ) {
                    [weakSelf playVideo:[NSDictionary dictionary]];
                    [weakSelf.view insertSubview:weakSelf.stateImageView aboveSubview:weakSelf.videoController.view];
                }else
                {
                    [weakSelf.timer invalidate];
                    weakSelf.timer = nil;
                    [weakSelf.stateImageView timerInvalidate];
                    [weakSelf.view insertSubview:weakSelf.stateImageView belowSubview:weakSelf.videoController.view];
                }
            }
        }];
        
    }
}

- (void)refreshPlayState:(NSTimer *)timer
{
    NSDictionary * infoDic = timer.userInfo;
    
    if ([[infoDic objectForKey:@"key"] isEqualToString:@"直播开始了"]) {
        if (self.videoController.playbackState != MPMoviePlaybackStatePlaying ) {
            [self playVideo:[NSDictionary dictionary]];
            [self.view insertSubview:self.stateImageView aboveSubview:self.videoController.view];
        }else
        {
            
            [self.timer invalidate];
            self.timer = nil;
            [self.stateImageView timerInvalidate];
            [self.view insertSubview:self.stateImageView belowSubview:self.videoController.view];
        }
    }
}

- (NSInteger)getDate:(NSDictionary *)infoDic
{
    
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    // 截止时间字符串格式
    NSString * expireDateStr = [infoDic objectForKey:kLivingTime];
    
    expireDateStr = [[expireDateStr componentsSeparatedByString:@"~"] objectAtIndex:0];
    
//    expireDateStr = @"2017/8/17 10:25:00";
    // 当前时间字符串格式
    NSString *nowDateStr = [dateFomatter stringFromDate:nowDate];
    // 截止时间data格式
    NSDate *expireDate = [dateFomatter dateFromString:expireDateStr];
    // 当前时间data格式
    nowDate = [dateFomatter dateFromString:nowDateStr];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:nowDate toDate:expireDate options:0];
    
    NSInteger date = dateCom.month * 30 * 24 * 3600 + dateCom.day * 24 * 60 * 60 + dateCom.hour * 60 * 60 + dateCom.minute * 60;
    
    return date;
}
#pragma mark - playState

- (void)setLoginOutPlayStateView
{
    [self setPlayStateViewIsLogin:NO];
}

- (void)setPlayStateViewIsLogin:(BOOL)isLogin
{
    if (!self.stateImageView) {
        self.stateImageView = [[LivingStateView alloc]initWithFrame:CGRectMake(0, 0, kZXVideoPlayerOriginalWidth, kZXVideoPlayerOriginalHeight)];
    }
    
    __weak typeof(self)weakSelf = self;
    self.stateImageView.loginClickBlock = ^{
        LoginViewController *login = [[LoginViewController alloc] init];
        
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:login];
        
        [weakSelf presentViewController:nav animated:YES completion:nil];
    };
    
    [self.stateImageView resetWithInfoDic:self.infoDic andIsLogin:isLogin];
    [self.view insertSubview:self.stateImageView aboveSubview:self.videoController.view];
    self.stateImageView.userInteractionEnabled = YES;
    
    self.backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBT.frame = CGRectMake(15, 30, 30, 30);
    [self.backBT setImage:[UIImage imageNamed:@"zx-video-banner-back"] forState:UIControlStateNormal];
    [self.stateImageView addSubview:self.backBT];
    [self.backBT addTarget:self action:@selector(quitConversationViewAndClear) forControlEvents:UIControlEventTouchUpInside];
    switch ([[self.infoDic objectForKey:kLivingState] intValue]) {
        case 0:
        case 1:
            [self.segmentC hideTitlesWith:@[@(2),@(3)]];
            self.stateImageView.hidden = NO;
            [self.stateImageView setStateWith:LivingState_noStart];
            
            if (self.videoController.playbackState == MPMoviePlaybackStatePlaying )
            {
                self.stateImageView.hidden = YES;
                [self.segmentC showTitlesWith:@[@(2),@(3)]];
            }
            
            // 添加本地通知
            if ([[UserManager sharedManager] isUserLogin]) {
                [self addLocalNotification:self.infoDic];
            }
            NSLog(@"未开始");
            break;
        case 2:
            [self.segmentC showTitlesWith:@[@(2),@(3)]];
            self.stateImageView.hidden = YES;
            break;
        case 3:
            [self.segmentC hideTitlesWith:@[@(2),@(3)]];
            self.stateImageView.hidden = NO;
            if (![[UserManager sharedManager] isUserLogin]) {
                [self.stateImageView setStateWith:LivingState_end];
                return;
            }
            if (self.isLivingCourse) {
                self.isLivingCourse = NO;
                [self.stateImageView setStateWith:LivingState_end];
                return;
            }
            self.stateImageView.hidden = YES;
            break;
        default:
            break;
    }
}

#pragma mark - segmentControl
- (void)segmentSetup
{
    self.segmentC = [[HYSegmentedControl alloc] initWithOriginY:kZXVideoPlayerOriginalHeight Titles:@[@"目录",@"视频详情",@"聊天室", @"助教老师"] delegate:self];
//    self.segmentC = [[HYSegmentedControl alloc] initWithOriginY:kZXVideoPlayerOriginalHeight Titles:@[@"聊天室", @"视频详情"] delegate:self];
    [self.view addSubview:self.segmentC];
    
    if (![[UserManager sharedManager] isUserLogin]) {
        [self.segmentC hideTitlesWith:@[@(2),@(3)]];
    }
}

- (void)haveLogin:(NSNotification *)notification
{
    
    [SVProgressHUD show];
    NSDictionary * dic1 = @{kCourseID:[self.infoDic objectForKey:kCourseID],
                            kteacherId:@"",
                            @"month":@(0)};
    [[CourseraManager sharedManager] didrequestLivingSectionDetailWithInfo:dic1 andNotifiedObject:self];
    
}


- (void)sendDanmaku:(NSString *)text {
    if(!text || text.length == 0){
        return;
    }
    RCDDanmaku *danmaku = [[RCDDanmaku alloc]init];
    danmaku.contentStr = [[NSAttributedString alloc]initWithString:text attributes:@{NSForegroundColorAttributeName : kRandomColor}];
    [self.liveView sendDanmaku:danmaku];
}

- (void)sendCenterDanmaku:(NSString *)text {
    if(!text || text.length == 0){
        return;
    }
    RCDDanmaku *danmaku = [[RCDDanmaku alloc]init];
    danmaku.contentStr = [[NSAttributedString alloc]initWithString:text attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:218.0/255 green:178.0/255 blue:115.0/255 alpha:1]}];
    danmaku.position = RCDDanmakuPositionCenterTop;
    [self.liveView sendDanmaku:danmaku];
}

/**
 *  加入聊天室失败的提示
 *
 *  @param title 提示内容
 */
- (void)loadErrorAlert:(NSString *)title {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view addGestureRecognizer:_resetBottomTapGesture];
    [self.conversationMessageCollectionView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationTitle = self.navigationItem.title;
}

/**
 *  移除监听
 *
 *  @param animated <#animated description#>
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:@"kRCPlayVoiceFinishNotification"
     object:nil];
    
    [self.conversationMessageCollectionView removeGestureRecognizer:_resetBottomTapGesture];
    [self.conversationMessageCollectionView
     addGestureRecognizer:_resetBottomTapGesture];
    
    //退出页面，弹幕停止
    [self.view stopDanmaku];
    
}

/**
 *  回收的时候需要消耗播放器和退出聊天室
 */
- (void)dealloc {
    //    [self quitConversationViewAndClear];
    [self.livingListView removeAll];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kLocalNitificationOfLivingStart object:nil];
    [self.stateImageView timerInvalidate];
    
    NSLog(@"界面释放了");
}

/**
 *  点击返回的时候消耗播放器和退出聊天室
 *
 *  @param sender sender description
 */
- (void)leftBarButtonItemPressed:(id)sender {
//  UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"退出聊天室？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//  [alertview show];
    
    [self quitConversationViewAndClear];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  [self quitConversationViewAndClear];
}

#pragma mark ****清理环境（退出聊天室并断开融云连接）
- (void)quitConversationViewAndClear {
    if (self.conversationType == ConversationType_CHATROOM) {
        
        // 取消本地通知
        [[UIApplication sharedApplication] cancelLocalNotification:self.localNotice];
        
      //退出聊天室
        [[RCIMClient sharedRCIMClient] quitChatRoom:self.targetId
                                            success:^{
                                                self.conversationMessageCollectionView.dataSource = nil;
                                                self.conversationMessageCollectionView.delegate = nil;
                                                [[NSNotificationCenter defaultCenter] removeObserver:self];
                                              
                                            //断开融云连接，如果你退出聊天室后还有融云的其他通讯功能操作，可以不用断开融云连接，否则断开连接后需要重新connectWithToken才能使用融云的功能
//                                                [[RCDLive sharedRCDLive]logoutRongCloud];
                                              
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [self dismissViewControllerAnimated:YES completion:nil];
                                                });
                                                
                                            } error:^(RCErrorCode status) {
                                                
                                                if (self.segmentC.selectIndex == 2) {
                                                    [self.chatVC.view removeFromSuperview];
                                                    [self.chatVC popupChatViewController];
                                                    self.chatVC = nil;
                                                }
                                                
                                                [self dismissViewControllerAnimated:YES completion:nil];
                                            }];
    }
}

- (void)initChatroomMemberInfo{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(45, 30, 85, 35)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 35/2;
    [self.view addSubview:view];
    view.alpha = 0.5;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 34, 34)];
    imageView.image = [UIImage imageNamed:@"head"];
    imageView.layer.cornerRadius = 34/2;
    imageView.layer.masksToBounds = YES;
    [view addSubview:imageView];
    UILabel *chatroomlabel = [[UILabel alloc] initWithFrame:CGRectMake(37, 0, 45, 35)];
    chatroomlabel.numberOfLines = 2;
    chatroomlabel.font = [UIFont systemFontOfSize:12.f];
    chatroomlabel.text = [NSString stringWithFormat:@"小海豚\n2890人"];
    [view addSubview:chatroomlabel];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 16;
    layout.sectionInset = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat memberHeadListViewY = view.frame.origin.x + view.frame.size.width;
    self.portraitsCollectionView  = [[UICollectionView alloc] initWithFrame:CGRectMake(memberHeadListViewY,30,self.view.frame.size.width - memberHeadListViewY,35) collectionViewLayout:layout];
    [self.view addSubview:self.portraitsCollectionView];
    self.portraitsCollectionView.delegate = self;
    self.portraitsCollectionView.dataSource = self;
    self.portraitsCollectionView.backgroundColor = [UIColor clearColor];
    
    
    [self.portraitsCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}

/**
 *  初始化页面控件
 */
- (void)initializedSubViews {
    //聊天区
    if(self.contentView == nil){
        CGRect contentViewFrame = CGRectMake(0, self.view.bounds.size.height-(kScreenHeight - 42 - kZXVideoPlayerOriginalHeight), self.view.bounds.size.width,(kScreenHeight - 42 - kZXVideoPlayerOriginalHeight));
        self.contentView = [[UIScrollView alloc]initWithFrame:contentViewFrame];
        self.contentView.backgroundColor = RCDLive_RGBCOLOR(235, 235, 235);
        self.contentView.scrollEnabled = NO;
        self.contentView.contentSize = CGSizeMake(kScreenWidth * 3, (kScreenHeight - 42 - kZXVideoPlayerOriginalHeight));
        [self.view addSubview:self.contentView];
    }
    //聊天消息区
    if (nil == self.conversationMessageCollectionView) {
        UICollectionViewFlowLayout *customFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        customFlowLayout.minimumLineSpacing = 0;
        customFlowLayout.sectionInset = UIEdgeInsetsMake(10.0f, 0.0f,5.0f, 0.0f);
        customFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGRect _conversationViewFrame = self.contentView.bounds;
        _conversationViewFrame.origin.y = 0;
        _conversationViewFrame.origin.x = kScreenWidth * 2;
        _conversationViewFrame.size.height = self.contentView.bounds.size.height - 50;
        _conversationViewFrame.size.width = kScreenWidth;
        self.conversationMessageCollectionView =
        [[UICollectionView alloc] initWithFrame:_conversationViewFrame
                           collectionViewLayout:customFlowLayout];
        [self.conversationMessageCollectionView
         setBackgroundColor:[UIColor grayColor]];
        self.conversationMessageCollectionView.showsHorizontalScrollIndicator = NO;
        self.conversationMessageCollectionView.alwaysBounceVertical = YES;
        self.conversationMessageCollectionView.dataSource = self;
        self.conversationMessageCollectionView.delegate = self;
        [self.contentView addSubview:self.conversationMessageCollectionView];
    }
    //输入区
    if(self.inputBar == nil){
        float inputBarOriginY = self.conversationMessageCollectionView.bounds.size.height;
        float inputBarOriginX = self.conversationMessageCollectionView.hd_x;
        float inputBarSizeWidth = self.contentView.frame.size.width;
        float inputBarSizeHeight = MinHeight_InputView;
        self.inputBar = [[RCDLiveInputBar alloc]initWithFrame:CGRectMake(inputBarOriginX, inputBarOriginY,inputBarSizeWidth,inputBarSizeHeight)];
        self.inputBar.delegate = self;
        self.inputBar.backgroundColor = [UIColor clearColor];
//        self.inputBar.hidden = YES;
        [self.contentView addSubview:self.inputBar];
    }
    
    self.collectionViewHeader = [[RCDLiveCollectionViewHeader alloc]
                                 initWithFrame:CGRectMake(0, -50, self.view.bounds.size.width, 40)];
    _collectionViewHeader.tag = 1999;
    [self.conversationMessageCollectionView addSubview:_collectionViewHeader];
    [self registerClass:[RCDLiveTextMessageCell class]forCellWithReuseIdentifier:rctextCellIndentifier];
    [self registerClass:[RCDLiveTipMessageCell class]forCellWithReuseIdentifier:RCDLiveTipMessageCellIndentifier];
    [self registerClass:[RCDLiveGiftMessageCell class]forCellWithReuseIdentifier:RCDLiveGiftMessageCellIndentifier];
    [self changeModel:YES];
    _resetBottomTapGesture =[[UITapGestureRecognizer alloc]
                             initWithTarget:self
                             action:@selector(tap4ResetDefaultBottomBarStatus:)];
    [_resetBottomTapGesture setDelegate:self];
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(10, 35, 72, 25);
    UIImageView *backImg = [[UIImageView alloc]
                            initWithImage:[UIImage imageNamed:@"back.png"]];
    backImg.frame = CGRectMake(0, 0, 25, 25);
    [_backBtn addSubview:backImg];
    [_backBtn addTarget:self
                 action:@selector(leftBarButtonItemPressed:)
       forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_backBtn];
    
    _feedBackBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    _feedBackBtn.frame = CGRectMake(10, self.view.frame.size.height - 45, 35, 35);
    UIImageView *clapImg = [[UIImageView alloc]
                            initWithImage:[UIImage imageNamed:@"feedback"]];
    clapImg.frame = CGRectMake(0,0, 35, 35);
    [_feedBackBtn addSubview:clapImg];
    [_feedBackBtn addTarget:self
                     action:@selector(showInputBar:)
           forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_feedBackBtn];
    
    _flowerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _flowerBtn.frame = CGRectMake(self.view.frame.size.width-90, self.view.frame.size.height - 45, 35, 35);
    UIImageView *clapImg2 = [[UIImageView alloc]
                             initWithImage:[UIImage imageNamed:@"giftIcon"]];
    clapImg2.frame = CGRectMake(0,0, 35, 35);
    [_flowerBtn addSubview:clapImg2];
    [_flowerBtn addTarget:self
                   action:@selector(flowerButtonPressed:)
         forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_flowerBtn];
    
    _clapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _clapBtn.frame = CGRectMake(self.view.frame.size.width-45, self.view.frame.size.height - 45, 35, 35);
    UIImageView *clapImg3 = [[UIImageView alloc]
                             initWithImage:[UIImage imageNamed:@"heartIcon"]];
    clapImg3.frame = CGRectMake(0,0, 35, 35);
    [_clapBtn addSubview:clapImg3];
    [_clapBtn addTarget:self
                 action:@selector(clapButtonPressed:)
       forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_clapBtn];
    
    if (self.videoDetailView == nil) {
        self.videoDetailView = [[LivingDetailView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, (kScreenHeight - 42 - kZXVideoPlayerOriginalHeight))];
        self.videoDetailView.backgroundColor = [UIColor whiteColor];
        self.videoDetailView.infoDic = self.infoDic;
        [self.videoDetailView.tableView reloadData];
        [self.contentView addSubview:self.videoDetailView];
    }
    
    if (self.privateChatView == nil) {
        self.privateChatView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth * 3, 0, kScreenWidth, (kScreenHeight - 42 - kZXVideoPlayerOriginalHeight))];
        self.privateChatView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:self.privateChatView];
//        self.privateChatView.bounds.origin.y = -(kScreenHeight - 42 - kZXVideoPlayerOriginalHeight);
    }
    
    if (self.livingListView == nil) {
        self.livingListView = [[LivingCourseListView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, (kScreenHeight - 42 - kZXVideoPlayerOriginalHeight))];
        self.livingListView.backgroundColor = [UIColor whiteColor];
        self.livingListView.dataArr = [[CourseraManager sharedManager]getLivingSectionDetailArray] ;
        self.livingListView.selectLivingSectionInfoDic = self.infoDic;
        [self.livingListView.tableView reloadData];
        
        __weak typeof(self)weakSelf = self;
        
        self.livingListView.countDownBlock = ^(NSDictionary *infoDic) {
            if (!infoDic) {
                return ;
            }
            NSDictionary * dic1 = @{kCourseID:[weakSelf.infoDic objectForKey:kCourseID],
                                    kteacherId:@"",
                                    @"month":@(0)};
            [[CourseraManager sharedManager] didrequestLivingSectionDetailWithInfo:dic1 andNotifiedObject:weakSelf];
        };
        
        self.livingListView.LivingPlayViewBlock = ^(NSDictionary *infoDic,NSInteger playType) {
            if (![[UserManager sharedManager] isUserLogin]) {
                [SVProgressHUD showErrorWithStatus:@"请先登录"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            }else
            {
                if (playType == 0) {
                    [SVProgressHUD show];
                    
                    weakSelf.selectOrderLivingSectionInfoDic = infoDic;
                    NSDictionary * orderDic = @{@"courseID":[infoDic objectForKey:kCourseID],
                                                @"courseSecondID":[infoDic objectForKey:kCourseSecondID],
                                                @"livingTime":[[[infoDic objectForKey:kLivingTime] componentsSeparatedByString:@"~"] objectAtIndex:0]};
                    [[UserManager sharedManager] didRequestOrderLivingCourseOperationWithCourseInfo:orderDic withNotifiedObject:weakSelf];
                    return ;
                }else if (playType == 1)
                {
                    [SVProgressHUD show];
                    
                    weakSelf.selectOrderLivingSectionInfoDic = infoDic;
                    NSDictionary * orderDic = @{@"courseID":[infoDic objectForKey:kCourseID],
                                                @"courseSecondID":[infoDic objectForKey:kCourseSecondID],
                                                @"livingTime":[[[infoDic objectForKey:kLivingTime] componentsSeparatedByString:@"~"] objectAtIndex:0]};
                    [[UserManager sharedManager] didRequestCancelOrderLivingCourseOperationWithCourseInfo:orderDic withNotifiedObject:weakSelf];
                    return ;
                }
                [weakSelf refreshWith:infoDic];
            }
        };
        
        [self.contentView addSubview:self.livingListView];
    }
    
}


- (void)refreshWith:(NSDictionary *)infoDic
{
    if ([[infoDic objectForKey:kIsLivingCourseFree] intValue] == 0 && [[infoDic objectForKey:kHaveJurisdiction] intValue] == 0) {
        [SVProgressHUD showErrorWithStatus:@"暂无观看权限"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [self setPlayStateViewIsLogin:YES];
        });
        return;
    }
    
    self.infoDic = infoDic;
    [self setPlayStateViewIsLogin:YES];
    self.targetId = [infoDic objectForKey:kChatRoomID];
    [self joinChatRoom];
    self.videoDetailView.infoDic = self.infoDic;
    [self.videoDetailView.tableView reloadData];
    
    self.livingListView.selectLivingSectionInfoDic = self.infoDic;
    [self.livingListView.tableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary *videoInfo = [NSDictionary dictionary];
        
        if (!self.playingVideo) {
            self.playingVideo = [[ZXVideo alloc] init];
        }
        if ([[infoDic objectForKey:kLivingState] intValue] == 3) {
            self.playingVideo.playUrl = [self.infoDic objectForKey:kPlayBackUrl];
        }else{
            self.playingVideo.playUrl = [self.infoDic objectForKey:kCourseURL];
        }
        self.playingVideo.title = [self.infoDic objectForKey:kCourseName];
        
        NSLog(@"--- %@", videoInfo);
        
        [self playVideo:videoInfo];
        [self setPlayStateViewIsLogin:YES];
    });
    
}

-(void)showInputBar:(id)sender{
//    self.inputBar.hidden = NO;
    [self.inputBar setInputBarStatus:RCDLiveBottomBarKeyboardStatus];
}

/**
 *  发送鲜花
 *
 *  @param sender sender description
 */
-(void)flowerButtonPressed:(id)sender{
    RCDLiveGiftMessage *giftMessage = [[RCDLiveGiftMessage alloc]init];
    giftMessage.type = @"0";
    [self sendMessage:giftMessage pushContent:@""];
    NSString *text = [NSString stringWithFormat:@"%@ 送了一个钻戒",giftMessage.senderUserInfo.name];
    [self sendDanmaku:text];
}

/**
 *  发送掌声
 *
 *  @param sender <#sender description#>
 */
-(void)clapButtonPressed:(id)sender{
    RCDLiveGiftMessage *giftMessage = [[RCDLiveGiftMessage alloc]init];
    giftMessage.type = @"1";
    [self sendMessage:giftMessage pushContent:@""];
    NSString *text = [NSString stringWithFormat:@"%@ 为主播点了赞",giftMessage.senderUserInfo.name];
    [self sendDanmaku:text];
    [self praiseHeart];
}

/**
 *  未读消息View
 *
 *  @return <#return value description#>
 */
- (UIView *)unreadButtonView {
    if (!_unreadButtonView) {
        _unreadButtonView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 80)/2, self.view.frame.size.height - MinHeight_InputView - 30, 80, 30)];
        _unreadButtonView.userInteractionEnabled = YES;
        _unreadButtonView.backgroundColor = RCDLive_HEXCOLOR(0xffffff);
        _unreadButtonView.alpha = 0.7;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabUnreadMsgCountIcon:)];
        [_unreadButtonView addGestureRecognizer:tap];
        _unreadButtonView.hidden = YES;
        [self.view addSubview:_unreadButtonView];
        _unreadButtonView.layer.cornerRadius = 4;
    }
    return _unreadButtonView;
}

/**
 *  底部新消息文字
 *
 *  @return return value description
 */
- (UILabel *)unReadNewMessageLabel {
    if (!_unReadNewMessageLabel) {
        _unReadNewMessageLabel = [[UILabel alloc]initWithFrame:_unreadButtonView.bounds];
        _unReadNewMessageLabel.backgroundColor = [UIColor clearColor];
        _unReadNewMessageLabel.font = [UIFont systemFontOfSize:12.0f];
        _unReadNewMessageLabel.textAlignment = NSTextAlignmentCenter;
        _unReadNewMessageLabel.textColor = RCDLive_HEXCOLOR(0xff4e00);
        [self.unreadButtonView addSubview:_unReadNewMessageLabel];
    }
    return _unReadNewMessageLabel;
}

/**
 *  更新底部新消息提示显示状态
 */
- (void)updateUnreadMsgCountLabel{
    if (self.unreadNewMsgCount == 0) {
        self.unreadButtonView.hidden = YES;
    }
    else{
        self.unreadButtonView.hidden = NO;
        self.unReadNewMessageLabel.text = @"底部有新消息";
    }
}

/**
 *  检查是否更新新消息提醒
 */
- (void) checkVisiableCell{
    NSIndexPath *lastPath = [self getLastIndexPathForVisibleItems];
    if (lastPath.row >= self.conversationDataRepository.count - self.unreadNewMsgCount || lastPath == nil || [self isAtTheBottomOfTableView] ) {
        self.unreadNewMsgCount = 0;
        [self updateUnreadMsgCountLabel];
    }
}

/**
 *  获取显示的最后一条消息的indexPath
 *
 *  @return indexPath
 */
- (NSIndexPath *)getLastIndexPathForVisibleItems
{
    NSArray *visiblePaths = [self.conversationMessageCollectionView indexPathsForVisibleItems];
    if (visiblePaths.count == 0) {
        return nil;
    }else if(visiblePaths.count == 1) {
        return (NSIndexPath *)[visiblePaths firstObject];
    }
    NSArray *sortedIndexPaths = [visiblePaths sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSIndexPath *path1 = (NSIndexPath *)obj1;
        NSIndexPath *path2 = (NSIndexPath *)obj2;
        return [path1 compare:path2];
    }];
    return (NSIndexPath *)[sortedIndexPaths lastObject];
}

/**
 *  点击未读提醒滚动到底部
 *
 *  @param gesture gesture description
 */
- (void)tabUnreadMsgCountIcon:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self scrollToBottomAnimated:YES];
    }
}

/**
 *  初始化视频直播
 */
- (void)initializedLiveSubViews {
//    _liveView = self.livePlayingManager.currentLiveView;
    _liveView.frame = self.view.frame;
    [self.view addSubview:_liveView];
    [self.view sendSubviewToBack:_liveView];
    
}

/**
 *  全屏和半屏模式切换
 *
 *  @param isFullScreen 全屏或者半屏
 */
- (void)changeModel:(BOOL)isFullScreen {
//    self.livePlayingManager.currentLiveView.frame = self.view.frame;
    _titleView.hidden = YES;
    
    self.conversationMessageCollectionView.backgroundColor = [UIColor clearColor];
    CGRect contentViewFrame = CGRectMake(0, self.view.bounds.size.height-(kScreenHeight - 42 - kZXVideoPlayerOriginalHeight), self.view.bounds.size.width,(kScreenHeight - 42 - kZXVideoPlayerOriginalHeight));
    self.contentView.frame = contentViewFrame;
    _feedBackBtn.frame = CGRectMake(10, self.view.frame.size.height - 45, 35, 35);
    _flowerBtn.frame = CGRectMake(self.view.frame.size.width-90, self.view.frame.size.height - 45, 35, 35);
    _clapBtn.frame = CGRectMake(self.view.frame.size.width-45, self.view.frame.size.height - 45, 35, 35);
    [self.view sendSubviewToBack:_liveView];
    
    float inputBarOriginY = self.conversationMessageCollectionView.bounds.size.height;
    float inputBarOriginX = self.conversationMessageCollectionView.frame.origin.x;
    float inputBarSizeWidth = self.contentView.frame.size.width;
    float inputBarSizeHeight = MinHeight_InputView;
    //添加输入框
    [self.inputBar changeInputBarFrame:CGRectMake(inputBarOriginX, inputBarOriginY,inputBarSizeWidth,inputBarSizeHeight)];
    [self.conversationMessageCollectionView reloadData];
    [self.unreadButtonView setFrame:CGRectMake((self.view.frame.size.width - 80)/2, self.view.frame.size.height - MinHeight_InputView - 30, 80, 30)];
}

/**
 *  顶部插入历史消息
 *
 *  @param model 消息Model
 */
- (void)pushOldMessageModel:(RCDLiveMessageModel *)model {
    if (!(!model.content && model.messageId > 0)
        && !([[model.content class] persistentFlag] & MessagePersistent_ISPERSISTED)) {
        return;
    }
    long ne_wId = model.messageId;
    for (RCDLiveMessageModel *__item in self.conversationDataRepository) {
        if (ne_wId == __item.messageId) {
            return;
        }
    }
    [self.conversationDataRepository insertObject:model atIndex:0];
}

/**
 *  加载历史消息(暂时没有保存聊天室消息)
 */
- (void)loadMoreHistoryMessage {
    long lastMessageId = -1;
    if (self.conversationDataRepository.count > 0) {
        RCDLiveMessageModel *model = [self.conversationDataRepository objectAtIndex:0];
        lastMessageId = model.messageId;
    }
    
    NSArray *__messageArray =
    [[RCIMClient sharedRCIMClient] getHistoryMessages:_conversationType
                                             targetId:_targetId
                                      oldestMessageId:lastMessageId
                                                count:10];
    for (int i = 0; i < __messageArray.count; i++) {
        RCMessage *rcMsg = [__messageArray objectAtIndex:i];
        RCDLiveMessageModel *model = [[RCDLiveMessageModel alloc] initWithMessage:rcMsg];
        [self pushOldMessageModel:model];
    }
    [self.conversationMessageCollectionView reloadData];
    if (_conversationDataRepository != nil &&
        _conversationDataRepository.count > 0 &&
        [self.conversationMessageCollectionView numberOfItemsInSection:0] >=
        __messageArray.count - 1) {
        NSIndexPath *indexPath =
        [NSIndexPath indexPathForRow:__messageArray.count - 1 inSection:0];
        [self.conversationMessageCollectionView scrollToItemAtIndexPath:indexPath
                                                       atScrollPosition:UICollectionViewScrollPositionTop
                                                               animated:NO];
    }
}


#pragma mark <UIScrollViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

/**
 *  滚动条滚动时显示正在加载loading
 *
 *  @param scrollView
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 是否显示右下未读icon
    if (self.unreadNewMsgCount != 0) {
        [self checkVisiableCell];
    }
    
    if (scrollView.contentOffset.y < -5.0f) {
        [self.collectionViewHeader startAnimating];
    } else {
        [self.collectionViewHeader stopAnimating];
        _isLoading = NO;
    }
}

/**
 *  滚动结束加载消息 （聊天室消息还没存储，所以暂时还没有此功能）
 *
 *  @param scrollView scrollView description
 *  @param decelerate decelerate description
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y < -15.0f && !_isLoading) {
        _isLoading = YES;
    }
}

/**
 *  消息滚动到底部
 *
 *  @param animated 是否开启动画效果
 */
- (void)scrollToBottomAnimated:(BOOL)animated {
    if ([self.conversationMessageCollectionView numberOfSections] == 0) {
        return;
    }
    NSUInteger finalRow = MAX(0, [self.conversationMessageCollectionView numberOfItemsInSection:0] - 1);
    if (0 == finalRow) {
        return;
    }
    NSIndexPath *finalIndexPath =
    [NSIndexPath indexPathForItem:finalRow inSection:0];
    [self.conversationMessageCollectionView scrollToItemAtIndexPath:finalIndexPath
                                                   atScrollPosition:UICollectionViewScrollPositionTop
                                                           animated:animated];
}

#pragma mark <UICollectionViewDataSource>
/**
 *  定义展示的UICollectionViewCell的个数
 *
 *  @return
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.portraitsCollectionView]) {
        return self.userList.count;
    }
    return self.conversationDataRepository.count;
}

/**
 *  每个UICollectionView展示的内容
 *
 *  @return
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.portraitsCollectionView]) {
        RCDLivePortraitViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"portraitcell" forIndexPath:indexPath];
        RCUserInfo *user = self.userList[indexPath.row];
        NSString *str = user.portraitUri;
        cell.portaitView.image = [UIImage imageNamed:str];
        return cell;
    }
    //NSLog(@"path row is %d", indexPath.row);
    RCDLiveMessageModel *model =
    [self.conversationDataRepository objectAtIndex:indexPath.row];
    RCMessageContent *messageContent = model.content;
    RCDLiveMessageBaseCell *cell = nil;
    if ([messageContent isMemberOfClass:[RCInformationNotificationMessage class]] || [messageContent isMemberOfClass:[RCTextMessage class]] || [messageContent isMemberOfClass:[RCDLiveGiftMessage class]]){
        RCDLiveTipMessageCell *__cell = [collectionView dequeueReusableCellWithReuseIdentifier:RCDLiveTipMessageCellIndentifier forIndexPath:indexPath];
        __cell.isFullScreenMode = YES;
        [__cell setDataModel:model];
        [__cell setDelegate:self];
        cell = __cell;
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegateFlowLayout>

/**
 *  cell的大小
 *
 *  @return
 */
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.portraitsCollectionView]) {
        return CGSizeMake(35,35);
    }
    RCDLiveMessageModel *model =
    [self.conversationDataRepository objectAtIndex:indexPath.row];
    if (model.cellSize.height > 0) {
        return model.cellSize;
    }
    RCMessageContent *messageContent = model.content;
    if ([messageContent isMemberOfClass:[RCTextMessage class]] || [messageContent isMemberOfClass:[RCInformationNotificationMessage class]] || [messageContent isMemberOfClass:[RCDLiveGiftMessage class]]) {
        model.cellSize = [self sizeForItem:collectionView atIndexPath:indexPath];
    } else {
        return CGSizeZero;
    }
    return model.cellSize;
}

/**
 *  计算不同消息的具体尺寸
 *
 *  @return
 */
- (CGSize)sizeForItem:(UICollectionView *)collectionView
          atIndexPath:(NSIndexPath *)indexPath {
    CGFloat __width = CGRectGetWidth(collectionView.frame);
    RCDLiveMessageModel *model =
    [self.conversationDataRepository objectAtIndex:indexPath.row];
    RCMessageContent *messageContent = model.content;
    CGFloat __height = 0.0f;
    NSString *localizedMessage;
    if ([messageContent isMemberOfClass:[RCInformationNotificationMessage class]]) {
        RCInformationNotificationMessage *notification = (RCInformationNotificationMessage *)messageContent;
        localizedMessage = [RCDLiveKitUtility formatMessage:notification];
    }else if ([messageContent isMemberOfClass:[RCTextMessage class]]){
        RCTextMessage *notification = (RCTextMessage *)messageContent;
        localizedMessage = [RCDLiveKitUtility formatMessage:notification];
        NSString *name;
        if (messageContent.senderUserInfo) {
            name = messageContent.senderUserInfo.name;
        }
        localizedMessage = [NSString stringWithFormat:@"%@\n    %@",name,localizedMessage];
    }else if ([messageContent isMemberOfClass:[RCDLiveGiftMessage class]]){
        RCDLiveGiftMessage *notification = (RCDLiveGiftMessage *)messageContent;
        localizedMessage = @"送了一个钻戒";
        if(notification && [notification.type isEqualToString:@"1"]){
            localizedMessage = @"为主播点了赞";
        }
        
        NSString *name;
        if (messageContent.senderUserInfo) {
            name = messageContent.senderUserInfo.name;
        }
        localizedMessage = [NSString stringWithFormat:@"%@ %@",name,localizedMessage];
    }
    CGSize __labelSize = [RCDLiveTipMessageCell getTipMessageCellSize:localizedMessage];
    __height = __height + __labelSize.height;
    
    return CGSizeMake(__width, __height);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

#pragma mark <UICollectionViewDelegate>

/**
 *   UICollectionView被选中时调用的方法
 *
 *  @return
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

/**
 *  将消息加入本地数组
 *
 *  @return
 */
- (void)appendAndDisplayMessage:(RCMessage *)rcMessage {
    if (!rcMessage) {
        return;
    }
    RCDLiveMessageModel *model = [[RCDLiveMessageModel alloc] initWithMessage:rcMessage];
    if([rcMessage.content isMemberOfClass:[RCDLiveGiftMessage class]]){
        model.messageId = -1;
    }
    if ([self appendMessageModel:model]) {
        NSIndexPath *indexPath =
        [NSIndexPath indexPathForItem:self.conversationDataRepository.count - 1
                            inSection:0];
        if ([self.conversationMessageCollectionView numberOfItemsInSection:0] !=
            self.conversationDataRepository.count - 1) {
            return;
        }
        [self.conversationMessageCollectionView
         insertItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        if ([self isAtTheBottomOfTableView] || self.isNeedScrollToButtom) {
            [self scrollToBottomAnimated:YES];
            self.isNeedScrollToButtom=NO;
        }
    }
}

- (void)sendReceivedDanmaku:(RCMessageContent *)messageContent {
    if([messageContent isMemberOfClass:[RCInformationNotificationMessage class]]){
        RCInformationNotificationMessage *msg = (RCInformationNotificationMessage *)messageContent;
        //        [self sendDanmaku:msg.message];
        [self sendCenterDanmaku:msg.message];
    }else if ([messageContent isMemberOfClass:[RCTextMessage class]]){
        RCTextMessage *msg = (RCTextMessage *)messageContent;
        [self sendDanmaku:msg.content];
    }else if([messageContent isMemberOfClass:[RCDLiveGiftMessage class]]){
        RCDLiveGiftMessage *msg = (RCDLiveGiftMessage *)messageContent;
        NSString *tip = [msg.type isEqualToString:@"0"]?@"送了一个钻戒":@"为主播点了赞";
        NSString *text = [NSString stringWithFormat:@"%@ %@",msg.senderUserInfo.name,tip];
        [self sendDanmaku:text];
    }
}

/**
 *  如果当前会话没有这个消息id，把消息加入本地数组
 *
 *  @return
 */
- (BOOL)appendMessageModel:(RCDLiveMessageModel *)model {
    long newId = model.messageId;
    for (RCDLiveMessageModel *__item in self.conversationDataRepository) {
        /*
         * 当id为－1时，不检查是否重复，直接插入
         * 该场景用于插入临时提示。
         */
        if (newId == -1) {
            break;
        }
        if (newId == __item.messageId) {
            return NO;
        }
    }
    if (!model.content) {
        return NO;
    }
    //这里可以根据消息类型来决定是否显示，如果不希望显示直接return NO
    
    //数量不可能无限制的大，这里限制收到消息过多时，就对显示消息数量进行限制。
    //用户可以手动下拉更多消息，查看更多历史消息。
    if (self.conversationDataRepository.count>100) {
        //                NSRange range = NSMakeRange(0, 1);
        RCDLiveMessageModel *message = self.conversationDataRepository[0];
        [[RCIMClient sharedRCIMClient]deleteMessages:@[@(message.messageId)]];
        [self.conversationDataRepository removeObjectAtIndex:0];
        [self.conversationMessageCollectionView reloadData];
    }
    
    [self.conversationDataRepository addObject:model];
    return YES;
}

/**
 *  UIResponder
 *
 *  @return
 */
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return [super canPerformAction:action withSender:sender];
}

/**
 *  找出消息的位置
 *
 *  @return
 */
- (NSInteger)findDataIndexFromMessageList:(RCDLiveMessageModel *)model {
    NSInteger index = 0;
    for (int i = 0; i < self.conversationDataRepository.count; i++) {
        RCDLiveMessageModel *msg = (self.conversationDataRepository)[i];
        if (msg.messageId == model.messageId) {
            index = i;
            break;
        }
    }
    return index;
}


/**
 *  打开大图。开发者可以重写，自己下载并且展示图片。默认使用内置controller
 *
 *  @param imageMessageContent 图片消息内容
 */
- (void)presentImagePreviewController:(RCDLiveMessageModel *)model {
}

/**
 *  打开地理位置。开发者可以重写，自己根据经纬度打开地图显示位置。默认使用内置地图
 *
 *  @param locationMessageContent 位置消息
 */
- (void)presentLocationViewController:
(RCLocationMessage *)locationMessageContent {
    
}

/**
 *  关闭提示框
 *
 *  @param theTimer theTimer description
 */
- (void)timerForHideHUD:(NSTimer*)theTimer//弹出框
{
    __weak __typeof(&*self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    });
    [theTimer invalidate];
    theTimer = nil;
}


/*!
 发送消息(除图片消息外的所有消息)
 
 @param messageContent 消息的内容
 @param pushContent    接收方离线时需要显示的远程推送内容
 
 @discussion 当接收方离线并允许远程推送时，会收到远程推送。
 远程推送中包含两部分内容，一是pushContent，用于显示；二是pushData，用于携带不显示的数据。
 
 SDK内置的消息类型，如果您将pushContent置为nil，会使用默认的推送格式进行远程推送。
 自定义类型的消息，需要您自己设置pushContent来定义推送内容，否则将不会进行远程推送。
 
 如果您需要设置发送的pushData，可以使用RCIM的发送消息接口。
 */
- (void)sendMessage:(RCMessageContent *)messageContent
        pushContent:(NSString *)pushContent {
    if (_targetId == nil) {
        return;
    }
    messageContent.senderUserInfo = [RCDLive sharedRCDLive].currentUserInfo;
    if (messageContent == nil) {
        return;
    }
    
    [[RCDLive sharedRCDLive] sendMessage:self.conversationType
                                targetId:self.targetId
                                 content:messageContent
                             pushContent:pushContent
                                pushData:nil
                                 success:^(long messageId) {
                                     
                                     NSLog(@"***** %ld", messageId);
                                     
                                     __weak typeof(&*self) __weakself = self;
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         RCMessage *message = [[RCMessage alloc] initWithType:__weakself.conversationType
                                                                                     targetId:__weakself.targetId
                                                                                    direction:MessageDirection_SEND
                                                                                    messageId:messageId
                                                                                      content:messageContent];
                                         if ([message.content isMemberOfClass:[RCDLiveGiftMessage class]] ) {
                                             message.messageId = -1;//插入消息时如果id是-1不判断是否存在
                                         }
                                         [__weakself appendAndDisplayMessage:message];
                                         [__weakself.inputBar clearInputView];
                                     });
                                 } error:^(RCErrorCode nErrorCode, long messageId) {
//                                     
                                     NSLog(@"%ld",(long)nErrorCode);
                                     
                                     [[RCIMClient sharedRCIMClient]deleteMessages:@[ @(messageId) ]];
                                 }];
}

/**
 *  接收到消息的回调
 *
 *  @param notification
 */
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    __block RCMessage *rcMessage = notification.object;
    
    NSLog(@"%@", rcMessage);
    
    if (rcMessage.conversationType == ConversationType_PRIVATE) {
        [self.segmentC addTipWithIndex:2];
    }
    
    RCDLiveMessageModel *model = [[RCDLiveMessageModel alloc] initWithMessage:rcMessage];
    
    NSDictionary *leftDic = notification.userInfo;
    if (leftDic && [leftDic[@"left"] isEqual:@(0)]) {
        self.isNeedScrollToButtom = YES;
    }
    if (model.conversationType == self.conversationType &&
        [model.targetId isEqual:self.targetId]) {
        __weak typeof(&*self) __blockSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (rcMessage) {
                [__blockSelf appendAndDisplayMessage:rcMessage];
                UIMenuController *menu = [UIMenuController sharedMenuController];
                menu.menuVisible=NO;
                //如果消息不在最底部，收到消息之后不滚动到底部，加到列表中只记录未读数
                if (![self isAtTheBottomOfTableView]) {
                    self.unreadNewMsgCount ++ ;
                    [self updateUnreadMsgCountLabel];
                }
            }
        });
    }
    
    if([NSThread isMainThread]){
        [self sendReceivedDanmaku:rcMessage.content];
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self sendReceivedDanmaku:rcMessage.content];
        });
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma 屏幕点击充数输入框状态
/**
 *  定义展示的UICollectionViewCell的个数
 *
 *  @return
 */
- (void)tap4ResetDefaultBottomBarStatus:
(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        //        CGRect collectionViewRect = self.conversationMessageCollectionView.frame;
        //        collectionViewRect.size.height = self.contentView.bounds.size.height - 0;
        //        [self.conversationMessageCollectionView setFrame:collectionViewRect];
        [self.inputBar setInputBarStatus:RCDLiveBottomBarDefaultStatus];
//        self.inputBar.hidden = YES;
        
        if (self.videoController.playbackState != MPMoviePlaybackStatePlaying ) {
            [self playVideo:[NSDictionary dictionary]];
            [self.view insertSubview:self.stateImageView aboveSubview:self.videoController.view];
        }else
        {
            [self.stateImageView timerInvalidate];
            [self.view insertSubview:self.stateImageView belowSubview:self.videoController.view];
        }
    }
}

/**
 *  判断消息是否在collectionView的底部
 *
 *  @return 是否在底部
 */
- (BOOL)isAtTheBottomOfTableView {
    if (self.conversationMessageCollectionView.contentSize.height <= self.conversationMessageCollectionView.frame.size.height) {
        return YES;
    }
    if(self.conversationMessageCollectionView.contentOffset.y +200 >= (self.conversationMessageCollectionView.contentSize.height - self.conversationMessageCollectionView.frame.size.height)) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - HYSegmentControlDelegate
- (void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
    [self.inputBar setInputBarStatus:RCDLiveBottomBarDefaultStatus];
    [self.contentView setContentOffset:CGPointMake(kScreenWidth * index, 0) animated:YES];
    
    if (index == 3) {
        [self quitChatRoom];
        [self.segmentC cancelTipWithIndex:3];
        if (!self.chatVC) {
            self.chatVC = [[LivingChatViewController alloc]init];
            _chatVC.conversationType = ConversationType_PRIVATE;
            _chatVC.targetId = [self.infoDic objectForKey:kAssistantID];
    
            [self.privateChatView addSubview:_chatVC.view];
        }
        
    }else if (index == 2)
    {
        [self.chatVC.view removeFromSuperview];
        [self.chatVC popupChatViewController];
        self.chatVC = nil;
        if (self.conversationMessageCollectionView.delegate == nil) {
            [self joinChatRoom];
        }
    }
}

- (void)joinChatRoom
{
    __weak typeof(self)weakSelf = self;
    
    [[RCIMClient sharedRCIMClient]
     joinChatRoom:self.targetId
     messageCount:self.defaultHistoryMessageCountOfChatRoom
     success:^{
         dispatch_async(dispatch_get_main_queue(), ^{

             self.conversationMessageCollectionView.dataSource = self;
             self.conversationMessageCollectionView.delegate = self;
             [self registerNotification];
         });
     }
     error:^(RCErrorCode status) {
         
         dispatch_async(dispatch_get_main_queue(), ^{
             if (status == KICKED_FROM_CHATROOM) {
                 [weakSelf loadErrorAlert:NSLocalizedStringFromTable(@"JoinChatRoomRejected", @"RongCloudKit", nil)];
             } else {
                 [weakSelf loadErrorAlert:NSLocalizedStringFromTable(@"JoinChatRoomFailed", @"RongCloudKit", nil)];
             }
         });
     }];
}

- (void)quitChatRoom
{
    [[RCIMClient sharedRCIMClient] quitChatRoom:self.targetId
                                        success:^{
                                            self.conversationMessageCollectionView.dataSource = nil;
                                            self.conversationMessageCollectionView.delegate = nil;
                                            [[NSNotificationCenter defaultCenter] removeObserver:self name:RCDLiveKitDispatchMessageNotification object:nil];
                                            
                                            //断开融云连接，如果你退出聊天室后还有融云的其他通讯功能操作，可以不用断开融云连接，否则断开连接后需要重新connectWithToken才能使用融云的功能
                                            //                                                [[RCDLive sharedRCDLive]logoutRongCloud];
                                            
                                            
                                        } error:^(RCErrorCode status) {
                                            
                                        }];
}

#pragma mark - 输入框事件
/**
 *  点击键盘回车或者emoji表情面板的发送按钮执行的方法
 *
 *  @param text  输入框的内容
 */
- (void)onTouchSendButton:(NSString *)text{
    RCTextMessage *rcTextMessage = [RCTextMessage messageWithContent:text];
    [self sendMessage:rcTextMessage pushContent:nil];
    [self sendDanmaku:rcTextMessage.content];
        [self.inputBar setInputBarStatus:KBottomBarDefaultStatus];
    //    [self.inputBar setHidden:YES];
}

//修复ios7下不断下拉加载历史消息偶尔崩溃的bug
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark RCInputBarControlDelegate

/**
 *  根据inputBar 回调来修改页面布局，inputBar frame 变化会触发这个方法
 *
 *  @param frame    输入框即将占用的大小
 *  @param duration 时间
 *  @param curve
 */
- (void)onInputBarControlContentSizeChanged:(CGRect)frame withAnimationDuration:(CGFloat)duration andAnimationCurve:(UIViewAnimationCurve)curve{
//    CGRect collectionViewRect = self.contentView.frame;
//    self.contentView.backgroundColor = [UIColor clearColor];
//    collectionViewRect.origin.y = self.view.bounds.size.height - frame.size.height - (kScreenHeight - 42 - kZXVideoPlayerOriginalHeight) +50;
//    
//    collectionViewRect.size.height = (kScreenHeight - 42 - kZXVideoPlayerOriginalHeight);
//    [UIView animateWithDuration:duration animations:^{
//        [UIView setAnimationCurve:curve];
//        [self.contentView setFrame:collectionViewRect];
//        [UIView commitAnimations];
//    }];
//    CGRect inputbarRect = self.inputBar.frame;
//    
//    inputbarRect.origin.y = self.contentView.frame.size.height -50;
//    [self.inputBar setFrame:inputbarRect];
//    [self.view bringSubviewToFront:self.inputBar];
//    [self scrollToBottomAnimated:NO];
}

/**
 *  屏幕翻转
 *
 *  @param newCollection <#newCollection description#>
 *  @param coordinator   <#coordinator description#>
 */
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    [super willTransitionToTraitCollection:newCollection
                 withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context)
     {
         if (newCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
             //To Do: modify something for compact vertical size
             [self changeCrossOrVerticalscreen:NO];
         } else {
             [self changeCrossOrVerticalscreen:YES];
             //To Do: modify something for other vertical size
         }
         [self.view setNeedsLayout];
     } completion:nil];
}

/**
 *  横竖屏切换
 *
 *  @param isVertical isVertical description
 */
-(void)changeCrossOrVerticalscreen:(BOOL)isVertical{
    _isScreenVertical = isVertical;
//    if (!isVertical) {
//        self.livePlayingManager.currentLiveView.frame = self.view.frame;
//    } else {
//        self.livePlayingManager.currentLiveView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.contentView.frame.size.height);
//    }
    float inputBarOriginY = self.conversationMessageCollectionView.bounds.size.height ;
    float inputBarOriginX = self.conversationMessageCollectionView.frame.origin.x;
    float inputBarSizeWidth = self.contentView.frame.size.width;
    float inputBarSizeHeight = MinHeight_InputView;
    //添加输入框
    [self.inputBar changeInputBarFrame:CGRectMake(inputBarOriginX, inputBarOriginY,inputBarSizeWidth,inputBarSizeHeight)];
    for (RCDLiveMessageModel *__item in self.conversationDataRepository) {
        __item.cellSize = CGSizeZero;
    }
    [self changeModel:YES];
    [self.view bringSubviewToFront:self.backBtn];
    [self.inputBar setHidden:YES];
}

/**
 *  连接状态改变的回调
 *
 *  @param status <#status description#>
 */
- (void)onConnectionStatusChanged:(RCConnectionStatus)status {
    self.currentConnectionStatus = status;
}


- (void)praiseHeart{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(_clapBtn.frame.origin.x , _clapBtn.frame.origin.y - 49, 35, 35);
    imageView.image = [UIImage imageNamed:@"heart"];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.clipsToBounds = YES;
    [self.view addSubview:imageView];
    
    CGFloat startX = round(random() % 200);
    CGFloat scale = round(random() % 2) + 1.0;
    CGFloat speed = 1 / round(random() % 900) + 0.6;
    int imageName = round(random() % 7);
    NSLog(@"%.2f - %.2f -- %d",startX,scale,imageName);
    
    [UIView beginAnimations:nil context:(__bridge void *_Nullable)(imageView)];
    [UIView setAnimationDuration:7 * speed];
    
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"heart%d.png",imageName]];
    imageView.frame = CGRectMake(kBounds.width - startX, -100, 35 * scale, 35 * scale);
    
    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

- (void)praiseGift{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(_flowerBtn.frame.origin.x , _flowerBtn.frame.origin.y - 49, 35, 35);
    imageView.image = [UIImage imageNamed:@"gift"];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.clipsToBounds = YES;
    [self.view addSubview:imageView];
    
    
    CGFloat startX = round(random() % 200);
    CGFloat scale = round(random() % 2) + 1.0;
    CGFloat speed = 1 / round(random() % 900) + 0.6;
    int imageName = round(random() % 2);
    NSLog(@"%.2f - %.2f -- %d",startX,scale,imageName);
    
    [UIView beginAnimations:nil context:(__bridge void *_Nullable)(imageView)];
    [UIView setAnimationDuration:7 * speed];
    
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"gift%d.png",imageName]];
    imageView.frame = CGRectMake(kBounds.width - startX, -100, 35 * scale, 35 * scale);
    
    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    
    UIImageView *imageView = (__bridge UIImageView *)(context);
    [imageView removeFromSuperview];
}

- (void)sentLocalNotification
{
    
}
#pragma mark - orderLivingProtocol

- (void)didRequestOrderLivingSuccessed
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"预约成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    
    [[CourseraManager sharedManager] refreshLivingSectionStateOrder_complateWith:self.selectOrderLivingSectionInfoDic];
    self.livingListView.dataArr= [[CourseraManager sharedManager] getLivingSectionDetailArray];
    [self.livingListView.tableView reloadData];
}

- (void)didRequestOrderLivingFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestCancelOrderLivingSuccessed
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"取消预约成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    
    [[CourseraManager sharedManager] refreshLivingSectionStateOrder_complateWith:self.selectOrderLivingSectionInfoDic];
    self.livingListView.dataArr= [[CourseraManager sharedManager] getLivingSectionDetailArray];
    [self.livingListView.tableView reloadData];
}

- (void)didRequestCancelOrderLivingFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
#pragma mark - LivingSectionDetailProtocal

- (void)didRequestLivingSectionDetailSuccessed
{
    [SVProgressHUD dismiss];
    
    self.livingListView.dataArr = [[CourseraManager sharedManager] getLivingSectionDetailArray];
    [self.livingListView.tableView reloadData];
    
    
    for (NSDictionary * dic in self.livingListView.dataArr) {
        if ([[dic objectForKey:kCourseSecondID] isEqual:[self.infoDic objectForKey:kCourseSecondID]]) {
            self.infoDic = dic;
        }
    }
    
    switch ([[self.infoDic objectForKey:kLivingState] intValue]) {
        case 0:
        case 1:
            [self addLocalNotification:self.infoDic];
            break;
            
        default:
            break;
    }
    
    if ([[self.infoDic objectForKey:kIsLivingCourseFree] intValue] == 0 && [[self.infoDic objectForKey:kHaveJurisdiction] intValue] == 0) {
        [SVProgressHUD showErrorWithStatus:@"暂无观看权限"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [self setPlayStateViewIsLogin:YES];
        });
        return;
    }
    
    [self.segmentC showTitlesWith:@[@(2),@(3)]];
    
    [self joinChatRoom];
    
    self.livingListView.selectLivingSectionInfoDic = self.infoDic;
    [self.livingListView.tableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary *videoInfo = [NSDictionary dictionary];
        
        if (!self.playingVideo) {
            self.playingVideo = [[ZXVideo alloc] init];
        }
        if ([[self.infoDic objectForKey:kLivingState] intValue] == 3) {
            if (!self.isLivingCourse) {
                self.playingVideo.playUrl = [self.infoDic objectForKey:kPlayBackUrl];
            }
        }else{
            self.playingVideo.playUrl = [self.infoDic objectForKey:kCourseURL];
        }
        self.playingVideo.title = [self.infoDic objectForKey:kCourseName];
        
        NSLog(@"--- %@", videoInfo);
        
        [self playVideo:videoInfo];
        [self setPlayStateViewIsLogin:YES];
    });
    
}

- (void)didRequestLivingSectionDetailFailed:(NSString *)failedInfo
{
    if ([failedInfo isEqualToString:@"暂无数据"]) {
        failedInfo = @"暂无课程";
    }
    
    [SVProgressHUD dismiss];
    
    self.livingListView.dataArr = [[CourseraManager sharedManager] getLivingSectionDetailArray];
    [self.livingListView.tableView reloadData];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    
}



@end

