//
//  ShowQuestionModels.h
//  Accountant
//
//  Created by aaa on 2017/3/3.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionModel.h"

@interface ShowQuestionModel : NSObject

@property (nonatomic,strong) NSMutableArray         *showQuestionModels;


- (void)removeAllQuestionModels;
- (void)addQuestionModel:(QuestionModel *)questionModel;

@end
