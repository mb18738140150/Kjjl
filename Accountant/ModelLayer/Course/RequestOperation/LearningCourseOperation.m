//
//  LearningCourseOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "LearningCourseOperation.h"
#import "HttpRequestManager.h"
#import "CourseraManager.h"
#import "CourseModel.h"
#import "CommonMacro.h"

@interface LearningCourseOperation ()<HttpRequestProtocol>

@end

@implementation LearningCourseOperation

- (void)didRequestLearningCourseWithNotifiedObject:(id<CourseModule_LearningCourseProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestLearingCourseWithProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [self.learningCourseArray removeAllObjects];
    NSArray *data = [successInfo objectForKey:@"data"];
    for (NSDictionary *dic in data) {
        CourseModel *model = [[CourseModel alloc] init];
        model.courseID = [[dic objectForKey:@"id"] intValue];
        model.courseName = [dic objectForKey:@"courseName"];
        model.courseCover = [dic objectForKey:@"cover"];
        [self.learningCourseArray addObject:model];
    }
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestLearningCourseSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestLearningCourseFailed:failInfo];
    }
}

@end
