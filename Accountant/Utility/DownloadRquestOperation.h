//
//  DownloadRquestOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/10.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadRquestOperation : NSObject


/**
 获取下载地址

 @param str 播放地址
 @return 下载地址
 */
+ (NSString *)getOperation:(NSString *)str;


/**
 获取下载任务的id

 @param chapterId 章节id
 @param videoId 视频id
 @return 下载任务id
 */
+ (NSString *)getDownloadTaskIdWitChapterId:(NSNumber *)chapterId andVideoId:(NSNumber *)videoId;

@end
