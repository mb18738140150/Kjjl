//
//  HistoryCourseOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/17.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "HistoryCourseOperation.h"
#import "HttpRequestManager.h"
#import "CommonMacro.h"
#import "HistoryDayModel.h"
#import "HistoryDisplayModel.h"

@interface HistoryCourseOperation ()<HttpRequestProtocol>

@property (nonatomic,weak) id<CourseModule_HistoryCourseProtocol> notifiedObject;

@end

@implementation HistoryCourseOperation

- (void)didRequestHistoryCourseWithNotifiedObject:(id<CourseModule_HistoryCourseProtocol>)notifiedObject
{
    self.notifiedObject = notifiedObject;
    [[HttpRequestManager sharedManager] requestHistoryCourseWithProcessDelegate:self];
}

- (void)didRequestAddHistoryCourseWithInfo:(NSDictionary *)info
{
    [[HttpRequestManager sharedManager] requestAddHistoryInfoWithInfo:info];
}

#pragma mark - http delegate

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    
    
    [self.historyArray removeAllObjects];
    NSArray *data = [successInfo objectForKey:@"data"];
    for (NSDictionary *tmpDic in data) {
        HistoryDayModel *model = [[HistoryDayModel alloc] init];
        model.timeString = [tmpDic objectForKey:@"timeStr"];
        NSArray *aaaa = [tmpDic objectForKey:@"courseLog"];
        for (NSDictionary *info in aaaa){
            
            HistoryDisplayModel *tmpModel = [[HistoryDisplayModel alloc] init];
            tmpModel.chapterId = [[info objectForKey:@"chapterId"] intValue];
            tmpModel.chapterName = [info objectForKey:@"chapterName"];
            tmpModel.courseId = [[info objectForKey:@"courseId"] intValue];
            tmpModel.courseName = [info objectForKey:@"courseName"];
            tmpModel.courseCover = [info objectForKey:@"courseCover"];
            tmpModel.videoId = [[info objectForKey:@"videoId"] intValue];
            tmpModel.videoName = [info objectForKey:@"videoName"];
            [model addHistory:tmpModel];
        }
        
        [self.historyArray addObject:model];
    }
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestHistroyCourseSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestHistroyCourseFailed:failInfo];
    }
}

@end
