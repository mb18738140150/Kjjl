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

@property (nonatomic, strong)NSDictionary *infoDic;

@end

@implementation LearningCourseOperation

- (NSMutableArray *)learningCourseArray
{
    if (!_learningCourseArray) {
        _learningCourseArray = [NSMutableArray array];
    }
    return _learningCourseArray;
}

- (NSMutableArray *)completeCourseArray
{
    if (!_completeCourseArray) {
        _completeCourseArray = [NSMutableArray array];
    }
    return _completeCourseArray;
}

- (void)didRequestLearningCourseWith:(NSDictionary *)infoDic NotifiedObject:(id<CourseModule_LearningCourseProtocol>)object
{
    self.infoDic = infoDic;
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestLearingCourseWithInfoDic:infoDic ProcessDelegate:self];
}

- (void)didRequestCompleteCourseWith:(NSDictionary *)infoDic NotifiedObject:(id<CourseModule_CompleteCourseProtocol>)object
{
    self.infoDic = infoDic;
    self.complateNotifiedObject = object;
    [[HttpRequestManager sharedManager] requestLearingCourseWithInfoDic:infoDic ProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if ([[self.infoDic objectForKey:@"type"] intValue] == 0) {
        [self.learningCourseArray removeAllObjects];
        NSArray *data = [successInfo objectForKey:@"data"];
        for (NSDictionary *dic in data) {
            CourseModel *model = [[CourseModel alloc] init];
            model.courseID = [[dic objectForKey:@"id"] intValue];
            model.courseName = [dic objectForKey:@"courseName"];
            model.courseCover = [dic objectForKey:@"cover"];
            model.coueseTeacherName = [dic objectForKey:@"teacherName"];
            model.learnProgress = [[dic objectForKey:@"learnProgress"] doubleValue];
            model.lastTime = [dic objectForKey:@"lastLearnTime"];
            [self.learningCourseArray addObject:model];
        }
        if (isObjectNotNil(self.notifiedObject)) {
            [self.notifiedObject didRequestLearningCourseSuccessed];
        }
    }else
    {
        [self.completeCourseArray removeAllObjects];
        NSArray *data = [successInfo objectForKey:@"data"];
        for (NSDictionary *dic in data) {
            CourseModel *model = [[CourseModel alloc] init];
            model.courseID = [[dic objectForKey:@"id"] intValue];
            model.courseName = [dic objectForKey:@"courseName"];
            model.courseCover = [dic objectForKey:@"cover"];
            model.coueseTeacherName = [dic objectForKey:@"teacherName"];
            model.learnProgress = [[dic objectForKey:@"learnProgress"] doubleValue];
            model.lastTime = [dic objectForKey:@"lastLearnTime"];
            [self.completeCourseArray addObject:model];
        }
        if (isObjectNotNil(self.complateNotifiedObject)) {
            [self.complateNotifiedObject didRequestCompleteCourseSuccessed];
        }
    }
    
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if ([[self.infoDic objectForKey:@"type"] intValue] == 0) {
    
        if (isObjectNotNil(self.notifiedObject)) {
            [self.notifiedObject didRequestLearningCourseFailed:failInfo];
        }
    }else
    {
        if (isObjectNotNil(self.complateNotifiedObject)) {
            [self.complateNotifiedObject didRequestCompleteCourseFailed:failInfo];
        }
    }
    
    
}

@end
