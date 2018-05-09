//
//  TestAllCategoryOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/18.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestAllCategoryOperation.h"
#import "HttpRequestManager.h"

@interface TestAllCategoryOperation ()<HttpRequestProtocol>

@property (nonatomic,weak) id<TestModule_AllCategoryProtocol>            notifiedObject;

@end

@implementation TestAllCategoryOperation

- (NSMutableArray *)allCategoryArray
{
    if (!_allCategoryArray) {
        _allCategoryArray = [NSMutableArray array];
    }
    return _allCategoryArray;
}

- (void)didRequestTestAllCategoryWithNotifiedObject:(id<TestModule_AllCategoryProtocol>)notifiedObject
{
    self.notifiedObject = notifiedObject;
    [[HttpRequestManager sharedManager] requestTestAllCategoryWithProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.allCategoryArray = [successInfo objectForKey:@"data"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestAllTestCategorySuccess];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestAllTestCategoryFailed:failInfo];
    }
}

- (void)didRequestFailedWithInfo:(NSDictionary *)failedInfo
{
    self.allCategoryArray = [failedInfo objectForKey:@"data"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestAllTestCategorySuccess];
    }
}

@end
