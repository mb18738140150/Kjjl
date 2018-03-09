//
//  TestErrorQuestionOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestErrorQuestionOperation.h"
#import "HttpRequestManager.h"
#import "TestChapterModel.h"
#import "CommonMacro.h"
#import "TestAnswerModel.h"

@interface TestErrorQuestionOperation ()<HttpRequestProtocol>

@end

@implementation TestErrorQuestionOperation

- (void)didRequestErrorQuestionWithSectionId:(NSDictionary *)sectionInfo andNotifiedObject:(id<TestModule_ErrorQuestionProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustTestErrorQuesitonWithSectionId:sectionInfo andProcessDelegate:self];
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
        [self.currentTestSection addQuestion:questionModel];
    }
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestErrorQuestionSuccess];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestErrorQuestionFailed:failInfo];
    }
}

@end
