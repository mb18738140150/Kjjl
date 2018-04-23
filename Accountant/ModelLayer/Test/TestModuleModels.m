//
//  TestModuleModels.m
//  Accountant
//
//  Created by aaa on 2017/3/17.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestModuleModels.h"

@implementation TestModuleModels

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.testAllCategoryArray = [[NSMutableArray alloc] init];
        self.testChapterArray = [[NSMutableArray alloc] init];
        self.testSimulateArray = [[NSMutableArray alloc] init];
        self.testErrorArray = [[NSMutableArray alloc] init];
        self.simulateArray = [[NSMutableArray alloc] init];
        self.currentTestSection = [[TestSectionModel alloc] init];
        self.currentSimulateModel = [[TestSimulateModel alloc] init];
        self.currentSimulateWrongModel = [[TestSimulateModel alloc]init];
        self.currentQuestionIndex = 0;
        self.logId = 0;
    }
    return self;
}

- (void)previousQuestion
{
    self.currentQuestionIndex--;
}

- (void)nextQuestion
{
    self.currentQuestionIndex++;
}

- (void)showQuestionAnswerWithQuestionIndex:(int)questionIndex
{
    TestQuestionModel *questionModel = [self.currentTestSection.questionArray objectAtIndex:questionIndex];
    questionModel.questionIsShowAnswer = YES;
}

- (void)submitSectionQuestionAnswers:(NSMutableArray *)answers andIndex:(int)questionIndex
{
    TestQuestionModel *questionModel = [self.currentTestSection.questionArray objectAtIndex:questionIndex];
    questionModel.questionIsAnswered = YES;
    questionModel.selectArray = answers;
    
    NSMutableString *myStr = [[NSMutableString alloc] init];
    for (NSString *number in answers) {
        [myStr appendString:[NSString stringWithFormat:@"%@",number]];
    }
    questionModel.selectedAnswerIds = myStr;
    if ([myStr isEqualToString:questionModel.correctAnswerIds]) {
        questionModel.isAnsweredCorrect = YES;
    }else{
        questionModel.isAnsweredCorrect = NO;
    }
}

- (void)submitSimulateQuestionAnswers:(NSMutableArray *)answers andIndex:(int)questionIndex
{
    TestQuestionModel *questionModel = [self.currentSimulateModel.questionArray objectAtIndex:questionIndex];
    questionModel.questionIsAnswered = YES;
    questionModel.selectArray = [answers copy];
    
    NSMutableString *myStr = [[NSMutableString alloc] init];
    for (NSNumber *number in answers) {
        [myStr appendString:[NSString stringWithFormat:@"%@",number]];
    }
    questionModel.selectedAnswerIds = myStr;
    if ([myStr isEqualToString:questionModel.correctAnswerIds]) {
        questionModel.isAnsweredCorrect = YES;
    }else{
        questionModel.isAnsweredCorrect = NO;
    }
                                    
}

- (void)reSubmitSimulateAnswers:(NSMutableArray *)answerArray andQuestionIndex:(int)questionIndex
{
    TestQuestionModel *questionModel = [self.currentSimulateModel.questionArray objectAtIndex:questionIndex];
    questionModel.questionIsAnswered = NO;
    questionModel.selectArray = [NSArray array];
    questionModel.selectedAnswerIds = @"";
    questionModel.isAnsweredCorrect = NO;
}


- (void)collectQuestionAtIndex:(int)questionIndex
{
    switch (self.colectModelType) {
        case CollectTypeModelTest:
        {
            TestQuestionModel *questionModel = [self.currentTestSection.questionArray objectAtIndex:questionIndex];
            questionModel.questionIsCollected = YES;
        }
            break;
        case CollectTypeModelSimulate:
        {
            TestQuestionModel *questionModel = [self.currentSimulateModel.questionArray objectAtIndex:questionIndex];
            questionModel.questionIsCollected = YES;
        }
            break;
        case CollectTypeModelSimulateWrong:
        {
            TestQuestionModel *questionModel = [self.currentSimulateWrongModel.questionArray objectAtIndex:questionIndex];
            questionModel.questionIsCollected = YES;
        }
            break;
            
        default:
            break;
    }
    
    
}

- (void)uncollectQuestionAtIndex:(int)questionIndex
{
    switch (self.colectModelType) {
        case CollectTypeModelTest:
        {
            TestQuestionModel *questionModel = [self.currentTestSection.questionArray objectAtIndex:questionIndex];
            questionModel.questionIsCollected = NO;
        }
            break;
        case CollectTypeModelSimulate:
        {
            TestQuestionModel *questionModel = [self.currentSimulateModel.questionArray objectAtIndex:questionIndex];
            questionModel.questionIsCollected = NO;
        }
            break;
        case CollectTypeModelSimulateWrong:
        {
            TestQuestionModel *questionModel = [self.currentSimulateWrongModel.questionArray objectAtIndex:questionIndex];
            questionModel.questionIsCollected = NO;
        }
            break;
            
        default:
            break;
    }
}

@end
