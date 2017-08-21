//
//  TestViewQuestionModels.h
//  Accountant
//
//  Created by aaa on 2017/3/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestViewQuestionAnswerModel.h"

@interface TestViewQuestionModel : NSObject

@property (nonatomic,strong) NSString       *questionContent;
@property (nonatomic,strong) NSString       *questionComplain;
@property (nonatomic,strong) NSString       *questionAnswerIdString;
@property (nonatomic,strong) NSMutableArray *questionAnswers;

@end
