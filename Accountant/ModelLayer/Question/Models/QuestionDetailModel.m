//
//  QuestionDetailModel.m
//  Accountant
//
//  Created by aaa on 2017/3/7.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "QuestionDetailModel.h"

@implementation QuestionDetailModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.questionReplys = [[NSMutableArray alloc] init];
        self.questionImgArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)removeAllReplys
{
    [self.questionReplys removeAllObjects];
}

- (void)removeAllImages
{
    [self.questionImgArray removeAllObjects];
}

- (void)addQuestionReply:(QuestionReplyModel *)replyModel
{
    [self.questionReplys addObject:replyModel];
}

- (void)addImageUrl:(NSString *)str
{
    [self.questionImgArray addObject:str];
}

@end
