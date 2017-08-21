//
//  CourseCategoryModel.m
//  Accountant
//
//  Created by aaa on 2017/3/3.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "CourseCategoryModel.h"

@implementation CourseCategoryModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.categrorySecondCoursesArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addSecondCourseModel:(CourseCategorysecondModel *)model
{
    [self.categrorySecondCoursesArray addObject:model];
}

- (void)removeAllCourses
{
    [self.categrorySecondCoursesArray removeAllObjects];
}

@end
