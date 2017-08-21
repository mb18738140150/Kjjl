//
//  QuestionOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/2.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "QuestionOperation.h"
#import "HttpRequestManager.h"
#import "CommonMacro.h"

@interface QuestionOperation ()<HttpRequestProtocol>

@property (nonatomic,weak) id<QuestionModule_QuestionProtocol>               notifiedObject;
@property (nonatomic,weak) ShowQuestionModel                               *showQuestionModel;

@end

@implementation QuestionOperation

- (void)setCurrentShowQuestionModels:(ShowQuestionModel *)model
{
    self.showQuestionModel = model;
}

- (void)didRequestQuestionWithPageIndex:(int)index andNotifiedObject:(id<QuestionModule_QuestionProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestQuestionWithPageIndex:index withProcessDelegate:self];;
}

- (void)clearAllQuestions
{
    [self.showQuestionModel removeAllQuestionModels];
}

#pragma mark - http delegate
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    NSArray *questionArray = [successInfo objectForKey:@"questionList"];
    if (questionArray.count == 0) {
        self.moduleModel.isLoadMax = YES;
    }
    for (NSDictionary *tmpDic in questionArray) {
        NSLog(@"%@", tmpDic);
        QuestionModel *model = [[QuestionModel alloc] init];
        model.questionContent = [tmpDic objectForKey:@"questionMsg"];
        model.questionId = [[tmpDic objectForKey:@"questionId"] intValue];
        model.questionQuizzerHeaderImageUrl = [tmpDic objectForKey:@"avatar"];
        model.questionQuizzerUserName = [tmpDic objectForKey:@"userName"];
        model.questionTime = [tmpDic objectForKey:@"questionTime"];
        model.questionQuizzerId = [[tmpDic objectForKey:@"UserId"] intValue];
        model.questionReplyCount = [[tmpDic objectForKey:@"replyNum"] intValue];
        model.questionSeeCount = [[tmpDic objectForKey:@"seeNum"] intValue];
        model.replyList = [tmpDic objectForKey:@"replyList"];
        [self.showQuestionModel addQuestionModel:model];
    }
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didQuestionRequestSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didQuestionRequestFailed:failInfo];
    }
}

@end
