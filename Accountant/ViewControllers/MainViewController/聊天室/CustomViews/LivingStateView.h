//
//  LivingStateView.h
//  Accountant
//
//  Created by aaa on 2017/9/14.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LivingState_noStart,
    LivingState_living,
    LivingState_end,
    LivingState_notLogin,
} LivingState;

@interface LivingStateView : UIView

@property (nonatomic, strong)NSDictionary * infoDic;
@property (nonatomic, copy)void(^loginClickBlock)();

- (void)resetWithInfoDic:(NSDictionary *)infoDic andIsLogin:(BOOL)isLogin;

- (void)resetWithInfoDic:(NSDictionary *)infoDic;

- (void)setStateWith:(LivingState)livingState;

- (void)timerInvalidate;

@end
