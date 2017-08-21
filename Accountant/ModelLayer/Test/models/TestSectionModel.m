//
//  TestSectionModel.m
//  Accountant
//
//  Created by aaa on 2017/3/17.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestSectionModel.h"

@implementation TestSectionModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.questionArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)removeAllQuestion
{
    [self.questionArray removeAllObjects];
}

- (void)addQuestion:(TestQuestionModel *)test
{
    [self.questionArray addObject:test];
}


@end
