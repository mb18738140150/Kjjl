//
//  TestUncollectionQuestionOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/30.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestUncollectionQuestionOperation.h"
#import "HttpRequestManager.h"
#import "CommonMacro.h"

@interface TestUncollectionQuestionOperation ()<HttpRequestProtocol>

@end

@implementation TestUncollectionQuestionOperation

- (void)didUncollectQuestionWithQuestionId:(int)questionId andNotifiedObject:(id<TestModule_UncollectQuestionProtocol>)object
{
    self.uncollectNotifiedObject = object;
    [[HttpRequestManager sharedManager] requestTestUncollectQuestionWithId:questionId andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if (isObjectNotNil(self.uncollectNotifiedObject)) {
        [self.uncollectNotifiedObject didRequestUncollectQuestionSuccess];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.uncollectNotifiedObject)) {
        [self.uncollectNotifiedObject didRequestUncollectQuestionFailed:failInfo];
    }
    
}

@end
