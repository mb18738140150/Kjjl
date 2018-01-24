//
//  ReadOperations.m
//  Accountant
//
//  Created by aaa on 2017/3/9.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "ReadOperations.h"
#import "CommonMacro.h"

@implementation ReadOperations

- (BOOL)isCourseSavedWithId:(NSDictionary *)courseInfo
{
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM Course WHERE courseId = ? and type = ?",[courseInfo objectForKey:kCourseID],[courseInfo objectForKey:@"type"]];
    while ([s next]) {
        return YES;
    }
    return NO;
}

- (BOOL)isChapterSavedWithId:(NSDictionary *)chapterInfo
{
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM Chapter WHERE chapterId = ? and type = ?",[chapterInfo objectForKey:kChapterId],[chapterInfo objectForKey:@"type"]];
    while ([s next]) {
        return YES;
    }
    return NO;
}

- (BOOL)isDownLoadVideoSavesWithId:(NSDictionary *)videoInfo
{
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM Downloading WHERE videoId = ? and type = ?",[videoInfo objectForKey:kVideoId],[videoInfo objectForKey:@"type"]];
    while ([s next]) {
        return YES;
    }
    return NO;
}

- (BOOL)isVideoSavedWithId:(NSDictionary *)videoInfo
{
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM Video WHERE videoId = ? and type = ?",[videoInfo objectForKey:kVideoId],[videoInfo objectForKey:@"type"]];
    while ([s next]) {
        return YES;
    }
    return NO;
}

- (BOOL)isLineVideoSavedWithId:(NSNumber *)videoId
{
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM LineVideo WHERE videoId = ?", videoId];
    while ([s next]) {
        return YES;
    }
    return NO;
}

- (BOOL)isExitDownloadingVideo:(NSDictionary *)videoInfo
{
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM Downloading WHERE videoId = ? and type = ?",[videoInfo objectForKey:kVideoId],[videoInfo objectForKey:@"type"]];
    while ([s next]) {
        return YES;
    }
    return NO;
}

- (NSDictionary *)getCourseInfosWithCourseId:(NSNumber *)courseId
{
    NSMutableDictionary *courseInfo = [[NSMutableDictionary alloc] init];
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM Course WHERE courseId = ?",courseId];
    while ([s next]) {
        [courseInfo setObject:[s stringForColumn:@"courseName"] forKey:kCourseName];
        [courseInfo setObject:@([s intForColumn:@"courseId"]) forKey:kCourseID];
        [courseInfo setObject:@([s intForColumn:@"type"]) forKey:@"type"];
        NSArray *chapters = [self getChapterInfosWithCourseId:@([s intForColumn:@"courseId"]) andType:@([s intForColumn:@"type"])];
        
        [courseInfo setObject:chapters forKey:kCourseChapterInfos];
        
        [courseInfo setObject:[s stringForColumn:@"courseCoverImage"] forKey:kCourseCover];
        [courseInfo setObject:[s stringForColumn:@"path"] forKey:kCoursePath];
    }
    return courseInfo;
}

- (NSDictionary *)getLineCourseInfoWithVideoId:(NSNumber *)videoId
{
    NSMutableDictionary *videoInfo = [[NSMutableDictionary alloc] init];
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM LineVideo WHERE videoId = ?",videoId];
    while ([s next]) {
        [videoInfo setValue:@([s intForColumn:@"videoId"]) forKey:kVideoId];
        [videoInfo setValue:[s stringForColumn:@"path"] forKey:kVideoURL];
        [videoInfo setValue:[s stringForColumn:@"videoName"] forKey:kVideoName];
        [videoInfo setValue:@([s intForColumn:@"time"]) forKey:kVideoPlayTime];
    }
    return videoInfo;
}

- (NSArray *)getDownloadingVideos
{
    NSMutableArray *arry = [[NSMutableArray alloc] init];
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM Downloading"];
    while ([s next]) {
        DownLoadModel * model = [[DownLoadModel alloc]init];
        model.filePath = [s stringForColumn:@"path"];
        model.fileSize = [s stringForColumn:@"fileSize"];
        model.cueerntFileSize = [s stringForColumn:@"currentFileSize"];
        
        NSString * jsonStr = [s stringForColumn:@"infoDic"];
        
        NSData * jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary * infoDic = [jsonData objectFromJSONData];
        
        [arry addObject:infoDic];
    }
    
    return arry;
}


