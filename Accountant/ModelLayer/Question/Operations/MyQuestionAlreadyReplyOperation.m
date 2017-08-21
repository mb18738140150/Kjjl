//
//  MyQuestionAlreadyReplyOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "MyQuestionAlreadyReplyOperation.h"
#import "HttpRequestManager.h"
#import "QuestionModel.h"
#import "CommonMacro.h"

@interface MyQuestionAlreadyReplyOperation ()<HttpRequestProtocol>

@end

@implementation MyQuestionAlreadyReplyOperation

- (void)didRequestMyQuestionAlreadyReplyWithNotifiedObject:(id<QuestionModule_MyQuestionAlreadyReply>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestMyQuestionAlreadyReplyWithProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [self.alreadyReplyQuestionArray removeAllObjects];
    NSArray *data = [successInfo objectForKey:@"questionList"];
    for (NSDictionary *dic in data) {
        QuestionModel *model = [[QuestionModel alloc] init];
        model.questionId = [[dic objectForKey:@"questionId"] intValue];
        model.questionContent = [dic objectForKey:@"questionMsg"];
        model.questionReplyCount = [[dic objectForKey:@"replyNum"] intValue];
        [self.alreadyReplyQuestionArray addObject:model];
    }
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didMyQuestionAlreadyReplyRequestSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didMyQuestionAlreadyReplyRequestFailed:failInfo];
    }
}

@end
