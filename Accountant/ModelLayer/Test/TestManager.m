//
//  TestManager.m
//  Accountant
//
//  Created by aaa on 2017/3/17.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestManager.h"
#import "TestAllCategoryOperation.h"
#import "TestChapterOperation.h"
#import "TestSectionQuestionOperation.h"
#import "TestSimulateInfoOperation.h"
#import "TestSimulateQuestionOperation.h"
#import "TestSimulateScoreOperation.h"
#import "CommonMacro.h"
#import "TestErrorInfoOperation.h"
#import "TestErrorQuestionOperation.h"
#import "TestMyWrongQuestionOperation.h"
#import "TestMyWrongQuestionInfoOperation.h"
#import "TestMyCollectionInfoOperation.h"
#import "TestMyCollectionQuestionListOperation.h"
#import "TestMyCollectionQuestionOperation.h"
#import "TestUncollectionQuestionOperation.h"
#import "TestQuestionHistoryOperation.h"
#import "TestJurisdictionOperation.h"
#import "TestRecordOperation.h"
#import "TestRecordQuestionOperation.h"
#import "DailyPracticeOperation.h"
#import "DailyPracticeQuestionOperation.h"


@interface TestManager ()

@property (nonatomic,strong) TestModuleModels                   *testModuleModel;

@property (nonatomic,strong) TestJurisdictionOperation          *courseJurisdiction;
@property (nonatomic,strong) TestAllCategoryOperation           *allCategoryOperation;
@property (nonatomic,strong) TestChapterOperation               *chapterOperation;
@property (nonatomic,strong) TestSectionQuestionOperation       *sectionQuestionOperation;
@property (nonatomic,strong) TestSimulateInfoOperation          *simulateInfoOperation;
@property (nonatomic,strong) TestSimulateQuestionOperation      *simulateQuestionOperation;
@property (nonatomic,strong) TestSimulateScoreOperation         *simulateScoreOperation;
@property (nonatomic,strong) TestErrorInfoOperation             *errorInfoOperation;
@property (nonatomic,strong) TestErrorQuestionOperation         *errorQuestionsOperation;
@property (nonatomic,strong) TestMyWrongQuestionOperation       *myWrongQuestionOperation;
@property (nonatomic,strong) TestMyWrongQuestionInfoOperation   *myWrongQuestionInfoOperation;
@property (nonatomic,strong) TestMyCollectionInfoOperation      *myCollectionInfoOperation;
@property (nonatomic,strong) TestMyCollectionQuestionListOperation *myCollectionQUestionListOperation;
@property (nonatomic,strong) TestMyCollectionQuestionOperation  *collectQuestionOperation;
@property (nonatomic,strong) TestUncollectionQuestionOperation  *uncollectQuestionOperation;
@property (nonatomic,strong) TestQuestionHistoryOperation       *questionHistoryOperation;
@property (nonatomic, strong) TestRecordOperation               *testRecordOperation;
@property (nonatomic, strong) TestRecordQuestionOperation       *testRecordQuestionOperation;
@property (nonatomic, strong) DailyPracticeOperation            *dailyPracticeOperation;
@property (nonatomic, strong) DailyPracticeQuestionOperation            *dailyPracticeQuestionOperation;

@end

@implementation TestManager

