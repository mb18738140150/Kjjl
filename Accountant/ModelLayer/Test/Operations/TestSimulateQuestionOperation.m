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
        questionModel.lid = [[dic objectForKey:@"directionId"] intValue];
        questionModel.kid = [[dic objectForKey:@"subjectId"] intValue];
        questionModel.cid = [[dic objectForKey:@"chapterId"] intValue];
        questionModel.uid = [[dic objectForKey:@"unitId"] intValue];
        questionModel.sid = [[dic objectForKey:@"simulationId"] intValue];
        questionModel.isEasyWrong = [[dic objectForKey:@"isEasyWrong"] intValue];
        questionModel.questionId = [[dic objectForKey:@"id"] intValue];
        questionModel.questionType = [dic objectForKey:@"questionType"];
        questionModel.questionTypeId = [[dic objectForKey:@"questionTypeId"] intValue];
        questionModel.lastLogId = [[successInfo objectForKey:@"lastLogId"] longValue];
        questionModel.selectArray = [self selectArrayWith:[dic objectForKey:@"myAnswers"]];
        if (questionModel.selectArray.count > 0) {
            questionModel.questionIsAnswered = YES;
        }
        questionModel.questionContent = [dic objectForKey:@"question"];
        questionModel.questionComplain = [dic objectForKey:@"analysis"];
        questionModel.correctAnswerIds = [dic objectForKey:@"answer"];
        questionModel.questionIsCollected = [[dic objectForKey:@"isCollect"] boolValue];
        questionModel.caseInfo = [UIUtility judgeStr:[dic objectForKey:@"caseInfo"]];
        NSString *a = [dic objectForKey:@"answer"];
        NSString *str = [dic objectForKey:@"items"];
        NSArray *array = [str componentsSeparatedByString:@"|"];
        
        for (int i = 0; i < array.count; i++) {
            NSString * answerStr = [array objectAtIndex:i];
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
                if ([questionModel.questionType isEqualToString:@"判断题"]  ) {
                    if (i < 2) {
                        [questionModel.answers addObject:answer];
                    }
                }else
                {
                    [questionModel.answers addObject:answer];
                }
                
            }
        }
        
//        for (NSString *str1 in array) {
//            NSArray *subArray = [str1 componentsSeparatedByString:@"</p>"];
//            for (NSString *answerStr in subArray) {
//                if ([answerStr class] != [NSNull class] && answerStr != nil && ![answerStr isEqualToString:@""]) {
//                    TestAnswerModel *answer = [[TestAnswerModel alloc] init];
//                    answer.answerContent = answerStr;
//                    unichar c = [answerStr characterAtIndex:0];
//                    answer.answerId = [NSString stringWithFormat:@"%c",c];
//                    if ([a containsString:answer.answerId]) {
//                        answer.isCorrectAnswer = YES;
//                    }else{
//                        answer.isCorrectAnswer = NO;
//                    }
//                    [questionModel.answers addObject:answer];
//                    
//                }
//            }
//        }
        
        if ([questionModel.questionType isEqualToString:@"单选题"]) {
            [singleQuestionArr addObject:questionModel];
        }else if ([questionModel.questionType isEqualToString:@"判断题"])
        {
            [judgeQuestionArr addObject:questionModel];
        }else if ([questionModel.questionType isEqualToString:@"多选题"])
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

- (NSArray *)selectArrayWith:(NSString *)selectStr
{
    NSMutableArray * dataArr = [NSMutableArray array];
    if (selectStr.length == 0) {
        return dataArr;
    }
    if (selectStr.length > 4) {
        [dataArr addObject:selectStr];
    }else
    {
        
        for (int i = 0; i< selectStr.length; i++) {
            NSString * selectAnswer = [selectStr substringWithRange:NSMakeRange(i, 1)];
            [dataArr addObject:selectAnswer];
            
        }
    }
    
    return dataArr;
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestSimulateQuestionFailed:failInfo];
    }
}

@end