- (NSArray *)getDownloadCoursesInfos
{
    NSMutableArray *arry = [[NSMutableArray alloc] init];
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM Course"];
    while ([s next]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[s stringForColumn:@"courseName"] forKey:kCourseName];
        [dic setObject:@([s intForColumn:@"courseId"]) forKey:kCourseID];
        [dic setObject:@([s intForColumn:@"type"]) forKey:@"type"];
        NSArray *chapters = [self getChapterInfosWithCourseId:@([s intForColumn:@"courseId"]) andType:@([s intForColumn:@"type"])];
        
        [dic setObject:chapters forKey:kCourseChapterInfos];
        
        [dic setObject:[s stringForColumn:@"courseCoverImage"] forKey:kCourseCover];
        [dic setObject:[s stringForColumn:@"path"] forKey:kCoursePath];
        [arry addObject:dic];
    }
    return arry;
}

- (NSArray *)getChapterInfosWithCourseId:(NSNumber *)courseId andType:(NSNumber *)type
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM Chapter WHERE courseId = ? and type = ? ORDER BY chapterSort",courseId,type];
    while ([s next]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:@([s intForColumn:@"chapterId"]) forKey:kChapterId];
        [dic setObject:[s stringForColumn:@"chapterName"] forKey:kChapterName];
        [dic setObject:@([s intForColumn:@"chapterSort"]) forKey:kChapterSort];
        [dic setObject:@([s intForColumn:@"isSingleVideo"]) forKey:kIsSingleChapter];
        [dic setObject:[s stringForColumn:@"path"] forKey:kChapterPath];
        [dic setObject:@([s intForColumn:@"type"]) forKey:@"type"];
        NSArray *videos = [self getVideoInfosWithChapterId:@([s intForColumn:@"chapterId"]) andType:@([s intForColumn:@"type"])];
        [dic setObject:videos forKey:kChapterVideoInfos];
//        if ([s intForColumn:@"isSingleVideo"] != 1) {
//        }else{
//            NSArray *videos = @[@{kVideoId:@([s intForColumn:@"chapterId"]),
//                                  kVideoName:[s stringForColumn:@"chapterName"],
//                                  kVideoSort:@(1)}];
//            [dic setObject:videos forKey:kChapterVideoInfos];
//        }
        [array addObject:dic];
        
    }
    
    return array;
}

- (NSArray *)getVideoInfosWithChapterId:(NSNumber *)chapterId andType:(NSNumber *)type
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM Video WHERE chapterId = ? and type = ? ORDER BY videoSort",chapterId,type];
    while ([s next]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:@([s intForColumn:@"videoId"]) forKey:kVideoId];
        [dic setObject:[s stringForColumn:@"videoName"] forKey:kVideoName];
        [dic setObject:@([s intForColumn:@"videoSort"]) forKey:kVideoSort];
        [dic setObject:[s stringForColumn:@"path"] forKey:kVideoPath];
        [dic setObject:@([s intForColumn:@"time"]) forKey:kVideoPlayTime];
        [dic setObject:@([s intForColumn:@"type"]) forKey:@"type"];
        [array addObject:dic];
    }
    return array;
}

#pragma mark : 模拟测试
- (BOOL)isSimulateTestSavedWithId:(NSDictionary *)simulateTestInfo
{
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM SimulateTest WHERE simulateId = ? and type = ?",[simulateTestInfo objectForKey:kTestSimulateId],[simulateTestInfo objectForKey:@"type"]];
    while ([s next]) {
        return YES;
    }
    return NO;
}

