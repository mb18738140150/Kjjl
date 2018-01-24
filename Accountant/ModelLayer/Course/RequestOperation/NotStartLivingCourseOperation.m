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

@property (nonatomic, weak)HottestCourseModel       *myHostModel;

@property (nonatomic, assign)int command;

@property (nonatomic,assign)int haveJurisdiction;
@end

@implementation NotStartLivingCourseOperation


- (void)setCurrentNotStartLivingCourseWithModel:(HottestCourseModel *)model
{
    self.hottestModel = model;
}

- (void)setMyLivingCourseWithModel:(HottestCourseModel *)model
{
    self.myHostModel = model;
}

- (void)didRequestNotStartLivingCourseWithInfo:(NSDictionary *)infoDic NotifiedObject:(id<CourseModule_NotStartLivingCourse>)delegate
{
    self.command = 31;
    self.notifiedObject = delegate;
    [[HttpRequestManager sharedManager] requestGetNotStartLivingCourseWithInfo:infoDic ProcessDelegate:self];
}

- (void)didRequestMyLivingCourseWithInfo:(NSDictionary *)infoDic NotifiedObject:(id<CourseModule_MyLivingCourse>)object
{
    self.command = 47;
    self.myNotifiedObject = object;
    [[HttpRequestManager sharedManager] requestGetMyLivingCourseWithInfo:infoDic ProcessDelegate:self];
}

#pragma mark - http delegate
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    NSLog(@"successInfo = %@", [successInfo description]);
    
    if (self.command == 31) {
        [self.hottestModel removeAllCourses];
        
        self.haveJurisdiction = [[successInfo objectForKey:@"haveJurisdiction"] intValue];
        NSArray *courses = [successInfo objectForKey:@"data"];
        for (NSDictionary *dic in courses){
            CourseModel *courseModel = [[CourseModel alloc] initWithHosttestDicInfo:dic];
            [self.hottestModel addCourse:courseModel];
        }
        
        NSArray *SectionCourses = [successInfo objectForKey:@"teacherData"];
        for (NSDictionary *dic in SectionCourses){
            TeacherModel *teacherModel = [[TeacherModel alloc] initWithInfoDic:dic];
            [self.hottestModel addTeacher:teacherModel];
        }
        
        if (self.notifiedObject != nil) {
            [self.notifiedObject didRequestNotStartLivingCourseSuccessed];
        }
    }else
    {
        [self.myHostModel removeAllCourses];
        
        NSArray *courses = [successInfo objectForKey:@"data"];
        for (NSDictionary *dic in courses){
            CourseModel *courseModel = [[CourseModel alloc] initWithHosttestDicInfo:dic];
            [self.myHostModel addCourse:courseModel];
        }
        
        if (self.myNotifiedObject != nil) {
            [self.myNotifiedObject didRequestMyLivingCourseSuccessed];
        }
    }
    
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (self.command == 31) {
        [self.hottestModel removeAllCourses];
        if (self.notifiedObject != nil) {
            [self.notifiedObject didRequestNotStartLivingCourseFailed:failInfo];
        }
    }else
    {
        [self.myHostModel removeAllCourses];
        if (self.myNotifiedObject != nil) {
            [self.myNotifiedObject didRequestMyLivingCourseFailed:failInfo];
        }
    }
}

- (int)getIsHaveJurisdiction
{
    return self.haveJurisdiction;
}

@end
