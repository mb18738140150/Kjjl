//
//  QuestionMainViewOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/9.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionModuleProtocol.h"
#import "QuestionModuleModels.h"


@interface QuestionMainViewOperation : NSObject

@property (nonatomic,weak) ShowQuestionModel        *mainViewQuestionModel;


- (void)didRequestQuestionWithPageIndex:(int)index andNotifiedObject:(id<QuestionModule_QuestionProtocol>)object;


@end
