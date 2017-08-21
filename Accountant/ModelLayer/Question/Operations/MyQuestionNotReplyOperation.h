//
//  MyQuestionNotReplyOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionModuleProtocol.h"

@interface MyQuestionNotReplyOperation : NSObject

@property (nonatomic,weak) NSMutableArray                       *notReplyQuestionArray;
@property (nonatomic,weak) id<QuestionModule_MyQuestionNotReply> notifiedObject;

- (void)didRequestMyQuestionNotReplyWithNotifiedObject:(id<QuestionModule_MyQuestionNotReply>)object;

@end
