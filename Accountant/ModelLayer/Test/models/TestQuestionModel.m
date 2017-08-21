//
//  TestQuestionModel.m
//  Accountant
//
//  Created by aaa on 2017/3/17.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestQuestionModel.h"

@implementation TestQuestionModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.questionId = 0;
        self.questionType = @"";
        self.questionContent = @"";
        self.questionComplain = @"";
        self.correctAnswerIds = @"";
        self.answers = [[NSMutableArray alloc] init];
        self.questionIsAnswered = NO;
        self.questionIsCollected = NO;
        self.selectArray = [[NSArray alloc] init];
        self.isAnsweredCorrect = NO;
        self.selectedAnswerIds = @"";
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"type:%@ answers:%@",self.questionType,self.answers];
}


@end
