//
//  DetailCourseModel.m
//  Accountant
//
//  Created by aaa on 2017/3/1.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DetailCourseModel.h"

@interface DetailCourseModel()

@end

@implementation DetailCourseModel

- (instancetype)init
{
    if (self = [super init]) {
        self.chapters = [[NSMutableArray alloc] init];
        self.courseModel = [[CourseModel alloc] init];
    }
    return self;
}

- (void)removeAllChapters
{
    [self.chapters removeAllObjects];
}

- (void)addCourseChapter:(ChapterModel *)chapter
{
    [self.chapters addObject:chapter];
}

@end
