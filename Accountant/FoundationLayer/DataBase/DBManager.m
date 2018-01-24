//
//  DBManager.m
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DBManager.h"
#import "PathUtility.h"
#import "FMDB.h"
#import "ReadOperations.h"
#import "WriteOperations.h"
#import "CommonMacro.h"

@interface DBManager ()

@property (nonatomic,strong) FMDatabase         *dataBase;

@property (nonatomic,strong) ReadOperations     *readOperation;
@property (nonatomic,strong) WriteOperations    *writeOperation;

@end

@implementation DBManager

+ (instancetype)sharedManager
{
    static DBManager *__manager__;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager__ = [[DBManager alloc] init];
    });
    return __manager__;
}

- (void)intialDB
{
    NSString *DBPath = [[PathUtility getDocumentPath] stringByAppendingPathComponent:@"1.db"];
    self.dataBase = [FMDatabase databaseWithPath:DBPath];
    if (![self.dataBase open]) {
        NSLog(@"数据库打开错误");
        return;
    }
    [self initalTables];
    self.readOperation = [[ReadOperations alloc] init];
    self.readOperation.dataBase = self.dataBase;
    self.writeOperation = [[WriteOperations alloc] init];
    self.writeOperation.dataBase = self.dataBase;
}

- (void)initalTables
{
    NSString *initalTablesSql = @"CREATE TABLE IF NOT EXISTS Course (id integer PRIMARY KEY autoincrement,courseName text(128) NOT NULL,courseId integer(32) NOT NULL,courseCoverImage text(128) NOT NULL,path text(32) NOT NULL,type integer(32) NOT NULL);"
    "CREATE TABLE IF NOT EXISTS Chapter (id integer PRIMARY KEY autoincrement,chapterId integer(32) NOT NULL,chapterName text(128) NOT NULL,chapterSort integer(32) NOT NULL,courseId integer(32) NOT NULL,isSingleVideo integer(1) NOT NULL,path text(32) NOT NULL,type integer(32) NOT NULL);"
    "CREATE TABLE IF NOT EXISTS Video (id integer PRIMARY KEY autoincrement,videoId integer(32) NOT NULL,videoName text(128) NOT NULL,videoSort integer(32) NOT NULL,chapterId integer(32) NOT NULL,path text(32) NOT NULL,time intrger(32) NOT NULL,type integer(32) NOT NULL);"
    "CREATE TABLE IF NOT EXISTS LineVideo (videoId integer(32) PRIMARY KEY NOT NULL,videoName text(128) NOT NULL,path text(32) NOT NULL,time intrger(32) NOT NULL);"
    "CREATE TABLE IF NOT EXISTS Downloading (id integer PRIMARY KEY autoincrement,videoId integer(32) NOT NULL,videoName text(128) NOT NULL,videoUrl text(32) NOT NULL,infoDic text(32) NOT NULL,type integer(32) NOT NULL);"
    "CREATE TABLE IF NOT EXISTS SimulateTest (id integer PRIMARY KEY autoincrement,simulateId integer(32) NOT NULL,simulateName text(128) NOT NULL,simulateQuestionCount intrger(32) NOT NULL,currentIndex intrger(32) NOT NULL,questionsStr text(128) NOT NULL,time double(32) NOT NULL,type text(128) NOT NULL);"
    "CREATE TABLE IF NOT EXISTS TestCourse (courseId integer(32) PRIMARY KEY NOT NULL,courseName text(128) NOT NULL);"
    "CREATE TABLE IF NOT EXISTS TestChapter (chapterId integer(32) PRIMARY KEY NOT NULL,chapterName text(128) NOT NULL,chapterQuestionCount intrger(32) NOT NULL,courseId intrger(32) NOT NULL);"
    "CREATE TABLE IF NOT EXISTS TestSection (sectionId integer(32) PRIMARY KEY NOT NULL,sectionName text(128) NOT NULL,sectionQuestionCount intrger(32) NOT NULL,currentIndex intrger(32) NOT NULL,questionsStr text(128) NOT NULL,time intrger(32) NOT NULL,chapterId intrger(32) NOT NULL);"
    "CREATE TABLE IF NOT EXISTS SimulateScore (courseId integer(32) PRIMARY KEY NOT NULL,courseName text(128) NOT NULL,totalCount integer(32) NOT NULL,rightCount integer(32) NOT NULL,wrongCount integer(32) NOT NULL);"
    "CREATE TABLE IF NOT EXISTS MyWrongTestCourse (courseId integer(32) PRIMARY KEY NOT NULL,courseName text(128) NOT NULL);"
    "CREATE TABLE IF NOT EXISTS MyWrongTestChapter (id integer PRIMARY KEY autoincrement,chapterId integer(32) NOT NULL,chapterName text(128) NOT NULL,chapterQuestionCount intrger(32) NOT NULL,courseId intrger(32) NOT NULL,type text(128) NOT NULL);"
    "CREATE TABLE IF NOT EXISTS MyWrongTestSection (id integer PRIMARY KEY autoincrement,sectionId integer(32) NOT NULL,sectionName text(128) NOT NULL,sectionQuestionCount intrger(32) NOT NULL,currentIndex intrger(32) NOT NULL,questionsStr text(128) NOT NULL,time intrger(32) NOT NULL,chapterId intrger(32) NOT NULL,type text(128) NOT NULL);"
    "CREATE TABLE IF NOT EXISTS SearchHistory (title text(128) NOT NULL,type text(128) NOT NULL,time double(32) NOT NULL);";
    BOOL isCreate = [self.dataBase executeStatements:initalTablesSql];
    if (!isCreate) {
        NSLog(@"***********创建表失败********");
    }
}

