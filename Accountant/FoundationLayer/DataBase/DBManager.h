//
//  DBManager.h
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownLoadModel.h"
#import "JSONKit.h"

@interface DBManager : NSObject

+ (instancetype)sharedManager;

- (void)intialDB;

- (void)saveDownLoadingInfo:(NSDictionary *)infoDic;

- (void)saveDownloadInfo:(NSDictionary *)infoDic;

- (void)saveLineVideoInfo:(NSDictionary *)infoDic;

- (BOOL)isVideoDownload:(NSDictionary *)videoInfo;

- (NSArray *)getDownloadedCourseInfo;

- (NSArray *)getDownloadingVideos;

- (NSDictionary *)getCourseInfosWithCourseId:(NSNumber *)courseId;

- (NSDictionary *)getLineVideoInfoWithVideoId:(NSNumber *)videoId;

- (BOOL)deleteVideos:(NSDictionary *)videoInfo;
- (void)deletedownLoadVideoWithId:(NSDictionary *)videoInfo;
- (BOOL)isExitDownloadingVideo:(NSDictionary *)videoInfo;

// 模拟题
- (void)saveSimulateTestInfo:(NSDictionary *)infoDic;
- (NSDictionary *)getSimulateTestWith:(NSDictionary *)simulateTestInfo;
- (void)deleteSimulateTestInfo:(NSDictionary *)simulateTestInfo;
- (NSArray *)getSimulateTestInfoWith:(NSString *)type;

// 章节测试
- (void)saveTestCourseInfo:(NSDictionary *)infoDic;
- (NSDictionary *)getTestCourseInfoWith:(NSNumber *)testCourseId;

// 模拟得分
- (void)saveSimulateScoreInfo:(NSDictionary *)infoDic;
- (NSDictionary *)getSimulateScoreWith:(NSNumber *)courseId;

// 我的错题本 && 易错题
- (void)saveMyWrongTestCourseInfo:(NSDictionary *)infoDic;
- (NSDictionary *)getMyWrongTestCourseInfoWith:(NSNumber *)testCourseId type:(NSString *)type;

// 搜索
- (void)saveSearchContent:(NSDictionary *)dic;
- (NSArray *)getSearchContentWithType:(NSString *)type;
- (BOOL)deleteSearchType:(NSString *)type;
- (BOOL)deleteEarliestSrarchContent:(NSString *)type;

@end
