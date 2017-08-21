//
//  TestCategoryModel.m
//  Accountant
//
//  Created by aaa on 2017/3/17.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestCategoryModel.h"

@implementation TestCategoryModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.subCategory = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
