//
//  MyQuestionAlreadyReplyOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionModuleProtocol.h"

@interface MyQuestionAlreadyReplyOperation : NSObject

@property (nonatomic,weak) NSMutableArray           *alreadyReplyQuestionArray;
@property (nonatomic,weak) id<QuestionModule_MyQuestionAlreadyReply>          notifiedObject;

- (void)didRequestMyQuestionAlreadyReplyWithNotifiedObject:(id<QuestionModule_MyQuestionAlreadyReply>)object;

@end
