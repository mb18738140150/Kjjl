//
//  EndLivingCourseOperation.m
//  Accountant
//
//  Created by aaa on 2017/6/30.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "EndLivingCourseOperation.h"

#import "HottestCourseModel.h"
#import "HttpRequestManager.h"
#import "CourseModel+HottestCourse.h"
@interface EndLivingCourseOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) HottestCourseModel       *hottestModel;
@end

@implementation EndLivingCourseOperation


- (void)setCurrentEndLivingCourseWithModel:(HottestCourseModel *)model
{
    self.hottestModel = model;
}

- (void)didRequestEndLivingCourseWithNotifiedObject:(id<CourseModule_EndLivingCourse>)delegate
{
    self.notifiedObject = delegate;
    [[HttpRequestManager sharedManager] requestGetEndLivingCourseWithProcessDelegate:self];
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
        [self.notifiedObject didRequestEndLivingCourseSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (self.notifiedObject != nil) {
        [self.notifiedObject didRequestEndLivingCourseFailed:failInfo];
    }
}
@end
