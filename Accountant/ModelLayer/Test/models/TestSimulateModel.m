//
//  TestSimulateModel.m
//  Accountant
//
//  Created by aaa on 2017/3/22.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestSimulateModel.h"

@implementation TestSimulateModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.questionArray = [[NSMutableArray alloc] init];
        
        self.rightQuestionArr = [NSMutableArray array];
        self.wrongQuestionArr = [NSMutableArray array];
        self.singleQuestionArr = [NSMutableArray array];
        self.multipleQuestionArr = [NSMutableArray array];
        self.judgeQuestionArr = [NSMutableArray array];
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

- (void)getResult
{
    [self.rightQuestionArr removeAllObjects];
    [self.wrongQuestionArr removeAllObjects];
    [self.singleQuestionArr removeAllObjects];
    [self.multipleQuestionArr removeAllObjects];
    [self.judgeQuestionArr removeAllObjects];
    
    
    for (TestQuestionModel * model in self.questionArray) {
        if (model.isAnsweredCorrect) {
            [self.rightQuestionArr addObject:model];
        }else
        {
            [self.wrongQuestionArr addObject:model];
        }
        
        if ([model.questionType isEqualToString:@"单选题"]) {
            [self.singleQuestionArr addObject:model];
        }else if ([model.questionType isEqualToString:@"判断题"])
        {
            [self.judgeQuestionArr addObject:model];
        }else
        {
            [self.multipleQuestionArr addObject:model];
        }
        
    }
}

@end
