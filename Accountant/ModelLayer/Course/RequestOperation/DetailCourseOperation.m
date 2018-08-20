//
//  DetailCourseOperation.m
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DetailCourseOperation.h"
#import "HttpRequestManager.h"
#import "ChapterModel.h"
#import "VideoModel.h"

@interface DetailCourseOperation ()<HttpRequestProtocol>

@property (nonatomic,weak) id<CourseModule_DetailCourseProtocol>         detailCourseNotifiedObject;
@property (nonatomic,weak) DetailCourseModel                            *detailCourseModel;

@end

@implementation DetailCourseOperation

- (void)setCurrentDetailCourse:(DetailCourseModel *)model
{
    self.detailCourseModel = model;
}

- (void)requestDetailCourseWithID:(int)courseID withNotifiedObject:(id<CourseModule_DetailCourseProtocol>)object
{
    self.detailCourseNotifiedObject = object;
    [[HttpRequestManager sharedManager] requestDetailCourseWithCourseID:courseID andProcessDelegate:self];
}

#pragma mark - http delegate
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    NSArray *data = [successInfo objectForKey:@"chapterList"];
    [self.detailCourseModel removeAllChapters];
    self.detailCourseModel.courseModel.isCollect = [[successInfo objectForKey:@"isCollect"] boolValue];
    self.detailCourseModel.courseModel.canDownload = [[successInfo objectForKey:@"canDownload"] intValue];
    if ([[successInfo objectForKey:@"canDownload"] isKindOfClass:[NSNull class]]) {
        self.detailCourseModel.courseModel.canDownload = 0;
    }
    self.detailCourseModel.courseModel.canWatch = [[successInfo objectForKey:@"canWatch"] intValue];
    if ([[successInfo objectForKey:@"canWatch"] isKindOfClass:[NSNull class]]) {
        self.detailCourseModel.courseModel.canWatch = 0;
    }
    
    self.detailCourseModel.courseModel.price = [[successInfo objectForKey:@"price"] doubleValue];
    if ([[successInfo objectForKey:@"price"] isKindOfClass:[NSNull class]]) {
        self.detailCourseModel.courseModel.price = 0;
    }
    
    self.detailCourseModel.courseModel.oldPrice = [[successInfo objectForKey:@"oldPrice"] intValue];
    if ([[successInfo objectForKey:@"oldPrice"] isKindOfClass:[NSNull class]]) {
        self.detailCourseModel.courseModel.oldPrice = 0;
    }
    
    for (NSDictionary *tmpDic in data) {
        ChapterModel *cModel = [[ChapterModel alloc] init];
        cModel.chapterId = [[tmpDic objectForKey:@"id"] intValue];
       
        cModel.chapterName = [tmpDic objectForKey:@"name"];
        cModel.chapterSort = [[tmpDic objectForKey:@"sort"] intValue];
        if ([tmpDic objectForKey:@"url"] == nil || [[tmpDic objectForKey:@"url"] isEqualToString:@""]) {
            cModel.isSingleVideo = NO;
            cModel.chapterURL = @"";
            NSArray *videoArray = [tmpDic objectForKey:@"videoList"];
            if ([videoArray class] == [NSNull class] || videoArray == nil || videoArray.count == 0){
                continue;
            }
            for (NSDictionary *videoDic in videoArray) {
                VideoModel *video = [[VideoModel alloc] init];
                video.videoID = [[videoDic objectForKey:@"id"] intValue];
                video.videoName = [videoDic objectForKey:@"name"];
                NSString * videoURL = [[videoDic objectForKey:@"url"] stringByReplacingOccurrencesOfString:@" " withString:@""];
                video.videoURLString = videoURL;
                video.videoSort = [[videoDic objectForKey:@"sort"] intValue];
                [cModel addVideo:video];
            }
        }else{
            cModel.isSingleVideo = YES;
            cModel.chapterURL = [tmpDic objectForKey:@"url"];
        }
        [self.detailCourseModel addCourseChapter:cModel];
    }

    
    if (self.detailCourseNotifiedObject != nil) {
        [self.detailCourseNotifiedObject didRequestCourseDetailSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (self.detailCourseNotifiedObject != nil) {
        [self.detailCourseNotifiedObject didRequestCourseDetailFailed:failInfo];
    }
}

@end
