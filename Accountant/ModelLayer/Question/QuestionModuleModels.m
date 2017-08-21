//
//  QuestionModuleModels.m
//  Accountant
//
//  Created by aaa on 2017/3/3.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "QuestionModuleModels.h"

@implementation QuestionModuleModels

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isLoadMax = NO;
        self.currentQuestionPageCount = 1;
        self.showQuestionModel = [[ShowQuestionModel alloc] init];
        self.questionDetailModel = [[QuestionDetailModel alloc] init];
        self.mainViewQuestionModel = [[ShowQuestionModel alloc] init];
        
        self.alreadyReplyQuestionArray = [[NSMutableArray alloc] init];
        self.notReplyQuestionArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (int)nextPage
{
    self.currentQuestionPageCount++;
    return self.currentQuestionPageCount;
}

- (void)resetLoadInfos
{
    self.currentQuestionPageCount = 1;
    self.isLoadMax = NO;
}


@end