- (NSDictionary *)getSimulateTestInfoWithid:(NSDictionary *)simulateTestInfo
{
    NSMutableDictionary * infoDic = [NSMutableDictionary dictionary];
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM SimulateTest WHERE simulateId = ? and type = ?",[simulateTestInfo objectForKey:kTestSimulateId],[simulateTestInfo objectForKey:@"type"]];
    while ([s next]) {
        [infoDic setObject:@([s intForColumn:@"simulateId"]) forKey:kTestSimulateId];
        [infoDic setObject:[s stringForColumn:@"simulateName"] forKey:kTestSimulateName];
        [infoDic setObject:@([s intForColumn:@"simulateQuestionCount"]) forKey:kTestSimulateQuestionCount];
        [infoDic setObject:@([s intForColumn:@"currentIndex"]) forKey:@"currentIndex"];
        [infoDic setObject:@([s doubleForColumn:@"time"]) forKey:@"time"];
        
        NSString * str = [s stringForColumn:@"questionsStr"];
        NSData * date = [str dataUsingEncoding:NSUTF8StringEncoding];
        id arrayDate = [NSJSONSerialization JSONObjectWithData:date options:NSJSONReadingAllowFragments error:nil];
        [infoDic setObject:(NSArray *)arrayDate forKey:@"questionsStr"];
        
    }
    
    return infoDic;
}

- (NSArray *)getSimulateTestInfoWith:(NSString *)type
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:1];
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM SimulateTest WHERE type = ?",type];
    while ([s next]) {
        NSMutableDictionary * infoDic = [NSMutableDictionary dictionary];
        [infoDic setObject:@([s intForColumn:@"simulateId"]) forKey:kTestSimulateId];
        [infoDic setObject:[s stringForColumn:@"simulateName"] forKey:kTestSimulateName];
        [infoDic setObject:@([s intForColumn:@"simulateQuestionCount"]) forKey:kTestSimulateQuestionCount];
        [infoDic setObject:@([s intForColumn:@"currentIndex"]) forKey:@"currentIndex"];
        [infoDic setObject:@([s intForColumn:@"time"]) forKey:@"time"];
        
        NSString * str = [s stringForColumn:@"questionsStr"];
        NSData * date = [str dataUsingEncoding:NSUTF8StringEncoding];
        id arrayDate = [NSJSONSerialization JSONObjectWithData:date options:NSJSONReadingAllowFragments error:nil];
        [infoDic setObject:(NSArray *)arrayDate forKey:@"questionsStr"];
        [array addObject:infoDic];
    }
    
    return array;
}

- (NSDictionary *)getSimulateTestInfo
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:1];
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM SimulateTest"];
    while ([s next]) {
        NSMutableDictionary * infoDic = [NSMutableDictionary dictionary];
        [infoDic setObject:@([s intForColumn:@"simulateId"]) forKey:kTestSimulateId];
        [infoDic setObject:[s stringForColumn:@"simulateName"] forKey:kTestSimulateName];
        [infoDic setObject:@([s intForColumn:@"simulateQuestionCount"]) forKey:kTestSimulateQuestionCount];
        [infoDic setObject:@([s intForColumn:@"currentIndex"]) forKey:@"currentIndex"];
        [infoDic setObject:@([s intForColumn:@"time"]) forKey:@"time"];
        
        NSString * str = [s stringForColumn:@"questionsStr"];
        NSData * date = [str dataUsingEncoding:NSUTF8StringEncoding];
        id arrayDate = [NSJSONSerialization JSONObjectWithData:date options:NSJSONReadingAllowFragments error:nil];
        [infoDic setObject:(NSArray *)arrayDate forKey:@"questionsStr"];
        [array addObject:infoDic];
    }
    int time = 0;
    
    for (int i = 0; i < array.count ; i++) {
        NSMutableDictionary * dic = [array objectAtIndex:i];
        if ([[dic objectForKey:@"time"] intValue] >= time) {
            time = [[dic objectForKey:@"time"] intValue];
        }
    }
    
    NSMutableDictionary * resultDic = [NSMutableDictionary dictionary];
    for (NSMutableDictionary * dic in array) {
        if (time == [[dic objectForKey:@"time"] intValue]) {
            resultDic = dic;
            break;
        }
    }
    
    return resultDic;
}

