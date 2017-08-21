//
//  TestSimulateScoreOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/22.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestSimulateScoreOperation.h"
#import "HttpRequestManager.h"

@interface TestSimulateScoreOperation ()<HttpRequestProtocol>

@end


@implementation TestSimulateScoreOperation

- (void)didRequestSimulateScoreWithInfo:(NSArray *)array andNotifedObject:(id<TestModule_SimulateScoreProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestTestSimulateScoreWithInfo:array andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    NSLog(@"%@",successInfo);
}

- (void)didRequestFailed:(NSString *)failInfo
{
    
}

@end