+ (instancetype)sharedManager
{
    static TestManager *__manager__;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager__ = [[TestManager alloc] init];
    });
    return __manager__;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.testModuleModel = [[TestModuleModels alloc] init];
        
        self.courseJurisdiction = [[TestJurisdictionOperation alloc]init];
        
        // 章节测试
        self.allCategoryOperation = [[TestAllCategoryOperation alloc] init];
        self.allCategoryOperation.allCategoryArray = self.testModuleModel.testAllCategoryArray;
        
        self.chapterOperation = [[TestChapterOperation alloc] init];
        self.chapterOperation.testChapterArray = self.testModuleModel.testChapterArray;
        
        self.sectionQuestionOperation = [TestSectionQuestionOperation new];
        self.sectionQuestionOperation.currentTestSection = self.testModuleModel.currentTestSection;
        
        // 模拟题
        self.simulateInfoOperation = [TestSimulateInfoOperation new];
        self.simulateInfoOperation.simulateArray = self.testModuleModel.testSimulateArray;
        
        self.simulateQuestionOperation = [TestSimulateQuestionOperation new];
        self.simulateQuestionOperation.simulateModel = self.testModuleModel.currentSimulateModel;
        
        self.simulateScoreOperation = [TestSimulateScoreOperation new];
        self.simulateScoreOperation.simulateResultModel = self.testModuleModel.currentSimulateWrongModel;
        
        // 易错题
        self.errorInfoOperation = [TestErrorInfoOperation new];
        self.errorInfoOperation.errorChapterArray = self.testModuleModel.testErrorArray;
        self.errorInfoOperation.simulateArray = self.testModuleModel.simulateArray;
        
        self.errorQuestionsOperation = [TestErrorQuestionOperation new];
        self.errorQuestionsOperation.currentTestSection= self.testModuleModel.currentTestSection;
        
        // 我的错题
        self.myWrongQuestionOperation = [TestMyWrongQuestionOperation new];
        self.myWrongQuestionOperation.myWrongChapterArray = self.testModuleModel.testErrorArray;
        self.myWrongQuestionOperation.simulateArray = self.testModuleModel.simulateArray;
        
        self.myWrongQuestionInfoOperation = [TestMyWrongQuestionInfoOperation new];
        self.myWrongQuestionInfoOperation.currentTestSection = self.testModuleModel.currentTestSection;
        
        // 收藏
        self.myCollectionInfoOperation = [TestMyCollectionInfoOperation new];
        self.myCollectionInfoOperation.collectChapterArray = self.testModuleModel.testErrorArray;
        self.myCollectionInfoOperation.simulateArray = self.testModuleModel.simulateArray;
        
        self.myCollectionQUestionListOperation = [TestMyCollectionQuestionListOperation new];
        self.myCollectionQUestionListOperation.currentTestSection = self.testModuleModel.currentTestSection;
        
        self.collectQuestionOperation = [TestMyCollectionQuestionOperation new];
        self.uncollectQuestionOperation = [TestUncollectionQuestionOperation new];
        
        // 添加做题记录
        self.questionHistoryOperation = [TestQuestionHistoryOperation new];
        self.questionHistoryOperation.moduleModel = self.testModuleModel;
        
        // 做题记录
        self.testRecordOperation = [TestRecordOperation new];
        self.testRecordQuestionOperation = [TestRecordQuestionOperation new];
        self.testRecordQuestionOperation.currentTestSection = self.testModuleModel.currentTestSection;

        // 每日一练
        self.dailyPracticeOperation = [DailyPracticeOperation new];
        self.dailyPracticeQuestionOperation = [DailyPracticeQuestionOperation new];
        self.dailyPracticeQuestionOperation.currentTestSection = self.testModuleModel.currentTestSection;
    }
    return self;
}

- (void)didRequestTestJurisdictionWithcourseId:(int)courseId NotifiedObject:(id<TestModule_JurisdictionProtocol>)notifiedObject
{
    [self.courseJurisdiction didJurisdictionWithCourseId:courseId andNotifiedObject:notifiedObject];
}

- (void)didRequestTestAllCategoryWithNotifiedObject:(id<TestModule_AllCategoryProtocol>)notifiedObject
{
    [self.allCategoryOperation didRequestTestAllCategoryWithNotifiedObject:notifiedObject];
}

- (void)didRequesTestChapterInfoWithCategoryId:(int)cateId andNotifiedObject:(id<TestModule_ChapterInfoProtocol>)notifiedObject
{
    [self.chapterOperation didRequestTestChapterInfoWithCategoryId:cateId andNotifiedObject:notifiedObject];
}

- (void)didRequestTestSectionQuestionWithSection:(int)sectionId andNotifiedObject:(id<TestModule_SectionQuestionProtocol>)notifiedObject
{
    [self.sectionQuestionOperation didRequestSectionQuestionWithSectionId:sectionId andNotifiedObject:notifiedObject];
}

- (void)didRequestTestSimulateInfoWithCategoryId:(int)cateId andNotifiedObject:(id<TestModule_SimulateInfoProtocol>)notifiedObject
{
    [self.simulateInfoOperation didRequestTestSimulateInfoWithCategoryId:cateId andNotifiedObject:notifiedObject];
}

- (void)didRequestTestSimulateQuestionWithTestId:(int)testId andNotifiedObject:(id<TestModule_SimulateQuestionProtocol>)notifiedObject
{
    [self.simulateQuestionOperation didRequestSimulateQuestionWithTestId:testId andNotifiedObject:notifiedObject];
}

- (void)didRequestTestSimulateScoreWithInfo:(NSArray *)array andNotifiedObject:(id<TestModule_SimulateScoreProtocol>)notifiedObject
{
    [self.simulateScoreOperation didRequestSimulateScoreWithInfo:array andNotifedObject:notifiedObject];
}

- (void)didRequestTestErrorInfoWithCategoryId:(int)cateId andNotifiedObject:(id<TestModule_ErrorInfoProtocol>)notifiedObject
{
    [self.errorInfoOperation didRequestErrorInfoWithCategoryId:cateId andNotifiedObject:notifiedObject];
}

- (void)didRequestTestErrorQuestionWithSectionId:(NSDictionary *)sectionId andNotifiedObject:(id<TestModule_ErrorQuestionProtocol>)notifiedObject
{
    [self.errorQuestionsOperation didRequestErrorQuestionWithSectionId:sectionId andNotifiedObject:notifiedObject];
}

