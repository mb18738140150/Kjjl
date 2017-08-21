//
//  TestQuestionHistoryOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/30.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestQuestionHistoryOperation.h"
#import "CommonMacro.h"
#import "HttpRequestManager.h"


@interface TestQuestionHistoryOperation ()<HttpRequestProtocol>

@end

@implementation TestQuestionHistoryOperation

- (void)didRequesAddQuestionHistoryWithInfo:(NSDictionary *)info andNotifedObject:(id<TestModule_AddHistoryProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustTestAddQuestionHistoryWithInfo:info andProcessDelegate:self];
}

- (void)didRequestAddQuestionHistoryDetailWithInfo:(NSDictionary *)info
{
    [[HttpRequestManager sharedManager] requestTestAddQuestionDetailHistoryWithInfo:info andProcessDelegate:nil];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    int logId = [[successInfo objectForKey:@"logId"] intValue];
    self.moduleModel.logId = logId;
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestAddHistorySuccess];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    self.moduleModel.logId = 0;
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestAddHistoryFailed:failInfo];
    }
}

@end
