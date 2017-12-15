//
//  NSTimer+tool.h
//  Accountant
//
//  Created by aaa on 2017/11/10.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^QSExecuteTimerBlock)(NSTimer *timer);

@interface NSTimer (tool)

+ (NSTimer *)qs_scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval executeBlock:(QSExecuteTimerBlock)block repeats:(BOOL)repeats;

@end
