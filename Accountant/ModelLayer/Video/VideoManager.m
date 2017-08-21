//
//  VideoManager.m
//  Accountant
//
//  Created by aaa on 2017/3/1.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "VideoManager.h"
#import "PlayingVideoModel.h"
#import "PlayingVideoOperation.h"
#import "CommonMacro.h"
#import "DBManager.h"
#import "WriteOperations.h"

@interface VideoManager ()

@property (nonatomic,strong) PlayingVideoModel          *playingVideoModel;

@property (nonatomic,strong) PlayingVideoOperation      *playingVideoOperation;

@end

@implementation VideoManager

+ (instancetype)sharedManager
{
    static VideoManager *__manager__;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager__ = [[VideoManager alloc] init];
    });
    return __manager__;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.playingVideoOperation = [[PlayingVideoOperation alloc] init];
        self.playingVideoModel = [[PlayingVideoModel alloc] init];
    }
    return self;
}

- (void)setPlayingVideoDicInfo:(NSDictionary *)infoDic
{
    self.playingVideoModel.courseName = [infoDic objectForKey:kCourseName];
    self.playingVideoModel.courseUrl = [infoDic objectForKey:kCourseURL];
//    self.playingVideoModel
}

- (NSDictionary *)getCurrentVideoInfoWithVideoId:(NSNumber *)videoId
{
    NSDictionary * dic = [[DBManager sharedManager]getLineVideoInfoWithVideoId:videoId];
    return dic;
}
- (void)writeToDB:(NSDictionary *)dic
{
    [[DBManager sharedManager]saveLineVideoInfo:dic];
}
@end