- (void)didRequestTestAddMyWrongQuestionWithQuestionId:(int)questionId
{
    [self.myWrongQuestionOperation didAddMyWrongQuestionWithQuestionId:questionId];
}

- (void)didRequestTestMyWrongQuestionChapterInfoWithCategoryId:(int)cateId andNotifiedObject:(id<TestModule_MyWrongQuestionInfoProtocol>)notifiedObject
{
    [self.myWrongQuestionOperation didRequesMyWrongChapterWithCategoryId:cateId andNotifiedObject:notifiedObject];
}

- (void)didRequestTestMyWrongQuestionListWithChapterId:(NSDictionary *)chapterId andNotifiedObject:(id<TestModule_MyWrongQuestionsListProtocol>)notifiedObject
{
    [self.myWrongQuestionInfoOperation didRequestMyWrongQuestionListWithChapterId:chapterId andNotifiedObject:notifiedObject];
}


- (void)didRequestTestCollectionInfoWithCategoryId:(int)cateId andNotifiedObject:(id<TestModule_CollectQuestionInfoProtocol>)notifiedObject
{
    [self.myCollectionInfoOperation didRequestCollectInfoWithCategoryId:cateId andNotifiedObject:notifiedObject];
}

- (void)didRequestTestCollectionQuestionListWithChapterId:(NSDictionary *)chapterId  andNotifiedObject:(id<TestModule_CollectQuestionListProtocol>)notifiedObject
{
    [self.myCollectionQUestionListOperation didRequestTestMyCollectionQuestionListWithChapterId:chapterId  andNotifiedObject:notifiedObject];
}

- (void)didRequestTestCollectQuestionWithQuestionId:(int)questionId andNotifiedObject:(id<TestModule_CollectQuestionProtocol>)notifiedObject
{
    [self.collectQuestionOperation didCollectQuestionWithQuestionId:questionId andNotifiedObject:notifiedObject];
}

- (void)didRequestTestUncollectQuestionWithQuestionId:(int)questionId andNotifiedObject:(id<TestModule_UncollectQuestionProtocol>)notifiedObject
{
    [self.uncollectQuestionOperation didUncollectQuestionWithQuestionId:questionId andNotifiedObject:notifiedObject];
}

- (void)didRequestAddTestHistoryWithInfo:(NSDictionary *)infoDic andNotifiedObject:(id<TestModule_AddHistoryProtocol>)notifiedObject
{
    [self.questionHistoryOperation didRequesAddQuestionHistoryWithInfo:infoDic andNotifedObject:notifiedObject];
}

- (void)didRequestTestRecordWithInfo:(NSDictionary *)infoDic  andNotifiedObject:(id<TestModule_TestRecord>)notifiedObject
{
    [self.testRecordOperation didRequestTestRecordWithInfo:infoDic andNotifiedObject:notifiedObject];
}

- (void)didRequestTestRecordQoestionWithInfo:(NSDictionary *)infoDic  andNotifiedObject:(id<TestModule_TestRecordQuestion>)notifiedObject
{
    [self.testRecordQuestionOperation didRequestTestRecordQuestionWithInfo:infoDic andNotifiedObject:notifiedObject];
}

- (void)didRequestTestDailyPracticeWithInfo:(NSDictionary *)infoDic  andNotifiedObject:(id<TestModule_TestDailyPractice>)notifiedObject
{
    [self.dailyPracticeOperation didRequestTestDailyPracticeWithInfo:infoDic andNotifiedObject:notifiedObject];
}

- (void)didRequestTestDailyPracticeQoestionWithInfo:(NSDictionary *)infoDic  andNotifiedObject:(id<TestModule_TestDailyPracticeQuestion>)notifiedObject
{
    [self.dailyPracticeQuestionOperation didRequestTestDailyPracticeQuestionWithInfo:infoDic andNotifiedObject:notifiedObject];
}

- (void)didRequestAddTestHistoryDetailWithInfo:(NSDictionary *)infoDic
{
    [self.questionHistoryOperation didRequestAddQuestionHistoryDetailWithInfo:infoDic];
}

- (NSArray *)getChapterInfoArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (TestChapterModel *cModel in self.testModuleModel.testChapterArray) {
        NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
        [dic1 setObject:cModel.chapterName forKey:kTestChapterName];
        [dic1 setObject:@(cModel.chapterId) forKey:kTestChapterId];
        [dic1 setObject:@(cModel.chapterQuestionCount) forKey:kTestChapterQuestionCount];
        NSMutableArray *sArray = [[NSMutableArray alloc] init];
        for (TestSectionModel *sModel in cModel.sectionArray) {
            NSMutableDictionary *dic2 = [[NSMutableDictionary alloc] init];
            [dic2 setObject:sModel.sectionName forKey:kTestSectionName];
            [dic2 setObject:@(sModel.sectionId) forKey:kTestSectionId];
            [dic2 setObject:@(sModel.sectionQuestionCount) forKey:kTestSectionQuestionCount];
            [sArray addObject:dic2];
        }
        [dic1 setObject:sArray forKey:kTestChapterSectionArray];
        
        [array addObject:dic1];
    }
    return array;
}

