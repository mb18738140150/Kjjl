//
//  TestMyCollectionQuestionOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/30.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestMyCollectionQuestionOperation.h"
#import "HttpRequestManager.h"
#import "CommonMacro.h"

@interface TestMyCollectionQuestionOperation ()<HttpRequestProtocol>

@end

@implementation TestMyCollectionQuestionOperation

- (void)didCollectQuestionWithQuestionId:(int)questionId andNotifiedObject:(id<TestModule_CollectQuestionProtocol>)object
{
    self.collectNotifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustTestCollectQuestionWithId:questionId andProcessDelegate:self];
}



- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if (isObjectNotNil(self.collectNotifiedObject)) {
        [self.collectNotifiedObject didRequestCollectQuestionSuccess];
    }
  
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.collectNotifiedObject)) {
        [self.collectNotifiedObject didRequestCollectQuestionFailed:failInfo];
    }

}

@end
