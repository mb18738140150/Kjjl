//
//  AddCollectCourseOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/21.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "AddCollectCourseOperation.h"
#import "HttpRequestManager.h"
#import "CommonMacro.h"

@interface AddCollectCourseOperation ()<HttpRequestProtocol>

@end

@implementation AddCollectCourseOperation

- (void)didRequestAddCollectCourseWithId:(int)courseId andNotifiedObject:(id<CourseModule_AddCollectCourseProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestAddCollectCourseWithCourseId:courseId andProcessDelegate:self];
}

#pragma mark - http delegate
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestAddCollectCourseSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestAddCollectCourseFailed:failInfo];
    }
}

@end
