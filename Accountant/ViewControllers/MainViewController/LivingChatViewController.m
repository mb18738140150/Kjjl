//
//  LivingChatViewController.m
//  Accountant
//
//  Created by aaa on 2017/8/7.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "LivingChatViewController.h"
#import "ZXVideo.h"

#import "ZXVideoPlayerController.h"

#define kChatViewheight kScreenHeight - 42 - kZXVideoPlayerOriginalHeight
#define kChatView_top 42 + kZXVideoPlayerOriginalHeight
@interface LivingChatViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) ZXVideoPlayerController           *videoController;
@property (nonatomic,strong) ZXVideo                            *playingVideo;
@end

@implementation LivingChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self navigationViewSetup];
    [self setUpUI];
    [self notifyUpdateUnreadMessageCount];
    self.displayUserNameInCell = NO;
    self.navigationItem.rightBarButtonItem = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer
                                      *)gestureRecognizer{
    return NO; //YES：允许右滑返回  NO：禁止右滑返回
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50};
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpUI
{
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:2];
    [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlDefaultType
                                               style:RC_CHAT_INPUT_BAR_STYLE_CONTAINER];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.view setBounds:CGRectMake(0,kChatView_top, kScreenWidth, kScreenHeight)];
        
        self.conversationMessageCollectionView.frame = CGRectMake(0, kChatView_top, kScreenWidth, (kChatViewheight - 50));
        self.chatSessionInputBarControl.hd_y = kChatView_top + self.conversationMessageCollectionView.hd_height;
        [self scrollToBottomAnimated:YES];
        
        NSLog(@"%.2f  ** %.2f", self.conversationMessageCollectionView.hd_height,self.conversationMessageCollectionView.hd_y);
        
    });
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)leftBarButtonItemPressed:(id)sender {
    //需要调用super的实现
    [super leftBarButtonItemPressed:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)notifyUpdateUnreadMessageCount {
    __weak typeof(&*self) __weakself = self;
    int count = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                @(ConversationType_PRIVATE),
                                                                @(ConversationType_DISCUSSION),
                                                                @(ConversationType_APPSERVICE),
                                                                @(ConversationType_PUBLICSERVICE),
                                                                @(ConversationType_GROUP)
                                                                ]];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *backString = nil;
        if (count > 0 && count < 1000) {
            backString = [NSString stringWithFormat:@"返回(%d)", count];
        } else if (count >= 1000) {
            backString = @"返回(...)";
        } else {
            backString = @"返回";
        }
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 6, 87, 33);
        UIImageView *backImg = [[UIImageView alloc]
                                initWithImage:[UIImage imageNamed:@"public-返回"]];
        //    backImg.frame = CGRectMake(-6, 4, 10, 17);
        backImg.frame = CGRectMake(-6, 4, 45, 33);
        //    [backBtn addSubview:backImg];
        UILabel *backText =
        [[UILabel alloc] initWithFrame:CGRectMake(9, 4, 85, 17)];
        backText.text = backString; // NSLocalizedStringFromTable(@"Back",
        // @"RongCloudKit", nil);
        //   backText.font = [UIFont systemFontOfSize:17];
        [backText setBackgroundColor:[UIColor clearColor]];
        [backText setTextColor:kCommonMainColor];
        //    [backBtn addSubview:backText];
        
        backBtn.frame = CGRectMake(0, 0, 45, 33);
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [backBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        
        [backBtn setImage:[[UIImage imageNamed:@"public-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        [backBtn addTarget:__weakself
                    action:@selector(leftBarButtonItemPressed:)
          forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftButton =
        [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        [__weakself.navigationItem setLeftBarButtonItem:leftButton];
    });
}


- (void)didSendMessage:(NSInteger)status
               content:(RCMessageContent *)messageContent
{
    [super didSendMessage:status content:messageContent];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.chatSessionInputBarControl updateStatus:KBottomBarDefaultStatus animated:YES];
    });
}

- (void)popupChatViewController {
    [super leftBarButtonItemPressed:nil];
}


#pragma mark - 键盘监听事件
- (void)keyboardWillShow:(NSNotification *)note
{
    
    CGRect begin = [[[note userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    
    CGRect end = [[[note userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        self.conversationMessageCollectionView.hd_height = kChatViewheight - end.size.height - 50;
//        self.chatSessionInputBarControl.hd_y = self.conversationMessageCollectionView.hd_height;
        
    });
}

-(void)keyboardWillHide:(NSNotification *)note{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        self.conversationMessageCollectionView.frame = CGRectMake(0, kChatView_top, kScreenWidth, (kChatViewheight - 50));
//        self.chatSessionInputBarControl.hd_y = self.conversationMessageCollectionView.hd_height;
    });
}

@end