- (NSArray *)getSimulateInfoArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (TestSimulateModel *model in self.testModuleModel.testSimulateArray) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:model.simulateName forKey:kTestSimulateName];
        [dic setObject:@(model.simulateId) forKey:kTestSimulateId];
        [dic setObject:@(model.simulateQuestionCount) forKey:kTestSimulateQuestionCount];
        [dic setObject:@"simulate" forKey:@"type"];
        [array addObject:dic];
    }
    return array;
}

- (NSArray *)getErrorInfoArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray * testArray = [[NSMutableArray alloc]init];
    NSMutableArray *simulateArray = [[NSMutableArray alloc]init];
    
    for (TestChapterModel *cModel in self.testModuleModel.testErrorArray) {
        NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
        [dic1 setObject:cModel.chapterName forKey:kTestChapterName];
        [dic1 setObject:@(cModel.chapterId) forKey:kTestChapterId];
        [dic1 setObject:@(cModel.chapterQuestionCount) forKey:kTestChapterQuestionCount];
        NSMutableArray *sArray = [[NSMutableArray alloc] init];
        for (TestSectionModel *sModel in cModel.sectionArray) {
            NSMutableDictionary *dic2 = [[NSMutableDictionary alloc] init];
            [dic2 setObject:sModel.sectionName forKey:kTestSectionName];
            [dic2 setObject:@(sModel.sectionId) forKey:kTestSectionId];
            [dic2 setObject:@(sModel.sectionQuestionCount) forKey:kTestSectionQuestionCount];
            [sArray addObject:dic2];
        }
        [dic1 setObject:sArray forKey:kTestChapterSectionArray];
        
        [testArray addObject:dic1];
    }
    
    for (TestSimulateModel *model in self.testModuleModel.simulateArray) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:model.simulateName forKey:kTestSimulateName];
        [dic setObject:@(model.simulateId) forKey:kTestSimulateId];
        [dic setObject:@(model.simulateQuestionCount) forKey:kTestSimulateQuestionCount];
        [simulateArray addObject:dic];
    }
    
    [array addObject:testArray];
    [array addObject:simulateArray];
    return array;
    
}

- (NSArray *)getMyWrongChapterInfoArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray * testArray = [[NSMutableArray alloc]init];
    NSMutableArray *simulateArray = [[NSMutableArray alloc]init];
    
    for (TestChapterModel *cModel in self.testModuleModel.testErrorArray) {
        NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
        [dic1 setObject:cModel.chapterName forKey:kTestChapterName];
        [dic1 setObject:@(cModel.chapterId) forKey:kTestChapterId];
        [dic1 setObject:@(cModel.chapterQuestionCount) forKey:kTestChapterQuestionCount];
        NSMutableArray *sArray = [[NSMutableArray alloc] init];
        for (TestSectionModel *sModel in cModel.sectionArray) {
            NSMutableDictionary *dic2 = [[NSMutableDictionary alloc] init];
            [dic2 setObject:sModel.sectionName forKey:kTestSectionName];
            [dic2 setObject:@(sModel.sectionId) forKey:kTestSectionId];
            [dic2 setObject:@(sModel.sectionQuestionCount) forKey:kTestSectionQuestionCount];
            [sArray addObject:dic2];
        }
        [dic1 setObject:sArray forKey:kTestChapterSectionArray];
        
        [testArray addObject:dic1];
    }
    
    for (TestSimulateModel *model in self.testModuleModel.simulateArray) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:model.simulateName forKey:kTestSimulateName];
        [dic setObject:@(model.simulateId) forKey:kTestSimulateId];
        [dic setObject:@(model.simulateQuestionCount) forKey:kTestSimulateQuestionCount];
        [simulateArray addObject:dic];
    }
    
    [array addObject:testArray];
    [array addObject:simulateArray];
    return array;
}

- (void)nextQuestion
{
    [self.testModuleModel nextQuestion];
}

- (void)previousQuestion
{
    [self.testModuleModel previousQuestion];
}

- (void)collectCurrentQuestion
{
    self.testModuleModel.colectModelType = self.colectType;
    [self.testModuleModel collectQuestionAtIndex:[self getCurrentQuestionIndex]];
}

- (void)uncollectCurrentQuestion
{
    self.testModuleModel.colectModelType = self.colectType;
    [self.testModuleModel uncollectQuestionAtIndex:[self getCurrentQuestionIndex]];
}

- (int)getCurrentQuestionIndex
{
    return self.testModuleModel.currentQuestionIndex;
}

- (void)resetCurrentQuestionInfos
{
    self.testModuleModel.currentQuestionIndex = 0;
}

