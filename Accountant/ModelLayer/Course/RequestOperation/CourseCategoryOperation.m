//
//  CourseCategoryOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/3.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "CourseCategoryOperation.h"
#import "CommonMacro.h"
#import "HttpRequestManager.h"
#import "CourseCategorysecondModel.h"

@interface CourseCategoryOperation ()<HttpRequestProtocol>

@property (nonatomic,weak) AllCourseCategoryModel                               *allCourseCategory;
@property (nonatomic,weak) id<CourseModule_AllCourseCategoryProtocol>            notifiedObject;

@end

@implementation CourseCategoryOperation

- (void)setCurrentAllCourseCategoryModel:(AllCourseCategoryModel *)model
{
    self.allCourseCategory = model;
}

- (void)didRequestAllCourseCategoryWithNotifiedObject:(id<CourseModule_AllCourseCategoryProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestAllCourseCategoryWithProcessDelegate:self];
}

#pragma mark - http delegate
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
//    NSLog(@"%@", [successInfo description]);
    
    [self.allCourseCategory removeAllCategory];
    NSArray *data = [successInfo objectForKey:@"data"];
    for (NSDictionary *dic in data) {
        CourseCategoryModel *model = [[CourseCategoryModel alloc] init];
        model.categoryId = [[dic objectForKey:@"id"] intValue];
        model.categoryName = [dic objectForKey:@"name"];
        model.categoryImageUrl = [dic objectForKey:@"cover"];
        
        NSArray * secondArr = [dic objectForKey:@"cateList"];
        
        if (secondArr.count == 0) {
            NSArray * secondArr1 = [dic objectForKey:@"courseList"];
            CourseCategorysecondModel * secondModel = [[CourseCategorysecondModel alloc]init];
            secondModel.categorySecondId = 0;
            secondModel.categorySecondName = @"";
            secondModel.categorySecondImageUrl = @"";
            for (NSDictionary * courseDic in secondArr1) {
                CourseModel *courseModel = [[CourseModel alloc] init];
                courseModel.courseName = [courseDic objectForKey:@"courseName"];
                courseModel.courseCover = [courseDic objectForKey:@"cover"];
                courseModel.courseID = [[courseDic objectForKey:@"id"] intValue];
                courseModel.coueseTeacherName = [courseDic objectForKey:@"teacherName"];
                NSString * price = @"0";
                if ([[courseDic objectForKey:@"price"] isKindOfClass:[NSNull class]] || [[courseDic objectForKey:@"price"] isEqualToString:@"<null>"]) {
                }else
                {
                    price = [courseDic objectForKey:@"price"];
                }
                courseModel.price = [price doubleValue];
                [secondModel addCourseModel:courseModel];
            }
            [model addSecondCourseModel:secondModel];
        }else
        {
            for (NSDictionary * secondDic in secondArr) {
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
                    courseModel.coueseTeacherName = [courseDic objectForKey:@"teacherName"];
                    NSString * price = @"0";
                    if ([[courseDic objectForKey:@"price"] isKindOfClass:[NSNull class]] || [[courseDic objectForKey:@"price"] isEqualToString:@"<null>"]) {
                    }else
                    {
                        price = [courseDic objectForKey:@"price"];
                    }
                    courseModel.price = [price doubleValue];
                    [secondModel addCourseModel:courseModel];
                }
                [model addSecondCourseModel:secondModel];
            }
        }
        [self.allCourseCategory addCategory:model];
    }
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestAllCourseCategorySuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestAllCourseFailed];
    }
}

@end
