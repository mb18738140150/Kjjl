//
//  QuestionMainViewOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/9.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "QuestionMainViewOperation.h"
#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"
#import "CommonMacro.h"

@interface QuestionMainViewOperation ()<HttpRequestProtocol>

@property (nonatomic,weak) id<QuestionModule_QuestionProtocol> notifiedObject;

@end

@implementation QuestionMainViewOperation

- (void)didRequestQuestionWithPageIndex:(int)index andNotifiedObject:(id<QuestionModule_QuestionProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestQuestionWithPageIndex:index withProcessDelegate:self];;
}

#pragma mark - http delegate
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [self.mainViewQuestionModel removeAllQuestionModels];
    NSArray *questionArray = [successInfo objectForKey:@"questionList"];
    for (NSDictionary *tmpDic in questionArray) {
        QuestionModel *model = [[QuestionModel alloc] init];
        model.questionContent = [tmpDic objectForKey:@"questionMsg"];
        model.questionId = [[tmpDic objectForKey:@"questionId"] intValue];
        model.questionQuizzerHeaderImageUrl = [tmpDic objectForKey:@"avatar"];
        model.questionQuizzerUserName = [tmpDic objectForKey:@"userName"];
        model.questionTime = [tmpDic objectForKey:@"questionTime"];
        model.questionQuizzerId = [[tmpDic objectForKey:@"UserId"] intValue];
        model.questionReplyCount = [[tmpDic objectForKey:@"replyNum"] intValue];
        model.questionSeeCount = [[tmpDic objectForKey:@"seeNum"] intValue];
        [self.mainViewQuestionModel addQuestionModel:model];
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