- (void)resetCurrentQuestionInfoswith:(int)index
{
    self.testModuleModel.currentQuestionIndex = index;
}

- (int)getTestSectionTotalCount
{
    return (int)self.testModuleModel.currentTestSection.questionArray.count;
}

- (void)submitAnswers:(NSMutableArray *)answerArray andQuestionIndex:(int)questionIndex
{
    [self.testModuleModel submitSectionQuestionAnswers:answerArray andIndex:questionIndex];
}



- (void)showQuestionAnswerWithQuestionIndex:(int)questionIndex
{
    [self.testModuleModel showQuestionAnswerWithQuestionIndex:questionIndex];
}

- (void)submitSimulateAnswers:(NSMutableArray *)answerArray andQuestionIndex:(int)questionIndex
{
    [self.testModuleModel submitSimulateQuestionAnswers:answerArray andIndex:questionIndex];
}

- (void)reSubmitSimulateAnswers:(NSMutableArray *)answerArray andQuestionIndex:(int)questionIndex
{
    [self.testModuleModel reSubmitSimulateAnswers:answerArray andQuestionIndex:questionIndex];
}

- (int)getTestSimulateTotalCount
{
    return (int)self.testModuleModel.currentSimulateModel.questionArray.count;
}

- (int)getTestSimulateWrongTotalCount
{
    return (int)self.testModuleModel.currentSimulateWrongModel.questionArray.count;
}

- (int)getLogId
{
    return self.testModuleModel.logId;
}


- (NSArray *)getTestRecord
{
    return self.testRecordOperation.dataArray;
}

- (NSDictionary *)getCurrentSimulateQuestionInfo
{
    TestQuestionModel *questionModel = [self.testModuleModel.currentSimulateModel.questionArray objectAtIndex:self.testModuleModel.currentQuestionIndex];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@(questionModel.lid) forKey:kLID];
    [dic setObject:@(questionModel.kid) forKey:kKID];
    [dic setObject:@(questionModel.cid) forKey:kTestChapterId];
    [dic setObject:@(questionModel.uid) forKey:kTestSectionId];
    [dic setObject:@(questionModel.sid) forKey:kTestSimulateId];
    [dic setObject:@(questionModel.isEasyWrong) forKey:kTestIsEasyWrong];
    [dic setObject:@(questionModel.questionId) forKey:kTestQuestionId];
    [dic setObject:questionModel.questionContent forKey:kTestQuestionContent];
    [dic setObject:questionModel.questionComplain forKey:kTestQuestionComplain];
    [dic setObject:questionModel.questionType forKey:kTestQuestionType];
    [dic setObject:questionModel.correctAnswerIds forKey:kTestQuestionCorrectAnswersId];
    [dic setObject:@(questionModel.questionIsAnswered) forKey:kTestQuestionIsAnswered];
    [dic setObject:@(questionModel.questionIsCollected) forKey:kTestQuestionIsCollected];
    [dic setObject:questionModel.caseInfo forKey:kQuestionCaseInfo];
    
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (TestAnswerModel *answerModel in questionModel.answers) {
        NSMutableDictionary *dic1 = [NSMutableDictionary new];
        [dic1 setObject:answerModel.answerContent forKey:kTestAnswerContent];
        [dic1 setObject:answerModel.answerId forKey:kTestAnserId];
        [array addObject:dic1];
    }
    [dic setObject:questionModel.selectArray forKey:kTestQuestionSelectedAnswers];
    [dic setObject:array forKey:kTestQuestionAnswers];
    return dic;
}

- (NSArray *)getTestDailyPractice
{
    NSMutableArray * array = [NSMutableArray array];
    [array addObject:self.dailyPracticeOperation.dataArray];
    [array addObject:self.dailyPracticeOperation.lastDataArray];
    return array;
}

- (NSArray *)getCurrentwriteSinulateQuestions
{
    NSMutableArray *marray = [NSMutableArray array];
    for (int i = 0; i <self.testModuleModel.currentQuestionIndex ; i++) {
        TestQuestionModel *questionModel = [self.testModuleModel.currentSimulateModel.questionArray objectAtIndex:i];
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:@(questionModel.lid) forKey:kLID];
        [dic setObject:@(questionModel.kid) forKey:kKID];
        [dic setObject:@(questionModel.cid) forKey:kTestChapterId];
        [dic setObject:@(questionModel.uid) forKey:kTestSectionId];
        [dic setObject:@(questionModel.sid) forKey:kTestSimulateId];
        [dic setObject:@(questionModel.isEasyWrong) forKey:kTestIsEasyWrong];
        [dic setObject:@(questionModel.questionId) forKey:kTestQuestionId];
        [dic setObject:questionModel.questionContent forKey:kTestQuestionContent];
        [dic setObject:questionModel.questionComplain forKey:kTestQuestionComplain];
        [dic setObject:questionModel.questionType forKey:kTestQuestionType];
        [dic setObject:questionModel.correctAnswerIds forKey:kTestQuestionCorrectAnswersId];
        [dic setObject:@(questionModel.questionIsAnswered) forKey:kTestQuestionIsAnswered];
        [dic setObject:@(questionModel.questionIsCollected) forKey:kTestQuestionIsCollected];
        [dic setObject:questionModel.caseInfo forKey:kQuestionCaseInfo];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (TestAnswerModel *answerModel in questionModel.answers) {
            NSMutableDictionary *dic1 = [NSMutableDictionary new];
            [dic1 setObject:answerModel.answerContent forKey:kTestAnswerContent];
            [dic1 setObject:answerModel.answerId forKey:kTestAnserId];
            [array addObject:dic1];
        }
        [dic setObject:questionModel.selectArray forKey:kTestQuestionSelectedAnswers];
        [dic setObject:array forKey:kTestQuestionAnswers];
        [marray addObject:dic];
    }
    return [marray copy];
}

