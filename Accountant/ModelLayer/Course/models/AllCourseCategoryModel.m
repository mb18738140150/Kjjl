//
//  AllCourseCategoryModel.m
//  Accountant
//
//  Created by aaa on 2017/3/3.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "AllCourseCategoryModel.h"

@implementation AllCourseCategoryModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.allCategory = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)removeAllCategory
{
    [self.allCategory removeAllObjects];
}

- (void)addCategory:(CourseCategoryModel *)model
{
    [self.allCategory addObject:model];
}

@end
