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
    }
    return self;
}

- (void)removeAllCourses
{
    [self.hottestCourses removeAllObjects];
}

- (void)addCourse:(CourseModel *)model
{
    [self.hottestCourses addObject:model];
}

- (NSString *)description
{
    return nil;
    
}

@end
