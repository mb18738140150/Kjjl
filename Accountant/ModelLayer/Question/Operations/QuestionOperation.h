//
//  QuestionOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/2.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionModuleProtocol.h"
#import "ShowQuestionModel.h"
#import "QuestionModuleModels.h"

@interface QuestionOperation : NSObject

@property (nonatomic,weak) QuestionModuleModels     *moduleModel;

- (void)setCurrentShowQuestionModels:(ShowQuestionModel *)model;

- (void)didRequestQuestionWithPageIndex:(int)index andNotifiedObject:(id<QuestionModule_QuestionProtocol>)object;

- (void)clearAllQuestions;

@end
