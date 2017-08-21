//
//  DelayButton+helper.m
//  Accountant
//
//  Created by aaa on 2017/4/17.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DelayButton+helper.h"
#import <objc/runtime.h>

// 默认按钮点击间隔时间
static const NSTimeInterval defaultDuration = 1.0f;

// 记录是否忽略
static BOOL _isIgnoreEvent = NO;

// 设置执行按钮事件状态
static void resetState(){
    _isIgnoreEvent = NO;
}

@implementation DelayButton (helper)
@dynamic clickDurationTime;

+(void)load
{
    SEL originSEL = @selector(sendAction:to:forEvent:);
    SEL mySEL = @selector(my_sendAction:to:forEvent:);
    
    Method originM = class_getInstanceMethod([self class], originSEL);
    const char *typeEncodeinds = method_getTypeEncoding(originM);
    
    Method newM = class_getInstanceMethod([self class], mySEL);
    IMP newIMP = method_getImplementation(newM);
    
    if (class_addMethod([self class], mySEL, newIMP, typeEncodeinds)) {
        class_replaceMethod([self class], originSEL, newIMP, typeEncodeinds);
    }else
    {
        method_exchangeImplementations(originM, newM);
        
    }
    
}
- (void)my_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    if ([self isKindOfClass:[UIButton class]]) {
        self.clickDurationTime = self.clickDurationTime == 0 ?defaultDuration:self.clickDurationTime;
        if (_isIgnoreEvent) {
            return;
        }else
        {
            _isIgnoreEvent = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.clickDurationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                resetState();
            });
        }
        
        [self my_sendAction:action to:target forEvent:event];
    }else
    {
        [self my_sendAction:action to:target forEvent:event];
    }
}

- (void)setClickDurationTime:(NSTimeInterval)clickDurationTime
{
    objc_setAssociatedObject(self, @selector(clickDurationTime), @(clickDurationTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)clickDurationTime
{
    return [objc_getAssociatedObject(self, @selector(clickDurationTime)) doubleValue];
}

@end
