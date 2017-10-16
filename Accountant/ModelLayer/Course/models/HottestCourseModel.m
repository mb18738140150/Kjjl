//
//  HottestCourseModel.m
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "HottestCourseModel.h"

@implementation HottestCourseModel

- (instancetype)init
{
    if (self = [super init]) {
        self.hottestCourses = [[NSMutableArray alloc] init];
        self.teacherDataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)removeAllCourses
{
    [self.hottestCourses removeAllObjects];
    [self.teacherDataArray removeAllObjects];
}

- (void)addCourse:(CourseModel *)model
{
    [self.hottestCourses addObject:model];
}

- (void)addTeacher:(TeacherModel *)model
{
    [self.teacherDataArray addObject:model];
}

- (NSString *)description
{
    return nil;
    
}

@end
