//
//  TestSimulateInfoOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/22.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestSimulateInfoOperation.h"
#import "CommonMacro.h"
#import "HttpRequestManager.h"
#import "TestSimulateModel.h"

@interface TestSimulateInfoOperation ()<HttpRequestProtocol>

@end

@implementation TestSimulateInfoOperation

- (void)didRequestTestSimulateInfoWithCategoryId:(int)cateId andNotifiedObject:(id<TestModule_SimulateInfoProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestTestSimulateInfoWithCateId:cateId andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [self.simulateArray removeAllObjects];
    NSArray *data = [successInfo objectForKey:@"data"];
    for (NSDictionary *dic in data) {
        TestSimulateModel *model = [[TestSimulateModel alloc] init];
        model.simulateId = [[dic objectForKey:@"id"] intValue];
        model.simulateName = [dic objectForKey:@"name"];
        model.simulateQuestionCount = [[dic objectForKey:@"questionCount"] intValue];
        [self.simulateArray addObject:model];
    }
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestSimulateInfoSuccess];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestSimulateInfoFailed:failInfo];
    }
}

@end
