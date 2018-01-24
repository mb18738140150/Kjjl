//
//  TestRecordQuestionOperation.m
//  Accountant
//
//  Created by aaa on 2018/1/19.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "TestRecordQuestionOperation.h"

#import "HttpRequestManager.h"
#import "CommonMacro.h"
@interface TestRecordQuestionOperation ()<HttpRequestProtocol>

@end

@implementation TestRecordQuestionOperation

- (void)didRequestTestRecordQuestionWithInfo:(NSDictionary *)infoDic andNotifiedObject:(id<TestModule_TestRecordQuestion>)object
{
    self.testRecordNotifiedObject = object;
    
    [[HttpRequestManager sharedManager] reqeustTestRecordQuestionWithInfo:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    
    NSArray * data = [successInfo objectForKey:@"data"];
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
        questionModel.myAnswer = [dic objectForKey:kTestMyanswer];
        questionModel.isResponse = [[dic objectForKey:kTestIsResponse] intValue];
        
        questionModel.questionContent = [self replaceOtherString:[dic objectForKey:@"question"]];
        questionModel.questionComplain = [dic objectForKey:@"analysis"];
        questionModel.correctAnswerIds = [dic objectForKey:@"answer"];
        questionModel.questionIsCollected = [[dic objectForKey:@"isCollect"] boolValue];
        questionModel.logId = [[dic objectForKey:@"logId"] intValue];
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
        
        [self.currentTestSection addQuestion:questionModel];
    }
    
    if (isObjectNotNil(self.testRecordNotifiedObject)) {
        [self.testRecordNotifiedObject didRequestTestRecordQuestionSuccess];
    }
}

- (NSString * )replaceOtherString:(NSString *)string
{
    NSString * answerStr1 = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    answerStr1 = [answerStr1 stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
    answerStr1 = [answerStr1 stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
    return answerStr1;
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.testRecordNotifiedObject)) {
        [self.testRecordNotifiedObject didRequestTestRecordQuestionFailed:failInfo];
    }
}
@end
