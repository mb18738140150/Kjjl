//
//  CourseCategoryDetailModel.m
//  Accountant
//
//  Created by aaa on 2017/3/4.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "CourseCategoryDetailModel.h"


@implementation CourseCategoryDetailModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.courseModels = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)removeAllCourses
{
    [self.courseModels removeAllObjects];
}

- (void)addCourse:(CourseCategorysecondModel *)model
{
    [self.courseModels addObject:model];
}

@end
