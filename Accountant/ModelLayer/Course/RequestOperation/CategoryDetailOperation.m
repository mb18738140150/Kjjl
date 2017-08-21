//
//  CategoryDetailOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/4.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "CategoryDetailOperation.h"
#import "HttpRequestProtocol.h"
#import "CommonMacro.h"
#import "HttpRequestManager.h"
#import "CourseModel.h"
#import "CourseCategorysecondModel.h"
#import "UIUtility.h"

@interface CategoryDetailOperation ()<HttpRequestProtocol>

@property (nonatomic,weak) CourseCategoryDetailModel                            *categoryDetail;

@property (nonatomic,weak) id<CourseModule_CourseCategoryDetailProtocol>         courseDetailNotifiedObject;

@end

@implementation CategoryDetailOperation

- (void)setCurrentCourseCategoryDetailModel:(CourseCategoryDetailModel *)model
{
    self.categoryDetail = model;
}

- (void)didRequestCategoryDetailWithCategoryId:(int)categoryId andUserId:(int)userId withNotified:(id<CourseModule_CourseCategoryDetailProtocol>)object
{
    self.courseDetailNotifiedObject = object;
    [[HttpRequestManager sharedManager] requestCategoryDetailWithCategoryId:categoryId andUserId:userId andProcessDelegate:self];
}

#pragma mark - http delegate
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    
    [self.categoryDetail removeAllCourses];
    
    NSArray * cateArr = [successInfo objectForKey:@"catelist"];
    NSArray *data = [successInfo objectForKey:@"data"];
    
    if (cateArr.count == 0) {
        CourseCategorysecondModel * secondModel = [[CourseCategorysecondModel alloc]init];
        secondModel.categorySecondId = 0;
        secondModel.categorySecondName = @"";
        secondModel.categorySecondImageUrl = @"";
        for (NSDictionary *tmpDic in data) {
            CourseModel *courseModel = [[CourseModel alloc] init];
            courseModel.courseID = [[tmpDic objectForKey:@"id"] intValue];
            courseModel.courseName = [tmpDic objectForKey:@"courseName"];
            courseModel.courseCover = [tmpDic objectForKey:@"cover"];
            courseModel.coueseTeacherName = [UIUtility judgeStr:[tmpDic objectForKey:@"teacherName"]];
            [secondModel addCourseModel:courseModel];
        }
        [self.categoryDetail addCourse:secondModel];
    }else
    {
        for (NSDictionary * secondDic in cateArr) {
            CourseCategorysecondModel * secondModel = [[CourseCategorysecondModel alloc]init];
            secondModel.categorySecondId = [[secondDic objectForKey:@"id"] intValue];
            secondModel.categorySecondName = [secondDic objectForKey:@"name"];
            secondModel.categorySecondImageUrl = [secondDic objectForKey:@"cover"];
            NSArray *courseArray = [secondDic objectForKey:@"courseList"];
            for (NSDictionary *courseDic in courseArray) {
                CourseModel *courseModel = [[CourseModel alloc] init];
                courseModel.courseName = [courseDic objectForKey:@"courseName"];
                courseModel.courseCover = [courseDic objectForKey:@"cover"];
                courseModel.courseID = [[courseDic objectForKey:@"id"] intValue];
                courseModel.coueseTeacherName = [UIUtility judgeStr:[courseDic objectForKey:@"teacherName"]];
                [secondModel addCourseModel:courseModel];
            }
            [self.categoryDetail addCourse:secondModel];
        }
    }
    
    
    if (isObjectNotNil(self.courseDetailNotifiedObject)) {
        [self.courseDetailNotifiedObject didReuquestCourseCategoryDetailSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.courseDetailNotifiedObject)) {
        [self.courseDetailNotifiedObject didReuquestCourseCategoryDetailFailed:failInfo];
    }
}

@end
