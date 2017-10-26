//
//  QuestionReplyModel.m
//  Accountant
//
//  Created by aaa on 2017/3/7.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "QuestionReplyModel.h"

@implementation QuestionReplyModel

- (NSMutableArray *)askedArray
{
    if (!_askedArray) {
        _askedArray = [NSMutableArray array];
    }
    return _askedArray;
}

@end
