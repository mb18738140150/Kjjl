//
//  QuestionPublishOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/13.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "QuestionPublishOperation.h"
#import "HttpRequestManager.h"
#import "CommonMacro.h"

@interface QuestionPublishOperation ()<HttpRequestProtocol>

@end

@implementation QuestionPublishOperation

- (void)didPublishQuestion:(NSDictionary *)questionInfo withNotifiedObject:(id<QuestionModule_QuestionPublishProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestQuestionPublishWithInfo:questionInfo andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didQuestionPublishSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didQuestionPublishFailed:failInfo];
    }
}

@end
