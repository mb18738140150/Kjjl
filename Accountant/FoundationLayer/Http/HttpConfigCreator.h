//
//  HttpConfigCreator.h
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpConfigModel.h"

@interface HttpConfigCreator : NSObject

+ (HttpConfigModel *)getBannerHttpConfig;

+ (HttpConfigModel *)getLoginHttpConfigWithUserName:(NSString *)userName andPassword:(NSString *)password;

+ (HttpConfigModel *)getHotSearchCourse;

+ (HttpConfigModel *)getHottestHttpConfig;

+(HttpConfigModel *)getSearchVideoCoueseHttpConfigWith:(NSString *)keyword;

+(HttpConfigModel *)getSearchLivestreamHttpConfigWith:(NSString *)keyword;

+ (HttpConfigModel *)getCourseDetailConfigWithCourseID:(int)courseID;

+ (HttpConfigModel *)getAllCourseConfig;

+ (HttpConfigModel *)getQuestionConfigWithPageCount:(int)pageCount;

+ (HttpConfigModel *)getQuestionDetailConfigWithQuestionId:(int)questionId;

+ (HttpConfigModel *)getAllCategoryConfig;

+ (HttpConfigModel *)getCategoryDetailConfigWithCategoryId:(int)categoryId andUserId:(int)userId;

+ (HttpConfigModel *)getResetPwdConfigWithOldPwd:(NSString *)oldPwd andNewPwd:(NSString *)newPwd;

+ (HttpConfigModel *)getPublishConfigWithInfo:(NSDictionary *)questionInfo;

+ (HttpConfigModel *)getHistoryConfig;

+ (HttpConfigModel *)getAllMyNoteConfig;

+ (HttpConfigModel *)getLearningConfig;

+ (HttpConfigModel *)getCollectConfig;

+ (HttpConfigModel *)getMyQuestionAlreadyReplyConfig;

+ (HttpConfigModel *)getMyQuestionNotReplyConfig;

+ (HttpConfigModel *)getAddCollectCourseConfigWithCourseId:(int)courseId;

+ (HttpConfigModel *)getDeleteCollectCourseConfigWithCourseId:(int)courseId;

+ (HttpConfigModel *)getAddVideoNoteConfigWithInfo:(NSDictionary *)info;

+ (HttpConfigModel *)getDeleteVideoNoteConfigWithId:(int)noteId;

+ (HttpConfigModel *)getAddHistoryConfigWithInfo:(NSDictionary *)info;

+ (HttpConfigModel *)getTestAllCategoryConfig;

+ (HttpConfigModel *)getTestChapterInfoWithId:(int)cateId;

+ (HttpConfigModel *)getTestSectionInfoWithId:(int)sectionId;

+ (HttpConfigModel *)getTestSimulateInfoWithId:(int)cateId;

+ (HttpConfigModel *)getTestSimulateQuestionWithId:(int)testId;

+ (HttpConfigModel *)getTestSimulateScoreWithInfo:(NSArray *)array;

+ (HttpConfigModel *)getAppVersionInfoConfig;

+ (HttpConfigModel *)getTestErrorInfoWithId:(int)cateId;

+ (HttpConfigModel *)getTestErrorQuestionWithSectionId:(int)sectionId;

+ (HttpConfigModel *)getTestAddMyWrongQuestionWithQuestionId:(int)questionId;

+ (HttpConfigModel *)getTestMyWrongChapterListWithCategoryId:(int)cateId;

+ (HttpConfigModel *)getTestMyWrongQuestionWithId:(int)sectionId;

+(HttpConfigModel *)getTestCollectionInfoWithCategoryId:(int)cateId;

+(HttpConfigModel *)getTestCollectionQuestionListWithChapterId:(int)chapterId;

+ (HttpConfigModel *)getTestCollectQuestionWithQuestionId:(int)questionId;

+ (HttpConfigModel *)getTestUncollectQuestionWithQuestionId:(int)questionId;

+ (HttpConfigModel *)getTestHistoryConfigWithInfo:(NSDictionary *)infoDic;

+ (HttpConfigModel *)getTestHistoryDetailConfigWithInfo:(NSDictionary *)infoDic;

+ (HttpConfigModel *)getNotStartLiveingCourse;

+ (HttpConfigModel *)getEndLivingCourse;

+ (HttpConfigModel *)getOrderLivingCourseWithCourseId:(int)courseId;

+ (HttpConfigModel *)getBindJPushWithCId:(NSString *)CID;

@end
