//
//  WriteOperations.m
//  Accountant
//
//  Created by aaa on 2017/3/9.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "WriteOperations.h"
#import "CommonMacro.h"

@implementation WriteOperations

- (BOOL)writeDownloadVideoInfo:(NSDictionary *)infoDic
{
    NSDictionary * dic = infoDic;
    BOOL isSuccess = [self.dataBase executeUpdate:@"insert into Downloading (videoId,videoName,videoUrl,infoDic) values (?,?,?,?)",[dic objectForKey:kVideoId],[dic objectForKey:kVideoName],[dic objectForKey:kVideoURL],[infoDic JSONString]];
    
    return isSuccess;
}

- (BOOL)deleteDownloadVideoInfoWithId:(NSNumber *)videoId
{
    BOOL isSuccess = NO;
    isSuccess = [self.dataBase executeUpdate:@"DELETE FROM Downloading where videoId = ?",videoId];
    return isSuccess;
}

- (BOOL)writeVideoInfo:(NSDictionary *)dic
{
    BOOL isSuccess = [self.dataBase executeUpdate:@"insert into Video (videoId,videoName,videoSort,chapterId,path,time) values (?,?,?,?,?,?)",[dic objectForKey:kVideoId],[dic objectForKey:kVideoName],[dic objectForKey:kVideoSort],[dic objectForKey:kChapterId],[dic objectForKey:kVideoPath],[dic objectForKey:kVideoPlayTime]];
    
    return isSuccess;
}

- (BOOL)writeChapterInfo:(NSDictionary *)dic
{
    BOOL isSuccess = [self.dataBase executeUpdate:@"insert into Chapter (chapterId,chapterName,chapterSort,isSingleVideo,courseId,path) values (?,?,?,?,?,?)",[dic objectForKey:kChapterId],[dic objectForKey:kChapterName],[dic objectForKey:kChapterSort],[dic objectForKey:kIsSingleChapter],[dic objectForKey:kCourseID],[dic objectForKey:kChapterPath]];
    
    return isSuccess;
}

- (BOOL)writeCourseInfo:(NSDictionary *)dic
{
    BOOL isSuccess = [self.dataBase executeUpdate:@"INSERT INTO Course (courseId,courseName,courseCoverImage,path) VALUES (?,?,?,?)",[dic objectForKey:kCourseID],[dic objectForKey:kCourseName],[dic objectForKey:kCourseCover],[dic objectForKey:kCoursePath]];
    
    return isSuccess;
}

- (BOOL)writeLineVideoInfo:(NSDictionary *)dic
{
    BOOL isSuccess = [self.dataBase executeUpdate:@"insert into LineVideo (videoId,videoName,path,time) values (?,?,?,?)", [dic objectForKey:kVideoId],[dic objectForKey:kVideoName],[dic objectForKey:kVideoURL],[dic objectForKey:kVideoPlayTime]];
    return isSuccess;
}

- (BOOL)deleteVideoInfo:(NSDictionary *)dic
{
    BOOL isSuccess = NO;
/*    if ([dic objectForKey:kIsSingleChapter]) {
        isSuccess = [self.dataBase executeUpdate:@"DELETE FROM Chapter where chapterId = ?",[dic objectForKey:kVideoId]];
    }else{
        isSuccess = [self.dataBase executeUpdate:@"DELETE FROM Video where videoId = ?",[dic objectForKey:kVideoId]];
    }*/
    isSuccess = [self.dataBase executeUpdate:@"DELETE FROM Video where videoId = ?",[dic objectForKey:kVideoId]];
    return isSuccess;
}

- (BOOL)deleteLineVideoInfo:(NSDictionary *)dic
{
    BOOL isSuccess = NO;
    /*    if ([dic objectForKey:kIsSingleChapter]) {
     isSuccess = [self.dataBase executeUpdate:@"DELETE FROM Chapter where chapterId = ?",[dic objectForKey:kVideoId]];
     }else{
     isSuccess = [self.dataBase executeUpdate:@"DELETE FROM Video where videoId = ?",[dic objectForKey:kVideoId]];
     }*/
    isSuccess = [self.dataBase executeUpdate:@"DELETE FROM LineVideo where videoId = ?",[dic objectForKey:kVideoId]];
    return isSuccess;
}
// 模拟测试
- (BOOL)writeSimulateTestInfo:(NSDictionary *)dic
{
    BOOL isSuccess = [self.dataBase executeUpdate:@"insert into SimulateTest (simulateId,simulateName,simulateQuestionCount,currentIndex,questionsStr,time) values (?,?,?,?,?,?)", [dic objectForKey:kTestSimulateId],[dic objectForKey:kTestSimulateName],[dic objectForKey:kTestSimulateQuestionCount],[dic objectForKey:@"currentIndex"],[dic objectForKey:@"questionsStr"],[dic objectForKey:@"time"]];
    return isSuccess;
}
- (BOOL)deleteSimulateTestInfo:(NSNumber *)simulateTestId
{
    BOOL isSuccess = NO;
    isSuccess = [self.dataBase executeUpdate:@"DELETE FROM SimulateTest where simulateId = ?",simulateTestId];
    return isSuccess;
}

