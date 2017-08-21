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

- (void)didRequestTestAllCategoryWithNotifiedObject:(id<TestModule_AllCategoryProtocol>)notifiedObject
{
    self.notifiedObject = notifiedObject;
    [[HttpRequestManager sharedManager] requestTestAllCategoryWithProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [self.allCategoryArray removeAllObjects];
}

- (void)didRequestFailed:(NSString *)failInfo
{
    
}

@end
