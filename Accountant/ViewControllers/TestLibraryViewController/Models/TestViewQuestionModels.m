//
//  TestViewQuestionModels.m
//  Accountant
//
//  Created by aaa on 2017/3/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestViewQuestionModels.h"

@implementation TestViewQuestionModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.questionAnswers = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
