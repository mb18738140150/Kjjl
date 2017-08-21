//
//  NotStartLivingCourseOperation.m
//  Accountant
//
//  Created by aaa on 2017/6/30.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "NotStartLivingCourseOperation.h"
#import "HottestCourseModel.h"
#import "HttpRequestManager.h"
#import "CourseModel+HottestCourse.h"
@interface NotStartLivingCourseOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) HottestCourseModel       *hottestModel;
@end

@implementation NotStartLivingCourseOperation


- (void)setCurrentNotStartLivingCourseWithModel:(HottestCourseModel *)model
{
    self.hottestModel = model;
}

- (void)didRequestNotStartLivingCourseWithNotifiedObject:(id<CourseModule_NotStartLivingCourse>)delegate
{
    self.notifiedObject = delegate;
    [[HttpRequestManager sharedManager] requestGetNotStartLivingCourseWithProcessDelegate:self];
}

#pragma mark - http delegate
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [self.hottestModel removeAllCourses];
    
//    NSLog(@"%@",[successInfo description]);
    
    NSArray *courses = [successInfo objectForKey:@"data"];
    for (NSDictionary *dic in courses){
        CourseModel *courseModel = [[CourseModel alloc] initWithHosttestDicInfo:dic];
        [self.hottestModel addCourse:courseModel];
    }
    if (self.notifiedObject != nil) {
        [self.notifiedObject didRequestNotStartLivingCourseSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (self.notifiedObject != nil) {
        [self.notifiedObject didRequestNotStartLivingCourseFailed:failInfo];
    }
}

@end