- (NSArray *)getDownloadedCourseInfo
{
    return [self.readOperation getDownloadCoursesInfos];
}

- (NSArray *)getDownloadingVideos
{
    return [self.readOperation getDownloadingVideos];
}

- (NSDictionary *)getCourseInfosWithCourseId:(NSNumber *)courseId
{
    return [self.readOperation getCourseInfosWithCourseId:courseId];
}

- (NSDictionary *)getLineVideoInfoWithVideoId:(NSNumber *)videoId
{
    return [self.readOperation getLineCourseInfoWithVideoId:videoId];
}

- (BOOL)deleteVideos:(NSDictionary *)videoInfo
{
    return [self.writeOperation deleteVideoInfo:videoInfo];
}
- (void)deletedownLoadVideoWithId:(NSDictionary *)videoInfo;
{
    [self.writeOperation deleteDownloadVideoInfoWithId:videoInfo];
}
#pragma mark - save

- (void)saveDownLoadingInfo:(NSDictionary *)infoDic
{
    if (![self.readOperation isDownLoadVideoSavesWithId:infoDic]) {
        if ([self.writeOperation writeDownloadVideoInfo:infoDic]) {
            
        }
    }else
    {
        if ([self.writeOperation deleteDownloadVideoInfoWithId:infoDic]) {
            if ([self.writeOperation writeDownloadVideoInfo:infoDic]) {
                
            }
        }
    }
}

- (void)saveDownloadInfo:(NSDictionary *)infoDic
{
/*    int courseId = [[infoDic objectForKey:kCourseID] intValue];
    NSString *courseName = [infoDic objectForKey:kCourseName];
    NSString *coursePath = [infoDic objectForKey:kCoursePath];
    
    int chapterId = [[infoDic objectForKey:kChapterId] intValue];
    NSString *chapterName = [infoDic objectForKey:kChapterName];
    int chapterSort = [[infoDic objectForKey:kChapterSort] intValue];
    NSString *chapterPath = [infoDic objectForKey:kChapterPath];
    
    int videoId = [[infoDic objectForKey:kVideoId] intValue];
    NSString *videoName = [infoDic objectForKey:kVideoName];
    int videoSort = [[infoDic objectForKey:kVideoSort] intValue];
    NSString *videoPath = [infoDic objectForKey:kVideoPath];*/
    
    if (![self.readOperation isCourseSavedWithId:infoDic]) {
        [self.writeOperation writeCourseInfo:infoDic];
    }
    if (![self.readOperation isChapterSavedWithId:infoDic]) {
        [self.writeOperation writeChapterInfo:infoDic];
    }
    if (![self.readOperation isVideoSavedWithId:infoDic]) {
        [self.writeOperation writeVideoInfo:infoDic];
    }else
    {
        if ([self.writeOperation deleteVideoInfo:infoDic]) {
            [self.writeOperation writeVideoInfo:infoDic];
        }
    }
}

- (void)saveLineVideoInfo:(NSDictionary *)infoDic
{
    if (![self.readOperation isLineVideoSavedWithId:[infoDic objectForKey:kVideoId]]) {
        [self.writeOperation writeLineVideoInfo:infoDic];
    }else
    {
        if ([self.writeOperation deleteLineVideoInfo:infoDic]) {
            [self.writeOperation writeLineVideoInfo:infoDic];
        }
    }
}

- (BOOL)isVideoDownload:(NSDictionary *)videoInfo
{
    return [self.readOperation isVideoSavedWithId:videoInfo];
}
- (BOOL)isExitDownloadingVideo:(NSDictionary *)videoInfo
{
    return [self.readOperation isDownLoadVideoSavesWithId:videoInfo];
}

- (void)saveSimulateTestInfo:(NSDictionary *)infoDic
{
    if ([self.readOperation isSimulateTestSavedWithId:infoDic]) {
        if ([self.writeOperation deleteSimulateTestInfo:infoDic])
        {
            [self.writeOperation writeSimulateTestInfo:infoDic];
        }
    }else
    {
        [self.writeOperation writeSimulateTestInfo:infoDic];
    }
}

