//
//  TestRecordOperation.m
//  Accountant
//
//  Created by aaa on 2018/1/19.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "TestRecordOperation.h"
#import "HttpRequestManager.h"
#import "CommonMacro.h"
@interface TestRecordOperation ()<HttpRequestProtocol>

@end

@implementation TestRecordOperation

- (void)didRequestTestRecordWithInfo:(NSDictionary *)infoDic andNotifiedObject:(id<TestModule_TestRecord>)object
{
    self.testRecordNotifiedObject = object;
    
    [[HttpRequestManager sharedManager] reqeustTestRecordWithInfo:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.dataArray = [successInfo objectForKey:@"data"];
    if (isObjectNotNil(self.testRecordNotifiedObject)) {
        [self.testRecordNotifiedObject didRequestTestRecordSuccess];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.testRecordNotifiedObject)) {
        [self.testRecordNotifiedObject didRequestTestRecordFailed:failInfo];
    }
    
}

@end
