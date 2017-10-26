//
//  QuestionDetailOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/7.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "QuestionDetailOperation.h"
#import "HttpRequestManager.h"
#import "CommonMacro.h"

@interface QuestionDetailOperation ()<HttpRequestProtocol>

@end

@implementation QuestionDetailOperation

- (void)didRequestQuestionDetailWithQuestionId:(int)questionId andNotifiedObject:(id<QuestionModule_QuestionDetailProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestQuestionDetailWithQuestionId:questionId withProcessDelegate:self];
}

#pragma mark - http delegate
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [self.detailModel removeAllReplys];
    [self.detailModel removeAllImages];
    NSDictionary *data = [successInfo objectForKey:@"data"];
    NSArray *imgs = [data objectForKey:@"imgStr"];
    if ([imgs class] != [NSNull class]) {
        for (NSString *imgStr in imgs) {
            if (imgStr != nil && ![imgStr isEqualToString:@""]) {
                [self.detailModel addImageUrl:imgStr];
            }
        }
    }
    
    self.detailModel.questionQuizzerHeaderImageUrl = [data objectForKey:@"avatar"];
    self.detailModel.questionContent = [data objectForKey:@"questionMsg"];
    self.detailModel.questionTime = [data objectForKey:@"questionTime"];
    self.detailModel.questionReplyCount = [[data objectForKey:@"replyNum"] intValue];
    self.detailModel.questionSeeCount = [[data objectForKey:@"seeNum"] intValue];
    self.detailModel.questionQuizzerUserName = [data objectForKey:@"userName"];
    
    NSArray *replys = [data objectForKey:@"replyList"];
    for (NSDictionary *replyInfo in replys) {
        QuestionReplyModel *model = [[QuestionReplyModel alloc] init];
        model.replyContent = [replyInfo objectForKey:@"replyCon"];
        model.replyTime = [replyInfo objectForKey:@"replyTime"];
        model.replierUserName = [replyInfo objectForKey:@"coachName"];
        model.replierHeaderImageUrl = [replyInfo objectForKey:@"coachImg"];
        
        for (NSDictionary *askedDic in [replyInfo objectForKey:@"askedList"]) {
            [model.askedArray addObject:askedDic];
        }
        
        [self.detailModel addQuestionReply:model];
        
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
