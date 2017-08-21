//
//  QuestionDetailOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/7.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionModuleProtocol.h"
#import "QuestionDetailModel.h"

@interface QuestionDetailOperation : NSObject

@property (nonatomic,weak) id<QuestionModule_QuestionDetailProtocol>         notifiedObject;

@property (nonatomic,weak) QuestionDetailModel                              *detailModel;

- (void)didRequestQuestionDetailWithQuestionId:(int)questionId andNotifiedObject:(id<QuestionModule_QuestionDetailProtocol>)object;

@end