// 章节测试
- (BOOL)writeTestCourseInfo:(NSDictionary *)dic
{
    BOOL isSuccess = [self.dataBase executeUpdate:@"INSERT INTO TestCourse (courseId,courseName) VALUES (?,?)",[dic objectForKey:kCourseID],[dic objectForKey:kCourseName]];
    
    return isSuccess;
}

- (BOOL)writeTestChapterInfo:(NSDictionary *)dic
{
    BOOL isSuccess = [self.dataBase executeUpdate:@"insert into TestChapter (chapterId,chapterName,chapterQuestionCount,courseId) values (?,?,?,?)",[dic objectForKey:kTestChapterId],[dic objectForKey:kTestChapterName],[dic objectForKey:kTestChapterQuestionCount],[dic objectForKey:kCourseID]];
    
    return isSuccess;
}
- (BOOL)writeTestSectionInfo:(NSDictionary *)dic
{
    BOOL isSuccess = [self.dataBase executeUpdate:@"insert into TestSection (sectionId,sectionName,sectionQuestionCount,currentIndex,questionsStr,time,chapterId) values (?,?,?,?,?,?,?)", [dic objectForKey:kTestSectionId],[dic objectForKey:kTestSectionName],[dic objectForKey:kTestSectionQuestionCount],[dic objectForKey:@"currentIndex"],[dic objectForKey:@"questionsStr"],[dic objectForKey:@"time"],[dic objectForKey:kTestChapterId]];
    return isSuccess;
}
- (BOOL)deleteTestSectionInfo:(NSDictionary *)dic
{
    BOOL isSuccess = NO;
    isSuccess = [self.dataBase executeUpdate:@"DELETE FROM TestSection where sectionId = ?",[dic objectForKey:kTestSectionId]];
    return isSuccess;
}
// 模拟得分
- (BOOL)deleteSimulateScoreWith:(NSNumber *)courseId
{
    BOOL isSuccess = NO;
    isSuccess = [self.dataBase executeUpdate:@"DELETE FROM SimulateScore where courseId = ?",courseId];
    return isSuccess;
}
- (BOOL)writeSimulateScoreWith:(NSDictionary *)infoDic
{
    BOOL isSuccess = [self.dataBase executeUpdate:@"insert into SimulateScore (courseId,courseName,totalCount,rightCount,wrongCount) values (?,?,?,?,?)",[infoDic objectForKey:kCourseID],[infoDic objectForKey:kCourseName],[infoDic objectForKey:@"totalCount"],[infoDic objectForKey:@"rightCount"],[infoDic objectForKey:@"wrongCount"]];
    return isSuccess;
}

// 我的错题
- (BOOL)writeMyWrongTestCourseInfo:(NSDictionary *)dic
{
    BOOL isSuccess = [self.dataBase executeUpdate:@"INSERT INTO MyWrongTestCourse (courseId,courseName) VALUES (?,?)",[dic objectForKey:kCourseID],[dic objectForKey:kCourseName]];
    
    return isSuccess;
}
- (BOOL)writeMyWrongTestChapterInfo:(NSDictionary *)dic
{
    BOOL isSuccess = [self.dataBase executeUpdate:@"insert into MyWrongTestChapter (chapterId,chapterName,chapterQuestionCount,currentIndex,questionsStr,time,courseId,type) values (?,?,?,?,?,?,?,?)", [dic objectForKey:kTestChapterId],[dic objectForKey:kTestChapterName],[dic objectForKey:kTestChapterQuestionCount],[dic objectForKey:@"currentIndex"],[dic objectForKey:@"questionsStr"],[dic objectForKey:@"time"],[dic objectForKey:kCourseID], [dic objectForKey:@"type"]];
    return isSuccess;
}
- (BOOL)deleteMyWrongTestChapterInfo:(NSDictionary *)dic
{
    BOOL isSuccess = NO;
    isSuccess = [self.dataBase executeUpdate:@"DELETE FROM MyWrongTestChapter where chapterId = ? and type = ?",[dic objectForKey:kTestChapterId], [dic objectForKey:@"type"]];
    return isSuccess;
}

// 搜索
- (BOOL)writeSearchContent:(NSDictionary *)dic
{
    BOOL isSuccess = [self.dataBase executeUpdate:@"insert into SearchHistory (title,type,time) values (?,?,?)",  [dic objectForKey:@"title"], [dic objectForKey:@"type"],[dic objectForKey:@"time"]];
    return isSuccess;
}
- (BOOL)deleteSearchContent:(NSDictionary *)dic
{
    BOOL isSuccess = NO;
    isSuccess = [self.dataBase executeUpdate:@"DELETE FROM SearchHistory WHERE title = ? and type = ?",[dic objectForKey:@"title"], [dic objectForKey:@"type"]];
    return isSuccess;
}

- (BOOL)deleteSearchType:(NSString *)type
{
    BOOL isSuccess = [self.dataBase executeUpdate:@"DELETE FROM SearchHistory WHERE type = ?", type];
    return isSuccess;
}

- (BOOL)deleteEarliestSearchContent:(NSDictionary *)dic
{
    BOOL isSuccess = NO;
    isSuccess = [self.dataBase executeUpdate:@"DELETE FROM SearchHistory WHERE time = ? and type = ?",[dic objectForKey:@"time"], [dic objectForKey:@"type"]];
    return isSuccess;
}

@end