- (NSDictionary *)getCurrentSimulateWrongQuestionInfo
{
    TestQuestionModel *questionModel = [self.testModuleModel.currentSimulateWrongModel.questionArray objectAtIndex:self.testModuleModel.currentQuestionIndex];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@(questionModel.lid) forKey:kLID];
    [dic setObject:@(questionModel.kid) forKey:kKID];
    [dic setObject:@(questionModel.cid) forKey:kTestChapterId];
    [dic setObject:@(questionModel.uid) forKey:kTestSectionId];
    [dic setObject:@(questionModel.sid) forKey:kTestSimulateId];
    [dic setObject:@(questionModel.isEasyWrong) forKey:kTestIsEasyWrong];
    [dic setObject:@(questionModel.questionId) forKey:kTestQuestionId];
    [dic setObject:questionModel.questionContent forKey:kTestQuestionContent];
    [dic setObject:questionModel.questionComplain forKey:kTestQuestionComplain];
    [dic setObject:questionModel.questionType forKey:kTestQuestionType];
    [dic setObject:questionModel.correctAnswerIds forKey:kTestQuestionCorrectAnswersId];
    [dic setObject:@(questionModel.questionIsAnswered) forKey:kTestQuestionIsAnswered];
    [dic setObject:@(questionModel.questionIsCollected) forKey:kTestQuestionIsCollected];
    [dic setObject:questionModel.caseInfo forKey:kQuestionCaseInfo];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (TestAnswerModel *answerModel in questionModel.answers) {
        NSMutableDictionary *dic1 = [NSMutableDictionary new];
        [dic1 setObject:answerModel.answerContent forKey:kTestAnswerContent];
        [dic1 setObject:answerModel.answerId forKey:kTestAnserId];
        [array addObject:dic1];
    }
    [dic setObject:questionModel.selectArray forKey:kTestQuestionSelectedAnswers];
    [dic setObject:array forKey:kTestQuestionAnswers];
    return dic;
}

// 获取当前做题记录问题
- (NSDictionary *)getCurrentTestRecorsQuestionInfo
{
    TestQuestionModel *questionModel = [self.testModuleModel.currentTestSection.questionArray objectAtIndex:self.testModuleModel.currentQuestionIndex];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@(questionModel.lid) forKey:kLID];
    [dic setObject:@(questionModel.kid) forKey:kKID];
    [dic setObject:@(questionModel.cid) forKey:kTestChapterId];
    [dic setObject:@(questionModel.uid) forKey:kTestSectionId];
    [dic setObject:@(questionModel.sid) forKey:kTestSimulateId];
    [dic setObject:questionModel.myAnswer forKey:kTestMyanswer];
    [dic setObject:@(questionModel.isResponse) forKey:kTestIsResponse];
    [dic setObject:@(questionModel.isEasyWrong) forKey:kTestIsEasyWrong];
    [dic setObject:@(questionModel.questionId) forKey:kTestQuestionId];
    [dic setObject:questionModel.questionContent forKey:kTestQuestionContent];
    [dic setObject:questionModel.questionComplain forKey:kTestQuestionComplain];
    [dic setObject:questionModel.questionType forKey:kTestQuestionType];
    [dic setObject:questionModel.correctAnswerIds forKey:kTestQuestionCorrectAnswersId];
    [dic setObject:@(questionModel.questionIsAnswered) forKey:kTestQuestionIsAnswered];
    [dic setObject:@(questionModel.questionIsShowAnswer) forKey:kTestQuestionIsShowAnswer];
    [dic setObject:@(questionModel.questionIsCollected) forKey:kTestQuestionIsCollected];
    [dic setObject:questionModel.caseInfo forKey:kQuestionCaseInfo];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (TestAnswerModel *answerModel in questionModel.answers) {
        NSMutableDictionary *dic1 = [NSMutableDictionary new];
        [dic1 setObject:answerModel.answerContent forKey:kTestAnswerContent];
        [dic1 setObject:answerModel.answerId forKey:kTestAnserId];
        [array addObject:dic1];
    }
    [dic setObject:questionModel.selectArray forKey:kTestQuestionSelectedAnswers];
    [dic setObject:array forKey:kTestQuestionAnswers];
    return dic;
}

