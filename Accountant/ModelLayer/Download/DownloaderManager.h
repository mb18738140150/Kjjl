//
//  DownloaderManager.h
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadModule_Protocol.h"
#import "DownLoadModel.h"
#import "AFNetworking.h"
#import "TYDownloadSessionManager.h"
//#import "TYDownLoadDataManager.h"

typedef enum {
    DownloadTaskStateWait,
    DownloadTaskPause,
    DownloadTaskStateDownloading
}DownloadTaskState;

@interface DownloaderManager : NSObject

@property (nonatomic,weak) id<DownloadModule_DownloadProtocol>           processDownloadDelegate;
@property (nonatomic, assign)int maxDownloadCount;
@property (nonatomic, strong) AFHTTPSessionManager *AFManager;

/** fileManager */
@property (nonatomic, strong) NSFileManager *fileManager;

@property (nonatomic,strong)  NSMutableDictionary <NSString *, NSDictionary *> *unFinishDownloadPlisDict;

@property (nonatomic,strong)  NSMutableDictionary <NSString *, NSDictionary *> *finishDownloadPlisDict;


+ (instancetype)sharedManager;





/**
 某一下载任务是否加入了下载队列

 @param downloadTaskId 下载任务id
 @return 是否加入队列
 */
- (BOOL)isTaskAddToDownloadedQueue:(NSString *)downloadTaskId;


/**
 获取下载过的课程信息

 @return 课程信息
 */
- (NSArray *)getDownloadCourseInfoArray;


/**
 获取正在下载的视频信息

 @return 视频信息
 */
- (NSArray *)getDownloadingVideoInfoArray;

//- (NSArray *)getDownloadCourseDetailWithCourseId:(NSNumber *)courseId;

// 暂停下载
- (void)pauseDownloadWithModel:(DownLoadModel *)model;

// 恢复下载
- (void)unPauseDownloadWithModel:(DownLoadModel *)model;

// 删除下载任务
- (void)deleteDownloadtask:(DownLoadModel *)model;

/**
 开始下载
 */
- (void)startDownload;


/**
 加载下载任务

 @param dic 下载任务信息
 */
- (void)addDownloadTask:(NSMutableDictionary *)dic;


/**
 获取下载是否停止

 @return 是否停止
 */
- (BOOL)getIsDownloadPause;

- (void)writeToDBWith:(NSDictionary *)dic;

- (DownLoadModel *)getDownLoadModelWithDownloadTsakId:(NSString *)taskId;

#pragma mark - TY

/**
 获取某一视频是否已经下载
 
 @param videoInfo 视频info
 @return 是否下载
 */
- (BOOL)isVideoIsDownloadedWithVideoId:(NSDictionary *)videoInfo;

/**
 获取某一视频是否已经下载
 
 @param videoId 视频id
 @return 是否下载
 */
- (BOOL)TY_isVideoIsDownloadedWithVideoId:(NSNumber *)videoId;// 未实现


/**
 某一下载任务是否加入了下载队列
 
 @param VideoUrl 下载任务url
 
 @return 是否加入队列
 */
- (BOOL)TY_isTaskAddToDownloadedQueue:(NSString *)VideoUrl;


/**
 获取下载过的课程信息
 
 @return 课程信息
 */
- (NSArray *)TY_getDownloadCourseInfoArray;


/**
 获取正在下载的视频信息
 
 @return 视频信息
 */
- (NSArray *)TY_getDownloadingVideoInfoArray;

//- (NSArray *)getDownloadCourseDetailWithCourseId:(NSNumber *)courseId;

// 暂停下载
- (void)TY_pauseDownloadWithModel:(TYDownloadModel *)model;

// 恢复下载
- (void)TY_unPauseDownloadWithModel:(TYDownloadModel *)model;

// 删除下载任务
- (void)TY_deleteDownloadtask:(TYDownloadModel *)model;




/**
 开始下载
 */
- (void)TY_startDownload;


/**
 加载下载任务
 
 @param dic 下载任务信息
 */
- (void)TY_addDownloadTask:(NSMutableDictionary *)dic;


/**
 获取下载是否停止
 
 @return 是否停止
 */
- (BOOL)TY_getIsDownloadPause;

- (void)TY_writeToDBWith:(NSDictionary *)dic;

- (TYDownloadModel *)TY_getDownLoadModelWithDownloadVideoURL:(NSString *)videoURL;


@end
