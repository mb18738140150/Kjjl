//
//  TestSimulateQuestionOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/22.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestSimulateQuestionOperation.h"
#import "CommonMacro.h"
#import "HttpRequestManager.h"
#import "TestAnswerModel.h"
#import "UIUtility.h"

@interface TestSimulateQuestionOperation ()<HttpRequestProtocol>

@end

@implementation TestSimulateQuestionOperation

- (void)didRequestSimulateQuestionWithTestId:(int)testId andNotifiedObject:(id<TestModule_SimulateQuestionProtocol>)object
{
    self.notifiedObject = object;
    self.simulateModel.simulateId = testId;
    [[HttpRequestManager sharedManager] requestTestSimulateQuestionWithTestId:testId andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    NSArray *data = [successInfo objectForKey:@"data"];
    [self.simulateModel removeAllQuestion];
    
    NSMutableArray * singleQuestionArr = [NSMutableArray array];
    NSMutableArray * multipleQuestionArr = [NSMutableArray array];
    NSMutableArray * judgeQuestionArr = [NSMutableArray array];
    NSMutableArray * materialQuestionArr = [NSMutableArray array];
    
    for (NSDictionary *dic in data) {
        TestQuestionModel *questionModel = [[TestQuestionModel alloc] init];
        questionModel.questionId = [[dic objectForKey:@"id"] intValue];
        questionModel.questionType = [dic objectForKey:@"questionType"];
        questionModel.questionContent = [dic objectForKey:@"question"];
        questionModel.questionComplain = [dic objectForKey:@"analysis"];
        questionModel.correctAnswerIds = [dic objectForKey:@"answer"];
        questionModel.questionIsCollected = [[dic objectForKey:@"isCollect"] boolValue];
        questionModel.caseInfo = [UIUtility judgeStr:[dic objectForKey:@"caseInfo"]];
        NSString *a = [dic objectForKey:@"answer"];
        NSString *str = [dic objectForKey:@"items"];
        NSArray *array = [str componentsSeparatedByString:@"<p>"];
        for (NSString *str1 in array) {
            NSArray *subArray = [str1 componentsSeparatedByString:@"</p>"];
            for (NSString *answerStr in subArray) {
                if ([answerStr class] != [NSNull class] && answerStr != nil && ![answerStr isEqualToString:@""]) {
                    TestAnswerModel *answer = [[TestAnswerModel alloc] init];
                    answer.answerContent = answerStr;
                    unichar c = [answerStr characterAtIndex:0];
                    answer.answerId = [NSString stringWithFormat:@"%c",c];
                    if ([a containsString:answer.answerId]) {
                        answer.isCorrectAnswer = YES;
                    }else{
                        answer.isCorrectAnswer = NO;
                    }
                    [questionModel.answers addObject:answer];
                    
                }
            }
        }
        
        if ([questionModel.questionType isEqualToString:@"单选"]) {
            [singleQuestionArr addObject:questionModel];
        }else if ([questionModel.questionType isEqualToString:@"判断"])
        {
            [judgeQuestionArr addObject:questionModel];
        }else if ([questionModel.questionType isEqualToString:@"多选"])
        {
            [multipleQuestionArr addObject:questionModel];
        }else
        {
            [materialQuestionArr addObject:questionModel];
        }
        
    }
    for (TestQuestionModel * questionModel in singleQuestionArr) {
        
        [self.simulateModel addQuestion:questionModel];
    }
    for (TestQuestionModel * questionModel in multipleQuestionArr) {
        
        [self.simulateModel addQuestion:questionModel];
    }
    for (TestQuestionModel * questionModel in judgeQuestionArr) {
        
        [self.simulateModel addQuestion:questionModel];
    }
    for (NSInteger i = materialQuestionArr.count - 1; i >= 0; i--) {
        TestQuestionModel * model = [materialQuestionArr objectAtIndex:i];
        [self.simulateModel addQuestion:model];
    }
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestSimulateQuestionSuccess];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestSimulateQuestionFailed:failInfo];
    }
}

@end
