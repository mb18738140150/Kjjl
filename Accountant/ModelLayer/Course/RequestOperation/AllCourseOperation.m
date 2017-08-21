//
//  AllCourseOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/1.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "AllCourseOperation.h"
#import "HttpRequestProtocol.h"
#import "HttpRequestManager.h"

@interface AllCourseOperation ()<HttpRequestProtocol>

@property (nonatomic,weak) AllCourseModel       *allCourseModel;
@property (nonatomic,weak) id<CourseModule_AllCourseProtocol>    notifiedDelegate;

@end

@implementation AllCourseOperation

- (void)setCurrentAllCourseModel:(AllCourseModel *)model
{
    self.allCourseModel = model;
}

- (void)didRequestAllCourseWithNotifiedObject:(id<CourseModule_AllCourseProtocol>)delegate
{
    self.notifiedDelegate = delegate;
    [[HttpRequestManager sharedManager] requestAllCourseWithProcessDelegate:self];
}

#pragma mark - delegate func
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [self.allCourseModel removeAllCourses];
    NSArray *data = [successInfo objectForKey:@"data"];
    for (NSDictionary *dic in data) {
        CourseModel *courseModel = [[CourseModel alloc] init];
        courseModel.courseName = [dic objectForKey:@"courseName"];
        courseModel.courseCover = [dic objectForKey:@"cover"];
        courseModel.courseID = [[dic objectForKey:@"id"] intValue];
        courseModel.coueseTeacherName = [dic objectForKey:@"teacherName"];
        if ([courseModel.coueseTeacherName isKindOfClass:[NSNull class]] || !courseModel.coueseTeacherName) {
            courseModel.coueseTeacherName = @"";
        }
        [self.allCourseModel addCourseModel:courseModel];
    }
    if (self.notifiedDelegate != nil) {
        [self.notifiedDelegate didRequestAllCourseSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (self.notifiedDelegate != nil) {
        [self.notifiedDelegate didRequestAllCourseFailed];
    }
}

@end