#pragma mark : 章节测试
- (NSDictionary *)getTestCourseInfo:(NSNumber *)courseId
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM TestCourse WHERE courseId = ?",courseId];
    while ([s next]) {
        
        [dic setObject:[s stringForColumn:@"courseName"] forKey:kCourseName];
        [dic setObject:@([s intForColumn:@"courseId"]) forKey:kCourseID];
        
        NSArray *chapters = [self getTestChapterInfosWithCourseId:@([s intForColumn:@"courseId"])];
        [dic setObject:chapters forKey:kCourseChapterInfos];
        
    }
    return dic;
}

- (NSArray *)getTestChapterInfosWithCourseId:(NSNumber *)courseId
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM TestChapter WHERE courseId = ? ",courseId];
    while ([s next]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:@([s intForColumn:@"chapterId"]) forKey:kTestChapterId];
        [dic setObject:[s stringForColumn:@"chapterName"] forKey:kTestChapterName];
        [dic setObject:@([s intForColumn:@"chapterQuestionCount"]) forKey:kTestChapterQuestionCount];
        
        NSArray *sectionArray = [self getTestSectionInfosWithChapterId:@([s intForColumn:@"chapterId"])];
        [dic setObject:sectionArray forKey:kTestChapterSectionArray];
        
        [array addObject:dic];
    }
    
    return array;
}

- (NSArray *)getTestSectionInfosWithChapterId:(NSNumber *)chapterId
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM TestSection WHERE chapterId = ? ",chapterId];
    while ([s next]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:@([s intForColumn:@"sectionId"]) forKey:kTestSectionId];
        [dic setObject:[s stringForColumn:@"sectionName"] forKey:kTestSectionName];
        [dic setObject:@([s intForColumn:@"sectionQuestionCount"]) forKey:kTestSectionQuestionCount];
        [dic setObject:@([s intForColumn:@"currentIndex"]) forKey:@"currentIndex"];
        [dic setObject:@([s intForColumn:@"time"]) forKey:@"time"];
        
        NSString * str = [s stringForColumn:@"questionsStr"];
        NSData * date = [str dataUsingEncoding:NSUTF8StringEncoding];
        id arrayDate = [NSJSONSerialization JSONObjectWithData:date options:NSJSONReadingAllowFragments error:nil];
        [dic setObject:(NSArray *)arrayDate forKey:@"questionsStr"];
        
        [array addObject:dic];
    }
    return array;
}
- (BOOL)isTestCourseSavedWithId:(NSNumber *)courseId
{
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM TestCourse WHERE courseId = ?",courseId];
    while ([s next]) {
        return YES;
    }
    return NO;
}
- (BOOL)isTestChapterSavedWithId:(NSNumber *)chapterId
{
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM TestChapter WHERE chapterId = ?",chapterId];
    while ([s next]) {
        return YES;
    }
    return NO;
}
- (BOOL)isTestSectionSavedWithId:(NSNumber *)sectionId
{
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM TestSection WHERE sectionId = ?",sectionId];
    while ([s next]) {
        return YES;
    }
    return NO;
}
#pragma mark 模拟得分
- (BOOL)isSimulateScoreSavedWith:(NSNumber *)courseId
{
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM SimulateScore WHERE courseId = ?",courseId];
    while ([s next]) {
        return YES;
    }
    return NO;
}
- (NSDictionary *)getSimulateScoreWith:(NSNumber *)courseId
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM SimulateScore WHERE courseId = ?",courseId];
    while ([s next]) {
        
        [dic setObject:[s stringForColumn:@"courseName"] forKey:kCourseName];
        [dic setObject:@([s intForColumn:@"courseId"]) forKey:kCourseID];
        [dic setObject:@([s intForColumn:@"totalCount"]) forKey:@"totalCount"];
        [dic setObject:@([s intForColumn:@"rightCount"]) forKey:@"rightCount"];
        [dic setObject:@([s intForColumn:@"wrongCount"]) forKey:@"wrongCount"];
    }
    return dic;
    return nil;
}


#pragma mark 我的错题
- (NSDictionary *)getMyWrongTestCourseInfo:(NSNumber *)courseId type:(NSString *)type
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM MyWrongTestCourse WHERE courseId = ?",courseId];
    while ([s next]) {
        
        [dic setObject:[s stringForColumn:@"courseName"] forKey:kCourseName];
        [dic setObject:@([s intForColumn:@"courseId"]) forKey:kCourseID];
        
        NSArray *chapters = [self getMyWrongTestChapterInfosWithCourseId:@([s intForColumn:@"courseId"]) type:type];
        [dic setObject:chapters forKey:kCourseChapterInfos];
        
    }
    return dic;
    
}

