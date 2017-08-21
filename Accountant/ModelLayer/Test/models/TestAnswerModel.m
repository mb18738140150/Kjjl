//
//  TestAnswerModel.m
//  Accountant
//
//  Created by aaa on 2017/3/17.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestAnswerModel.h"

@implementation TestAnswerModel

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %d %@",self.answerContent,self.isCorrectAnswer,self.answerId];
}

@end
