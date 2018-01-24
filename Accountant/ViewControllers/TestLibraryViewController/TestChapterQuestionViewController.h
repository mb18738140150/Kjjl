//
//  TestChapterQuestionViewController.h
//  Accountant
//
//  Created by aaa on 2017/3/22.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestViewQuestionModels.h"

typedef enum {
    TestQuestionTypeError = 0,
    TestQuestionTypeChapter,
    TestQuestionTypeMyWrong,
    TestQuestionTypeCollect,
    TestQuestionTypeRecord,
    TestQuestionTypeDailyPractice
}TestQuestionViewType;

@interface TestChapterQuestionViewController : UIViewController

@property (nonatomic,assign) TestQuestionViewType                questionType;
@property (nonatomic, assign)int logId;
@property (nonatomic, strong)NSMutableDictionary *currentDBourseInfoDic;
@property (nonatomic, strong)NSDictionary * currentsectionQuestionInfoDic;

@end
