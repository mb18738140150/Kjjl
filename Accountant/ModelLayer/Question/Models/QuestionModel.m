//
//  QuestionModel.m
//  Accountant
//
//  Created by aaa on 2017/3/3.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "QuestionModel.h"

@implementation QuestionModel

- (NSArray *)replyList
{
    if (!_replyList) {
        _replyList = [NSArray array];
    }
    return _replyList;
}

@end
