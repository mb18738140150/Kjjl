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
@property (nonatomic,strong) NSMutableArray         *answers;// 问题答案选项
@property (nonatomic,strong) NSString               *correctAnswerIds;
@property (nonatomic,strong) NSString               *selectedAnswerIds;// 已选答案
@property (nonatomic, copy) NSString * caseInfo;
@property (nonatomic, copy) NSString * myAnswer;
@property (nonatomic, assign)int isResponse;

@property (nonatomic, assign)int lid;//接收时对应 directionId：职称id
@property (nonatomic, assign)int kid;//接收时对应 subjectId：科目id
@property (nonatomic, assign)int cid;//接收时对应 chapterId：章id
@property (nonatomic, assign)int uid;//接收时对应 unitId：节id
@property (nonatomic, assign)int sid;//接收时对应 simulationId：模拟卷id
@property (nonatomic, assign)int isEasyWrong;

@property (nonatomic,assign) BOOL                    questionIsAnswered;// 是否一作答
@property (nonatomic, assign) BOOL                   questionIsShowAnswer;//是否显示答案及解析
@property (nonatomic,assign) BOOL                    questionIsCollected;
@property (nonatomic,assign) BOOL                    isAnsweredCorrect;
@property (nonatomic,strong) NSArray                *selectArray;

@property (nonatomic, assign)int                    questionNumber;

@property (nonatomic,assign) int                     logId;

@end