// 获取当前章节测试题目信息
- (NSDictionary *)getCurrentSectionQuestionInfo
{
    TestQuestionModel *questionModel = [self.testModuleModel.currentTestSection.questionArray objectAtIndex:self.testModuleModel.currentQuestionIndex];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@(questionModel.lid) forKey:kLID];
    [dic setObject:@(questionModel.kid) forKey:kKID];
    [dic setObject:@(questionModel.cid) forKey:kTestChapterId];
    [dic setObject:@(questionModel.uid) forKey:kTestSectionId];
    [dic setObject:@(questionModel.sid) forKey:kTestSimulateId];
    [dic setObject:@(questionModel.isEasyWrong) forKey:kTestIsEasyWrong];
    [dic setObject:@(questionModel.questionId) forKey:kTestQuestionId];
    [dic setObject:questionModel.questionContent forKey:kTestQuestionContent];
    [dic setObject:questionModel.questionComplain forKey:kTestQuestionComplain];
    [dic setObject:questionModel.questionType forKey:kTestQuestionType];
    [dic setObject:questionModel.correctAnswerIds forKey:kTestQuestionCorrectAnswersId];
    [dic setObject:@(questionModel.questionIsAnswered) forKey:kTestQuestionIsAnswered];
    [dic setObject:@(questionModel.questionIsShowAnswer) forKey:kTestQuestionIsShowAnswer];
    [dic setObject:@(questionModel.questionIsCollected) forKey:kTestQuestionIsCollected];
    [dic setObject:questionModel.caseInfo forKey:kQuestionCaseInfo];
    [dic setObject:@(questionModel.isResponse) forKey:kTestIsResponse];
    if (questionModel.myAnswer) {
        [dic setObject:questionModel.myAnswer forKey:kTestMyanswer];
    }
    
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (TestAnswerModel *answerModel in questionModel.answers) {
        NSMutableDictionary *dic1 = [NSMutableDictionary new];
        [dic1 setObject:answerModel.answerContent forKey:kTestAnswerContent];
        [dic1 setObject:answerModel.answerId forKey:kTestAnserId];
        [array addObject:dic1];
    }
    [dic setObject:questionModel.selectArray forKey:kTestQuestionSelectedAnswers];
    [dic setObject:array forKey:kTestQuestionAnswers];
    return dic;
}

// 获取已做的章节测试题题信息
- (NSArray *)getCurrentWriteTestQuestions:(BOOL)haveCurrent
{
    NSMutableArray * marray = [NSMutableArray array];
    
    int  currentIndex = self.testModuleModel.currentQuestionIndex;
    
    if (!haveCurrent) {
        if (currentIndex > 0) {
            currentIndex--;
        }
    }
    
    for (int i = 0 ; i <= currentIndex; i++) {
        TestQuestionModel *questionModel = [self.testModuleModel.currentTestSection.questionArray objectAtIndex:i];
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:@(questionModel.lid) forKey:kLID];
        [dic setObject:@(questionModel.kid) forKey:kKID];
        [dic setObject:@(questionModel.cid) forKey:kTestChapterId];
        [dic setObject:@(questionModel.uid) forKey:kTestSectionId];
        [dic setObject:@(questionModel.sid) forKey:kTestSimulateId];
        [dic setObject:@(questionModel.isEasyWrong) forKey:kTestIsEasyWrong];
        [dic setObject:@(questionModel.questionId) forKey:kTestQuestionId];
        [dic setObject:questionModel.questionContent forKey:kTestQuestionContent];
        [dic setObject:questionModel.questionComplain forKey:kTestQuestionComplain];
        [dic setObject:questionModel.questionType forKey:kTestQuestionType];
        [dic setObject:questionModel.correctAnswerIds forKey:kTestQuestionCorrectAnswersId];
        [dic setObject:@(questionModel.questionIsAnswered) forKey:kTestQuestionIsAnswered];
        [dic setObject:@(questionModel.questionIsCollected) forKey:kTestQuestionIsCollected];
        [dic setObject:questionModel.caseInfo forKey:kQuestionCaseInfo];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (TestAnswerModel *answerModel in questionModel.answers) {
            NSMutableDictionary *dic1 = [NSMutableDictionary new];
            [dic1 setObject:answerModel.answerContent forKey:kTestAnswerContent];
            [dic1 setObject:answerModel.answerId forKey:kTestAnserId];
            [array addObject:dic1];
        }
        [dic setObject:questionModel.selectArray forKey:kTestQuestionSelectedAnswers];
        [dic setObject:array forKey:kTestQuestionAnswers];
        [marray addObject:dic];
    }
    
    return [marray copy];
}


