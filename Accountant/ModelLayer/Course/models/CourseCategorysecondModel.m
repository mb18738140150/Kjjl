//
//  CourseCategorysecondModel.m
//  Accountant
//
//  Created by aaa on 2017/4/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "CourseCategorysecondModel.h"

@implementation CourseCategorysecondModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.categroryCoursesArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addCourseModel:(CourseModel *)model
{
    [self.categroryCoursesArray addObject:model];
}

- (void)removeAllCourses
{
    [self.categroryCoursesArray removeAllObjects];
}

@end
