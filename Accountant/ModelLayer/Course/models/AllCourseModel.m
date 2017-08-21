//
//  AllCourseModel.m
//  Accountant
//
//  Created by aaa on 2017/3/1.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "AllCourseModel.h"

@implementation AllCourseModel

- (instancetype)init
{
    if (self = [super init]) {
        self.allCourseModels = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)removeAllCourses
{
    [self.allCourseModels removeAllObjects];
}

- (void)addCourseModel:(CourseModel *)model
{
    [self.allCourseModels addObject:model];
}

@end
