//
//  HottestCourseOperation.m
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "HottestCourseOperation.h"
#import "HttpRequestManager.h"
#import "CourseModel+HottestCourse.h"
#import "NotificaitonMacro.h"


@interface HottestCourseOperation ()<HttpRequestProtocol>

@property (nonatomic,weak) HottestCourseModel       *hottestModel;
@property (nonatomic,weak) id<CourseModule_HottestCourseProtocl>             notifiedObject;

@end

@implementation HottestCourseOperation

- (void)setCurrentHottestCoursesWithModel:(HottestCourseModel *)model
{
    self.hottestModel = model;
}

- (void)didRequestHosttestCourseWithNotifiedObject:(id<CourseModule_HottestCourseProtocl>)delegate
{
    self.notifiedObject = delegate;
    [[HttpRequestManager sharedManager] requestHottestCourseWithProcessDelegate:self];
}

#pragma mark - http delegate
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [self.hottestModel removeAllCourses];
    
    
    NSArray *courses = [successInfo objectForKey:@"data"];
    for (NSDictionary *dic in courses){
        CourseModel *courseModel = [[CourseModel alloc] initWithHosttestDicInfo:dic];
        [self.hottestModel addCourse:courseModel];
    }
    if (self.notifiedObject != nil) {
        [self.notifiedObject didRequestHottestCourseSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (self.notifiedObject != nil) {
        [self.notifiedObject didRequestHottestFailed];
    }
}

@end
