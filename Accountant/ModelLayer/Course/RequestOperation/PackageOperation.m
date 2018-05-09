//
//  PackageOperation.m
//  Accountant
//
//  Created by aaa on 2018/4/8.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "PackageOperation.h"

#import "CommonMacro.h"
#import "HttpRequestManager.h"
#import "CourseCategorysecondModel.h"

@interface PackageOperation ()<HttpRequestProtocol>

@property (nonatomic,weak) AllCourseCategoryModel                               *allCourseCategory;
@property (nonatomic,weak) id<CourseModule_PackageProtocol>            notifiedObject;

@end

@implementation PackageOperation

- (void)setCurrentAllPackageModel:(AllCourseCategoryModel *)model
{
    self.allCourseCategory = model;
}

- (void)didRequestAllPackageWithNotifiedObject:(id<CourseModule_PackageProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestAllPackageWithProcessDelegate:self];;
}

#pragma mark - http delegate
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    //    NSLog(@"%@", [successInfo description]);
    
    [self.allCourseCategory removeAllCategory];
    CourseCategoryModel *model = [[CourseCategoryModel alloc] init];
    model.categoryId = [[successInfo objectForKey:@"recommendId"] intValue];
    model.categoryImageUrl = [successInfo objectForKey:@"recommendImgUrl"];
    NSArray *data = [successInfo objectForKey:@"data"];
    for (NSDictionary *dic in data) {
        CourseCategorysecondModel * secondModel = [[CourseCategorysecondModel alloc]init];
        secondModel.categorySecondId = [[dic objectForKey:@"id"] intValue];
        secondModel.categorySecondName = [dic objectForKey:@"name"];
        
        NSArray * secondArr1 = [dic objectForKey:@"packageList"];
        secondModel.categorySecondImageUrl = @"";
        for (NSDictionary * courseDic in secondArr1) {
            CourseModel *courseModel = [[CourseModel alloc] init];
            courseModel.courseName = [courseDic objectForKey:@"packageName"];
            courseModel.courseCover = [courseDic objectForKey:@"packageCover"];
            courseModel.courseID = [[courseDic objectForKey:@"packageId"] intValue];
            courseModel.priceSection = [courseDic objectForKey:@"packagePrice"];
            courseModel.isRecommend = [[courseDic objectForKey:@"isRecommend"] intValue];
            [secondModel addCourseModel:courseModel];
        }
        [model addSecondCourseModel:secondModel];
        
    }
    [self.allCourseCategory addCategory:model];
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didReuquestPackageSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didReuquestPackageFailed:failInfo];
    }
}

@end
