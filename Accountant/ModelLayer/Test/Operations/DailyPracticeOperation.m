//
//  DailyPracticeOperation.m
//  Accountant
//
//  Created by aaa on 2018/1/20.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "DailyPracticeOperation.h"

#import "HttpRequestManager.h"
#import "CommonMacro.h"
@interface DailyPracticeOperation ()<HttpRequestProtocol>

@end

@implementation DailyPracticeOperation

- (void)didRequestTestDailyPracticeWithInfo:(NSDictionary *)infoDic andNotifiedObject:(id<TestModule_TestDailyPractice>)object
{
    self.testDailyPracticeNotifiedObject = object;
    
    [[HttpRequestManager sharedManager] reqeustTestDailyPracticeWithInfo:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.dataArray = [successInfo objectForKey:@"data"];
    self.lastDataArray = [successInfo objectForKey:@"lastData"];
    
    if (isObjectNotNil(self.testDailyPracticeNotifiedObject)) {
        [self.testDailyPracticeNotifiedObject didRequestTestDailyPracticeSuccess];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.testDailyPracticeNotifiedObject)) {
        [self.testDailyPracticeNotifiedObject didRequestTestDailyPracticeFailed:failInfo];
    }
    
}

@end
