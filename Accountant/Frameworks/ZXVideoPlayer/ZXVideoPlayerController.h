//
//  ZXVideoPlayerController.h
//  ZXVideoPlayer
//
//  Created by Shawn on 16/4/21.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXVideo.h"
@import MediaPlayer;

#define kZXVideoPlayerOriginalWidth  MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define kZXVideoPlayerOriginalHeight (kZXVideoPlayerOriginalWidth * (9.0 / 16.0))


typedef enum : NSUInteger {
    CurrentRate_1=1,
    CurrentRate_2,
    CurrentRate_3,
} CurrentRate;

@interface ZXVideoPlayerController : MPMoviePlayerController

@property (nonatomic, assign) CGRect frame;
/// video model
@property (nonatomic, strong, readwrite) ZXVideo *video;
/// 竖屏模式下点击返回
@property (nonatomic, copy) void(^videoPlayerGoBackBlock)(void);
@property (nonatomic, copy) void(^videoPlayerGoBackWithPlayTimeBlock)(double time);

/// 将要切换到竖屏模式
@property (nonatomic, copy) void(^videoPlayerWillChangeToOriginalScreenModeBlock)();
/// 将要切换到全屏模式
@property (nonatomic, copy) void(^videoPlayerWillChangeToFullScreenModeBlock)();

@property (nonatomic, assign)CurrentRate rate;

/// 非正式会员只可试听第一节5分钟
@property (nonatomic, copy) void(^informalBlock)();

- (instancetype)initWithFrame:(CGRect)frame;
/// 展示播放器
- (void)showInView:(UIView *)view;

- (void)changePlayer;

- (void)pausePlay;

- (void)startPlay;

- (void)backstop;

@end