- (NSArray *)getSimulateMyAnswersInfo
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    int i = 1;
    for (TestQuestionModel *model in self.testModuleModel.currentSimulateModel.questionArray) {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        NSArray *selectedArray = model.selectArray;
        NSMutableString *myStr = [[NSMutableString alloc] init];
        
        if (selectedArray.count == 0) {
            [myStr appendFormat:@"未作答"];
        }else{
            for (NSNumber *number in selectedArray) {
                [myStr appendString:[NSString stringWithFormat:@"%@",number]];
            }
        }
        
        [dic setObject:myStr forKey:kTestQuestionAnswers];
        [dic setObject:@(i) forKey:kTestQuestionIndex];
        i++;
        [array addObject:dic];
    }
    return array;
}

- (NSDictionary *)getSimulateresult
{
    NSMutableDictionary * mdic = [NSMutableDictionary dictionary];
    
    NSMutableArray * rightQuestionArr = [NSMutableArray array];
    NSMutableArray * wrongQuestionArr = [NSMutableArray array];
    NSMutableArray * singleQuestionArr = [NSMutableArray array];
    NSMutableArray * multipleQuestionArr = [NSMutableArray array];
    NSMutableArray * judgeQuestionArr = [NSMutableArray array];
    NSMutableArray * materialQuestionArr = [NSMutableArray array];
    
    [self.simulateScoreOperation.simulateResultModel removeAllQuestion];
    for (int i = 0; i < self.testModuleModel.currentSimulateModel.questionArray.count; i++) {
        TestQuestionModel * questionModel = self.testModuleModel.currentSimulateModel.questionArray[i];
        questionModel.questionNumber = i + 1;
        
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:@(questionModel.lid) forKey:kLID];
        [dic setObject:@(questionModel.kid) forKey:kKID];
        [dic setObject:@(questionModel.cid) forKey:kTestChapterId];
        [dic setObject:@(questionModel.uid) forKey:kTestSectionId];
        [dic setObject:@(questionModel.sid) forKey:kTestSimulateId];
        [dic setObject:@(questionModel.isEasyWrong) forKey:kTestIsEasyWrong];
        [dic setObject:@(questionModel.questionId) forKey:kTestQuestionId];
        [dic setObject:questionModel.questionContent forKey:kTestQuestionContent];
        [dic setObject:questionModel.questionComplain forKey:kTestQuestionComplain];
        [dic setObject:questionModel.questionType forKey:kTestQuestionType];
        [dic setObject:questionModel.correctAnswerIds forKey:kTestQuestionCorrectAnswersId];
        [dic setObject:@(questionModel.questionIsAnswered) forKey:kTestQuestionIsAnswered];
        [dic setObject:@(questionModel.questionIsCollected) forKey:kTestQuestionIsCollected];
        [dic setObject:@(questionModel.isAnsweredCorrect) forKey:kTestQuestionIsAnswerCorrect];
        [dic setObject:@(questionModel.questionNumber) forKey:kTestQuestionNumber];
        [dic setObject:questionModel.caseInfo forKey:kQuestionCaseInfo];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (TestAnswerModel *answerModel in questionModel.answers) {
            NSMutableDictionary *dic1 = [NSMutableDictionary new];
            [dic1 setObject:answerModel.answerContent forKey:kTestAnswerContent];
            [dic1 setObject:answerModel.answerId forKey:kTestAnserId];
            [array addObject:dic1];
        }
        [dic setObject:questionModel.selectArray forKey:kTestQuestionSelectedAnswers];
        [dic setObject:array forKey:kTestQuestionAnswers];
        
        if (questionModel.isAnsweredCorrect) {
            [rightQuestionArr addObject:dic];
        }else
        {
            [wrongQuestionArr addObject:dic];
            [self.simulateScoreOperation.simulateResultModel addQuestion:questionModel];
        }
        
        if ([questionModel.questionType isEqualToString:@"单选题"]) {
            [singleQuestionArr addObject:dic];
        }else if ([questionModel.questionType isEqualToString:@"判断题"])
        {
            [judgeQuestionArr addObject:dic];
        }else if ([questionModel.questionType isEqualToString:@"多选题"])
        {
            [multipleQuestionArr addObject:dic];
        }else
        {
            [materialQuestionArr addObject:dic];
        }
        
    }
    
    [mdic setObject:rightQuestionArr forKey:kRightquistionArr];
    [mdic setObject:wrongQuestionArr forKey:kWrongquistionArr];
    [mdic setObject:singleQuestionArr forKey:kSinglequistionArr];
    [mdic setObject:multipleQuestionArr forKey:kMultiplequistionArr];
    [mdic setObject:judgeQuestionArr forKey:kJudgequistionArr];
    [mdic setObject:materialQuestionArr forKey:kMaterailQuestionArray];
    
    return mdic;
}

@end
