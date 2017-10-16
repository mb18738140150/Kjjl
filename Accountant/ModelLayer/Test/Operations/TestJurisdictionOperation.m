//
//  TestJurisdictionOperation.m
//  Accountant
//
//  Created by aaa on 2017/9/4.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestJurisdictionOperation.h"
#import "HttpRequestManager.h"
#import "CommonMacro.h"
@interface TestJurisdictionOperation ()<HttpRequestProtocol>

@end

@implementation TestJurisdictionOperation

- (void)didJurisdictionWithCourseId:(int)courseId andNotifiedObject:(id<TestModule_JurisdictionProtocol>)object
{
    self.jurisdictionNotifiedObject = object;
    
    [[HttpRequestManager sharedManager] requestTestJurisdictionWithId:courseId andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if (isObjectNotNil(self.jurisdictionNotifiedObject)) {
        [self.jurisdictionNotifiedObject didRequestJurisdictionSuccess];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.jurisdictionNotifiedObject)) {
        [self.jurisdictionNotifiedObject didRequestJurisdictionFailed:failInfo];
    }
    
}

@end
