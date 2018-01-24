//
//  DeleteCollectCourseOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/21.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DeleteCollectCourseOperation.h"
#import "HttpRequestManager.h"
#import "CommonMacro.h"

@interface DeleteCollectCourseOperation ()<HttpRequestProtocol>

@end

@implementation DeleteCollectCourseOperation

- (void)didRequestDeleteMyLearningCourseWithInfo:(NSDictionary *)infoDic andNotifiedObject:(id<CourseModule_DeleteCollectCourseProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestDeleteMyLearningCourseWithCourseInfo:infoDic andProcessDelegate:self];
}

- (void)didRequestDeleteCollectCourseWithId:(int)courseId andNotifiedObject:(id<CourseModule_DeleteCollectCourseProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestDeleteCollectCourseWithCourseId:courseId andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestDeleteCollectCourseSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestDeleteCollectCourseFailed:failInfo];
    }
    
}

@end
