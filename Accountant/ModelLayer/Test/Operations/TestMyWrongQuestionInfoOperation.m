//
//  TestMyWrongQuestionInfoOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestMyWrongQuestionInfoOperation.h"
#import "HttpRequestManager.h"
#import "TestAnswerModel.h"
#import "CommonMacro.h"

@interface TestMyWrongQuestionInfoOperation ()<HttpRequestProtocol>

@end

@implementation TestMyWrongQuestionInfoOperation

- (void)didRequestMyWrongQuestionListWithChapterId:(NSDictionary *)chapterId andNotifiedObject:(id<TestModule_MyWrongQuestionsListProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustTestMyWrongQuestionsWithId:chapterId andProcess:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    NSArray *data = [successInfo objectForKey:@"data"];
    [self.currentTestSection removeAllQuestion];
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
//                }
//            }
//        }
        [self.currentTestSection addQuestion:questionModel];
    }
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestMyWrongQuestionsListSuccess];
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
        [self.notifiedObject didRequestMyWrongQuestionsListFailed:failInfo];
    }
}

@end
