//
//  MyQuestionNotReplyOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "MyQuestionNotReplyOperation.h"
#import "HttpRequestManager.h"
#import "QuestionModel.h"
#import "CommonMacro.h"

@interface MyQuestionNotReplyOperation ()<HttpRequestProtocol>

@end

@implementation MyQuestionNotReplyOperation

- (void)didRequestMyQuestionNotReplyWithNotifiedObject:(id<QuestionModule_MyQuestionNotReply>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestMyQuestionNotReplyWithProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    
    NSLog(@"NotReply successInfo = %@", successInfo);
    
    [self.notReplyQuestionArray removeAllObjects];
    NSArray *data = [successInfo objectForKey:@"questionList"];
    for (NSDictionary *dic in data) {
        QuestionModel *model = [[QuestionModel alloc] init];
        model.questionId = [[dic objectForKey:@"questionId"] intValue];
        model.questionContent = [dic objectForKey:@"questionMsg"];
        [self.notReplyQuestionArray addObject:model];
    }
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didMyQuestionNotReplyRequestSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didMyQuestionNotReplyRequestFailed:failInfo];
    }
}

@end