- (NSDictionary *)getSimulateTestWith:(NSDictionary *)simulateTestInfo
{
    NSDictionary * dic = [self.readOperation getSimulateTestInfoWithid:simulateTestInfo];
    return dic;
}

- (void)deleteSimulateTestInfo:(NSDictionary *)simulateTestInfo
{
    [self.writeOperation deleteSimulateTestInfo:simulateTestInfo];
}

- (NSArray *)getSimulateTestInfoWith:(NSString *)type
{
    return [self.readOperation getSimulateTestInfoWith:type];
}

// 章节测试
- (void)saveTestCourseInfo:(NSDictionary *)infoDic{
    
    NSLog(@"%@", infoDic);
    
    if (![self.readOperation isTestCourseSavedWithId:[infoDic objectForKey:kCourseID]]) {
        [self.writeOperation writeTestCourseInfo:infoDic];
    }
    if (![self.readOperation isTestChapterSavedWithId:[infoDic objectForKey:kTestChapterId]]) {
        [self.writeOperation writeTestChapterInfo:infoDic];
    }
    if (![self.readOperation isTestSectionSavedWithId:[infoDic objectForKey:kTestSectionId]]) {
        [self.writeOperation writeTestSectionInfo:infoDic];
    }else
    {
        if ([self.writeOperation deleteTestSectionInfo:infoDic]) {
            [self.writeOperation writeTestSectionInfo:infoDic];
        }
    }
}
- (NSDictionary *)getTestCourseInfoWith:(NSNumber *)testCourseId
{
    NSDictionary * dic = [self.readOperation getTestCourseInfo:testCourseId];
    return dic;
}

// 模拟得分
- (void)saveSimulateScoreInfo:(NSDictionary *)infoDic
{
    if ([self.readOperation isSimulateScoreSavedWith:[infoDic objectForKey:kCourseID]]) {
        [self.writeOperation deleteSimulateScoreWith:[infoDic objectForKey:kCourseID]];
        [self.writeOperation writeSimulateScoreWith:infoDic];
    }else
    {
        [self.writeOperation writeSimulateScoreWith:infoDic];
    }
}
- (NSDictionary *)getSimulateScoreWith:(NSNumber *)courseId
{
    NSDictionary * infoDic = [self.readOperation getSimulateScoreWith:courseId];
    return infoDic;
}

// 我的错题本
- (void)saveMyWrongTestCourseInfo:(NSDictionary *)infoDic
{
    if (![self.readOperation isMyWrongTestCourseSavedWithId:[infoDic objectForKey:kCourseID]]) {
        [self.writeOperation writeMyWrongTestCourseInfo:infoDic];
    }
    if (![self.readOperation isMyWrongTestChapterSavedWithId:infoDic]) {
        [self.writeOperation writeMyWrongTestChapterInfo:infoDic];
    }
    if (![self.readOperation isMyWrongTestSectionSavedWithInfo:infoDic]) {
        [self.writeOperation writeMyWrongTestSectionInfo:infoDic];
    }else
    {
        if ([self.writeOperation deleteMyWrongTestSectionInfo:infoDic]) {
            [self.writeOperation writeMyWrongTestSectionInfo:infoDic];
        }
    }
    
}
- (NSDictionary *)getMyWrongTestCourseInfoWith:(NSNumber *)testCourseId  type:(NSString *)type{
    NSDictionary * infoDic = [self.readOperation getMyWrongTestCourseInfo:testCourseId  type:type];
    return infoDic;
}

// 搜索
- (void)saveSearchContent:(NSDictionary *)dic
{
    if ([self.readOperation isSearchContentSaved:dic]) {
        [self.writeOperation deleteSearchContent:dic];
        [self.writeOperation writeSearchContent:dic];
    }else
    {
        [self.writeOperation writeSearchContent:dic];
    }
}
- (NSArray *)getSearchContentWithType:(NSString *)type
{
    return [self.readOperation getSearchHistoryWithType:type];
}

- (BOOL)deleteSearchType:(NSString *)type
{
    return  [self.writeOperation deleteSearchType:type];
}

- (BOOL)deleteEarliestSrarchContent:(NSString *)type
{
    NSArray * array = [self.readOperation getSearchHistoryWithType:type];
    double time = MAXFLOAT;
    NSDictionary * earliestDic = [NSDictionary dictionary];
    for (int i = 0; i < array.count; i++) {
        NSDictionary * dic = [array objectAtIndex:i];
        double time1 = [[dic objectForKey:@"time"] doubleValue];
        if (time > time1) {
            time = time1;
            earliestDic = dic;
        }
    }
    return [self.writeOperation deleteEarliestSearchContent:earliestDic];
}

@end
