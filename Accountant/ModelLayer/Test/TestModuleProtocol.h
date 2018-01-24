//
//  TestModuleProtocol.h
//  Accountant
//
//  Created by aaa on 2017/3/17.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TestModule_AllCategoryProtocol <NSObject>

- (void)didRequestAllTestCategorySuccess;
- (void)didRequestAllTestCategoryFailed:(NSString *)failedInfo;

@end

@protocol TestModule_ChapterInfoProtocol <NSObject>

- (void)didRequestChapterInfoSuccess;
- (void)didRequestChapterInfoFailed:(NSString *)failedInfo;

@end

@protocol TestModule_SectionQuestionProtocol <NSObject>

- (void)didRequestSectionQuestionSuccess;
- (void)didRequestSectionQuestionFailed:(NSString *)failedInfo;

@end

@protocol TestModule_SimulateInfoProtocol <NSObject>

- (void)didRequestSimulateInfoSuccess;
- (void)didRequestSimulateInfoFailed:(NSString *)failedInfo;

@end

@protocol TestModule_SimulateQuestionProtocol <NSObject>

- (void)didRequestSimulateQuestionSuccess;
- (void)didRequestSimulateQuestionFailed:(NSString *)failedInfo;

@end

@protocol TestModule_SimulateScoreProtocol <NSObject>

- (void)didRequestSimulateScoreSuccess;
- (void)didRequestSimulateScoreFailed:(NSString *)failedInfo;

@end

@protocol TestModule_ErrorInfoProtocol <NSObject>

- (void)didReqeustErrorInfoSuccess;
- (void)didReqeustErrorInfoFailed:(NSString *)failedInfo;

@end

@protocol TestModule_ErrorQuestionProtocol <NSObject>

- (void)didRequestErrorQuestionSuccess;
- (void)didRequestErrorQuestionFailed:(NSString *)failedInfo;

@end

@protocol TestModule_MyWrongQuestionInfoProtocol <NSObject>

- (void)didRequestMyWrongQuestionSuccess;
- (void)didRequestMyWrongQuestionFailed:(NSString *)failedInfo;

@end

@protocol TestModule_MyWrongQuestionsListProtocol <NSObject>

- (void)didRequestMyWrongQuestionsListSuccess;
- (void)didRequestMyWrongQuestionsListFailed:(NSString *)failedInfo;

@end

@protocol TestModule_CollectQuestionInfoProtocol <NSObject>

- (void)didRequestCollectQuestionInfoSuccess;
- (void)didRequestCollectQuestionInfoFailed:(NSString *)failedInfo;

@end

@protocol TestModule_CollectQuestionListProtocol <NSObject>

- (void)didRequestCollectQuestionListSuccess;
- (void)didRequestCollectQuestionListFailed:(NSString *)failedInfo;

@end

@protocol TestModule_CollectQuestionProtocol <NSObject>

- (void)didRequestCollectQuestionSuccess;
- (void)didRequestCollectQuestionFailed:(NSString *)failedInfo;

@end

@protocol TestModule_UncollectQuestionProtocol <NSObject>

- (void)didRequestUncollectQuestionSuccess;
- (void)didRequestUncollectQuestionFailed:(NSString *)failedInfo;

@end

@protocol TestModule_AddHistoryProtocol <NSObject>

- (void)didRequestAddHistorySuccess;
- (void)didRequestAddHistoryFailed:(NSString *)failedInfo;

@end


@protocol TestModule_JurisdictionProtocol <NSObject>

- (void)didRequestJurisdictionSuccess;
- (void)didRequestJurisdictionFailed:(NSString *)failedInfo;

@end

@protocol TestModule_TestRecord <NSObject>

- (void)didRequestTestRecordSuccess;
- (void)didRequestTestRecordFailed:(NSString *)failedInfo;

@end

@protocol TestModule_TestRecordQuestion <NSObject>

- (void)didRequestTestRecordQuestionSuccess;
- (void)didRequestTestRecordQuestionFailed:(NSString *)failedInfo;

@end

@protocol TestModule_TestDailyPractice <NSObject>

- (void)didRequestTestDailyPracticeSuccess;
- (void)didRequestTestDailyPracticeFailed:(NSString *)failedInfo;

@end

@protocol TestModule_TestDailyPracticeQuestion <NSObject>

- (void)didRequestTestDailyPracticeQuestionSuccess;
- (void)didRequestTestDailyPracticeQuestionFailed:(NSString *)failedInfo;

@end