- (NSArray *)getMyWrongTestChapterInfosWithCourseId:(NSNumber *)courseId  type:(NSString *)type
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM MyWrongTestChapter WHERE courseId = ?  and type = ?",courseId, type];
    while ([s next]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:@([s intForColumn:@"chapterId"]) forKey:kTestChapterId];
        [dic setObject:[s stringForColumn:@"chapterName"] forKey:kTestChapterName];
        [dic setObject:@([s intForColumn:@"chapterQuestionCount"]) forKey:kTestChapterQuestionCount];
        
        NSArray *sectionArray = [self getMyWrongTestSectionInfosWithChapterId:@([s intForColumn:@"chapterId"]) type:type];
        [dic setObject:sectionArray forKey:kTestChapterSectionArray];
        
        
        [array addObject:dic];
    }
    return array;
}

- (NSArray *)getMyWrongTestSectionInfosWithChapterId:(NSNumber *)chapterId  type:(NSString *)type
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM MyWrongTestSection WHERE chapterId = ?  and type = ?",chapterId, type];
    while ([s next]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:@([s intForColumn:@"sectionId"]) forKey:kTestSectionId];
        [dic setObject:[s stringForColumn:@"sectionName"] forKey:kTestSectionName];
        [dic setObject:@([s intForColumn:@"sectionQuestionCount"]) forKey:kTestSectionQuestionCount];
        [dic setObject:@([s intForColumn:@"currentIndex"]) forKey:@"currentIndex"];
        [dic setObject:@([s intForColumn:@"time"]) forKey:@"time"];
        
        NSString * str = [s stringForColumn:@"questionsStr"];
        NSData * date = [str dataUsingEncoding:NSUTF8StringEncoding];
        id arrayDate = [NSJSONSerialization JSONObjectWithData:date options:NSJSONReadingAllowFragments error:nil];
        [dic setObject:(NSArray *)arrayDate forKey:@"questionsStr"];
        
        [array addObject:dic];
    }
    return array;
}


- (BOOL)isMyWrongTestCourseSavedWithId:(NSNumber *)courseId
{
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM MyWrongTestCourse WHERE courseId = ?",courseId];
    while ([s next]) {
        return YES;
    }
    return NO;
}
- (BOOL)isMyWrongTestChapterSavedWithId:(NSDictionary *)infoDic
{
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM MyWrongTestChapter WHERE chapterId = ? and type = ?",[infoDic objectForKey:kTestChapterId],[infoDic objectForKey:@"type"]];
    while ([s next]) {
        return YES;
    }
    return NO;
}

- (BOOL)isMyWrongTestSectionSavedWithInfo:(NSDictionary *)infoDic;
{
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM MyWrongTestSection WHERE sectionId = ? and type = ?",[infoDic objectForKey:kTestSectionId], [infoDic objectForKey:@"type"]];
    while ([s next]) {
        return YES;
    }
    return NO;
}


// 搜索
- (NSArray *)getSearchHistoryWithType:(NSString *)type
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    FMResultSet *s = [self.dataBase executeQuery:@"SELECT * FROM SearchHistory WHERE type = ?", type];
    while ([s next]) {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        [dic setObject:[s stringForColumn:@"title"] forKey:@"title"];
        [dic setObject:[s stringForColumn:@"type"] forKey:@"type"];
        [dic setObject:@([s doubleForColumn:@"time"]) forKey:@"time"];
        [array addObject:dic];
    }
    return array;
}
- (BOOL)isSearchContentSaved:(NSDictionary *)infoDIc
{
    FMResultSet * s = [self.dataBase executeQuery:@"SELECT * FROM SearchHistory WHERE title = ? and type = ?", [infoDIc objectForKey:@"title"], [infoDIc objectForKey:@"type"]];
    while ([s next]) {
        return YES;
    }
    return NO;
}

@end
