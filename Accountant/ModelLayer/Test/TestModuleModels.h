//
//  TestModuleModels.h
//  Accountant
//
//  Created by aaa on 2017/3/17.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestCategoryModel.h"
#import "TestChapterModel.h"
#import "TestSectionModel.h"
#import "TestQuestionModel.h"
#import "TestAnswerModel.h"
#import "TestSimulateModel.h"

typedef enum {
    CollectTypeModelTest = 0,
    CollectTypeModelSimulate,
    CollectTypeModelSimulateWrong
}CollectModelType;

@interface TestModuleModels : NSObject

@property (nonatomic, assign)CollectModelType colectModelType;

@property (nonatomic,strong) NSMutableArray         *testAllCategoryArray;

//章节练习列表
@property (nonatomic,strong) NSMutableArray         *testChapterArray;

//模拟题列表
@property (nonatomic,strong) NSMutableArray         *testSimulateArray;

//易错题、收藏夹和我的错题章节列表(包括章节与模拟)
@property (nonatomic,strong) NSMutableArray         *testErrorArray;
@property (nonatomic, strong) NSMutableArray        *simulateArray;


//章节、易错题和我的错题  
@property (nonatomic,strong) TestSectionModel       *currentTestSection;

//模拟题
@property (nonatomic,strong) TestSimulateModel      *currentSimulateModel;

// 模拟题错题
@property (nonatomic, strong) TestSimulateModel      *currentSimulateWrongModel;

//当前问题的index
@property (nonatomic,assign) int                     currentQuestionIndex;

@property (nonatomic,assign) int                     logId;



/**
 下一个问题index
 */
- (void)previousQuestion;

/**
 上一个问题index
 */
- (void)nextQuestion;


/**
 提交问题答案

 @param answers 问题答案
 @param questionIndex 问题index
 */
- (void)submitSectionQuestionAnswers:(NSMutableArray *)answers andIndex:(int)questionIndex;
- (void)submitSimulateQuestionAnswers:(NSMutableArray *)answers andIndex:(int)questionIndex;

- (void)reSubmitSimulateAnswers:(NSMutableArray *)answerArray andQuestionIndex:(int)questionIndex;

- (void)showQuestionAnswerWithQuestionIndex:(int)questionIndex;

/**
 收藏和取消收藏某个问题

 @param questionIndex 问题id
 */
- (void)collectQuestionAtIndex:(int)questionIndex;
- (void)uncollectQuestionAtIndex:(int)questionIndex;

@end
