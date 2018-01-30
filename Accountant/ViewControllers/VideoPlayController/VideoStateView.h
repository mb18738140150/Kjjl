//
//  VideoStateView.h
//  Accountant
//
//  Created by aaa on 2018/1/16.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    VideoState_notLogin,
    VideoState_noJurisdiction,
    VideoState_haveJurisdiction,
    VideoState_shikanEnd,
} VideoState;

@interface VideoStateView : UIView

@property (nonatomic, strong)NSDictionary * infoDic;
@property (nonatomic, copy)void(^loginClickBlock)(VideoState videoState, NSDictionary *infoDic);
@property (nonatomic, copy)void(^BackClickBlock)();

@property (nonatomic, assign)VideoState state;

- (void)resetWithInfoDic:(NSDictionary *)infoDic;

@end
