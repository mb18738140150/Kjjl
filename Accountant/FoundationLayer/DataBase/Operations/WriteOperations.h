//
//  WriteOperations.h
//  Accountant
//
//  Created by aaa on 2017/3/9.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "DownLoadModel.h"
#import "JSONKit.h"
@interface WriteOperations : NSObject

@property (nonatomic,weak)  FMDatabase      *dataBase;

- (BOOL)writeVideoInfo:(NSDictionary *)dic;

- (BOOL)writeChapterInfo:(NSDictionary *)dic;

- (BOOL)writeCourseInfo:(NSDictionary *)dic;

- (BOOL)deleteVideoInfo:(NSDictionary *)dic;

- (BOOL)writeLineVideoInfo:(NSDictionary *)dic;

- (BOOL)deleteLineVideoInfo:(NSDictionary *)dic;

- (BOOL)writeDownloadVideoInfo:(NSDictionary *)infoDic;

- (BOOL)deleteDownloadVideoInfoWithId:(NSDictionary *)videoInfo;

// 模拟测试
- (BOOL)writeSimulateTestInfo:(NSDictionary *)dic;
- (BOOL)deleteSimulateTestInfo:(NSDictionary *)simulateTestInfo;

// 章节测试
- (BOOL)writeTestChapterInfo:(NSDictionary *)dic;
- (BOOL)writeTestCourseInfo:(NSDictionary *)dic;
- (BOOL)deleteTestSectionInfo:(NSDictionary *)dic;
- (BOOL)writeTestSectionInfo:(NSDictionary *)dic;

// 模拟得分
- (BOOL)deleteSimulateScoreWith:(NSNumber *)courseId;
- (BOOL)writeSimulateScoreWith:(NSDictionary *)infoDic;

// 我的错题
- (BOOL)writeMyWrongTestCourseInfo:(NSDictionary *)dic;
- (BOOL)writeMyWrongTestChapterInfo:(NSDictionary *)dic;
- (BOOL)writeMyWrongTestSectionInfo:(NSDictionary *)dic;
- (BOOL)deleteMyWrongTestSectionInfo:(NSDictionary *)dic;

// 搜索
- (BOOL)writeSearchContent:(NSDictionary *)dic;
- (BOOL)deleteSearchContent:(NSDictionary *)dic;
- (BOOL)deleteSearchType:(NSString *)type;
- (BOOL)deleteEarliestSearchContent:(NSDictionary *)dic;

@end
