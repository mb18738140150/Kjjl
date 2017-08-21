//
//  TestQuestionModel.h
//  Accountant
//
//  Created by aaa on 2017/3/17.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TestQuestionTypeSingle = 0,
    TestQuestionTypeMutil,
    TestQuestionTypeJudgement
}TestQuestionType;

@interface TestQuestionModel : NSObject

@property (nonatomic,assign) int                     questionId;
//@property (nonatomic,assign) TestQuestionType        questionType;
@property (nonatomic,strong) NSString               *questionType;
@property (nonatomic,strong) NSString               *questionContent;
@property (nonatomic,strong) NSString               *questionComplain;
@property (nonatomic,strong) NSMutableArray         *answers;
@property (nonatomic,strong) NSString               *correctAnswerIds;
@property (nonatomic,strong) NSString               *selectedAnswerIds;
@property (nonatomic, copy) NSString * caseInfo;

@property (nonatomic,assign) BOOL                    questionIsAnswered;// 是否一作答
@property (nonatomic, assign) BOOL                   questionIsShowAnswer;//是否显示答案及解析
@property (nonatomic,assign) BOOL                    questionIsCollected;
@property (nonatomic,assign) BOOL                    isAnsweredCorrect;
@property (nonatomic,strong) NSArray                *selectArray;

@property (nonatomic, assign)int                    questionNumber;

@property (nonatomic,assign) int                     logId;

@end
