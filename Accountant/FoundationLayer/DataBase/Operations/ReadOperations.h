//
//  ReadOperations.h
//  Accountant
//
//  Created by aaa on 2017/3/9.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "JSONKit.h"
#import "DownLoadModel.h"

@interface ReadOperations : NSObject

@property (nonatomic,weak)  FMDatabase      *dataBase;

- (BOOL)isDownLoadVideoSavesWithId:(NSDictionary *)videoInfo;
- (BOOL)isCourseSavedWithId:(NSDictionary *)courseInfo;
- (BOOL)isChapterSavedWithId:(NSDictionary *)chapterInfo;
- (BOOL)isVideoSavedWithId:(NSDictionary *)videoInfo;
- (BOOL)isLineVideoSavedWithId:(NSNumber *)videoId;
- (NSArray *)getDownloadCoursesInfos;

- (NSArray *)getDownloadingVideos;

- (NSDictionary *)getCourseInfosWithCourseId:(NSNumber *)courseId;

- (NSDictionary *)getLineCourseInfoWithVideoId:(NSNumber *)videoId;

// 模拟测试
- (BOOL)isSimulateTestSavedWithId:(NSDictionary *)simulateTestInfo;
- (NSArray *)getSimulateTestInfoWith:(NSString *)type;
- (NSDictionary *)getSimulateTestInfo;
- (NSDictionary *)getSimulateTestInfoWithid:(NSDictionary *)simulateTestInfo;

// 章节测试
- (NSDictionary *)getTestCourseInfo:(NSNumber *)courseId;
- (BOOL)isTestCourseSavedWithId:(NSNumber *)courseId;
- (BOOL)isTestChapterSavedWithId:(NSNumber *)chapterId;
- (BOOL)isTestSectionSavedWithId:(NSNumber *)sectionId;

// 模拟得分
- (BOOL)isSimulateScoreSavedWith:(NSNumber *)courseId;
- (NSDictionary *)getSimulateScoreWith:(NSNumber *)courseId;

// 我的错题
- (NSDictionary *)getMyWrongTestCourseInfo:(NSNumber *)courseId type:(NSString *)type;
- (BOOL)isMyWrongTestCourseSavedWithId:(NSNumber *)courseId;
- (BOOL)isMyWrongTestChapterSavedWithId:(NSDictionary *)infoDic;
- (BOOL)isMyWrongTestSectionSavedWithInfo:(NSDictionary *)infoDic;

// 搜索
- (NSArray *)getSearchHistoryWithType:(NSString *)type;
- (BOOL)isSearchContentSaved:(NSDictionary *)infoDIc;

@end
