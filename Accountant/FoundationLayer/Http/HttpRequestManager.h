//
//  HttpRequestManager.h
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequestProtocol.h"

@interface HttpRequestManager : NSObject

+ (instancetype)sharedManager;

- (void)requestBannerWithDelegate:(__weak id<HttpRequestProtocol>)delegate;


- (void)requestHottestCourseWithProcessDelegate:(__weak id<HttpRequestProtocol>)delegate;

- (void)requestHotSearchCourseDelegate:(__weak id<HttpRequestProtocol>)delegate;

- (void)requestSearchVideoCoueseWithProcessKeyWord:(NSString *)keyword Delegate:(__weak id<HttpRequestProtocol>)delegate;

- (void)requestSearchLivestreamWithProcessKeyWord:(NSString *)keyword Delegate:(__weak id<HttpRequestProtocol>)delegate;

- (void)requestLoginWithUserName:(NSString *)userName
                     andPassword:(NSString *)password
              andProcessDelegate:(__weak id<HttpRequestProtocol>)delegate;

- (void)requestDetailCourseWithCourseID:(int)courseID
                     andProcessDelegate:(__weak id<HttpRequestProtocol>)delegate;

- (void)requestAllCourseWithProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestQuestionWithPageIndex:(int)pageIndex withProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestQuestionDetailWithQuestionId:(int)questionId withProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestAllCourseCategoryWithProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestCategoryDetailWithCategoryId:(int)categoryId andUserId:(int)userId andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestResetPwdWithOldPassword:(NSString *)oldPwd andNewPwd:(NSString *)newPwd andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestQuestionPublishWithInfo:(NSDictionary *)questionInfo andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestHistoryCourseWithProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestAddHistoryInfoWithInfo:(NSDictionary *)info;

- (void)requestAllMyNoteWithProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestAddVideoNoteWithInfo:(NSDictionary *)info andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestDeleteVideoNoteWithId:(int)noteId andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestLearingCourseWithInfoDic:(NSDictionary *)infoDic ProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestCollectCourseWithProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestMyQuestionAlreadyReplyWithProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestMyQuestionNotReplyWithProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestAddCollectCourseWithCourseId:(int)courseId andProcessDelegate:(id<HttpRequestProtocol>)delegate;
- (void)requestDeleteCollectCourseWithCourseId:(int)courseId andProcessDelegate:(id<HttpRequestProtocol>)delegate;
- (void)requestDeleteMyLearningCourseWithCourseInfo:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestTestAllCategoryWithProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestTestChapterInfoWithCateId:(int)cateId andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestTestSectionQuestionWithSectionId:(int)sectionId andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestTestSimulateInfoWithCateId:(int)cateId andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestTestSimulateQuestionWithTestId:(int)testId andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestTestSimulateScoreWithInfo:(NSArray *)array andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)reqeustAppVersionInfoWithProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestTestErrorInfoWithCateId:(int)cateId andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)reqeustTestErrorQuesitonWithSectionId:(NSDictionary *)sectionInfo andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)reqestTestAddMyWrongQuestionWithQuestionId:(int)questionId andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestTestMyWrongChapterInfoWithCategoryId:(int)cateId andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)reqeustTestMyWrongQuestionsWithId:(NSDictionary *)sectionInfo andProcess:(id<HttpRequestProtocol>)delegate;


- (void)requestTestCollectInfoWithCateId:(int)cateId andProcessDelegate:(id<HttpRequestProtocol>)delegate;
- (void)requestTestTestCollectListWithChapter:(NSDictionary *)chapterInfo andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)reqeustTestCollectQuestionWithId:(int)questionId andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestTestUncollectQuestionWithId:(int)questionId andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestTestJurisdictionWithId:(int)courseId andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)reqeustTestAddQuestionHistoryWithInfo:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestTestAddQuestionDetailHistoryWithInfo:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)reqeustTestRecordWithInfo:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)reqeustTestRecordQuestionWithInfo:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)reqeustTestDailyPracticeWithInfo:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)reqeustTestDailyPracticeQuestionWithInfo:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestGetNotStartLivingCourseWithInfo:(NSDictionary *)infoDic ProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestGetMyLivingCourseWithInfo:(NSDictionary *)infoDic ProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestGetEndLivingCourseWithProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestGetLivingSectionDetailWithInfo:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)reqeustOrderLivingCourseWithInfo:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)reqeustCancelOrderLivingCourseWithInfo:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)reqeustBindJPushWithCId:(NSString *)CID andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)reqeustVerifyAccountWithAccountNumber:(NSString *)AccountNumber andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)reqeustVerifyCodeWithPhoneNumber:(NSString *)phoneNumber andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)reqeustRegistWithdic:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)reqeustForgetPasswordWithDic:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)reqeustCompleteUserInfoWithDic:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)reqeustBindRegCodeWithCode:(NSString *)regCode andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestPayOrderWith:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestDiscountCouponWithInfoDic:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestAcquireDiscountCouponWithInfoDic:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestOrderListWithInfoDic:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestRecommendWithInfoDic:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestGetRecommendWithInfoDic:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestGetRecommendIntegralWithInfoDic:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestAssistantCenterWithInfoDic:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestMemberLevelDetailWithProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestSubmitOpinionWithInfoDic:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestCommonProblemWithProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestLivingBackYearListWithInfoDic:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestGiftListWithInfoDic:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate;

- (void)requestSubmitGiftCodeWithInfoDic:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate;

#pragma mark - 未使用
- (void)requestSearchKeyWord:(NSString *)keyWords;
@end
