//
//  NSTimer+tool.m
//  Accountant
//
//  Created by aaa on 2017/11/10.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "NSTimer+tool.h"

@implementation NSTimer (tool)

+ (NSTimer *)qs_scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval executeBlock:(QSExecuteTimerBlock)block repeats:(BOOL)repeats{

    NSTimer *timer = [self scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(exquteTimer:) userInfo:[block copy] repeats:repeats];
    return timer;
}

+ (void)exquteTimer:(NSTimer *)timer
{
    QSExecuteTimerBlock block = timer.userInfo;
    if (block) {
        block(timer);
    }
}

@end
