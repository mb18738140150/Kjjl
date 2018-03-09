//
//  DownloaderManager.m
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DownloaderManager.h"
#import "DBManager.h"
//#import "DownloadOperation.h"
#import "CommonMacro.h"
#import "UserManager.h"

#import "PathUtility.h"
#import "DownloadRquestOperation.h"
#import "PathUtility.h"


@interface DownloaderManager ()


@property (nonatomic,strong) NSMutableArray     *downloadTaskIdQueue;

// 下载模型数组
@property (nonatomic, strong)NSMutableArray <DownLoadModel *>*downLoadwaitModelsArr;
@property (nonatomic, strong)NSMutableArray <DownLoadModel *>*downloadingModelsArray;

//@property (nonatomic,assign) BOOL                isDownloading;

@property (nonatomic,assign) BOOL                isDownloadPause;



@end

@implementation DownloaderManager

+ (instancetype)sharedManager
{
    static DownloaderManager *__manager__;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager__ = [[DownloaderManager alloc] init];
    });
    return __manager__;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.downloadTasksInfoQueue = [[NSMutableArray alloc] init];
        self.downloadTaskIdQueue = [[NSMutableArray alloc] init];
        self.downLoadwaitModelsArr = [[NSMutableArray alloc]init];
        self.downloadingModelsArray = [[NSMutableArray alloc]init];
        
        _AFManager = [[AFHTTPSessionManager alloc]init];
        _AFManager.requestSerializer.timeoutInterval = 20;
        [_AFManager.operationQueue setMaxConcurrentOperationCount:1];
        _AFManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        NSSet *typeSet = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        _AFManager.responseSerializer.acceptableContentTypes = typeSet;
        _AFManager.securityPolicy.allowInvalidCertificates = YES;
        
        self.maxDownloadCount = 2;
        self.isDownloadPause = NO;
        
//        NSMutableArray * array = [NSMutableArray array];
//        [array addObjectsFromArray:[[DBManager sharedManager]getDownloadingVideos]];
//        
//        NSLog(@"------------array.count = %ld--------", (unsigned long)array.count);
//        for (int i = 0; i < array.count; i++) {
//            DownLoadModel * model = array[i];
//            [self addDownloadTask:[model.infoDic mutableCopy]];
//            [self startDownload];
//            
//        }
        
    }
    return self;
}



- (BOOL)isTaskAddToDownloadedQueue:(NSString *)downloadTaskId
{
    if ([self.downloadTaskIdQueue containsObject:downloadTaskId]) {
        return YES;
    }
    return NO;
}

- (void)addDownloadTask:(NSMutableDictionary *)dic
{
    dispatch_async(dispatch_get_main_queue(), ^{
        DownLoadModel * model = [[DownLoadModel alloc]init];
        model.infoDic = dic;
        model.downLoadState = DownloadStateWait;
        model.filePath = [self getFilePath:dic];
        
        // 新添加的下载model先全部添加到等待下载数组
        [self.downLoadwaitModelsArr addObject:model];
        [self.downloadTaskIdQueue addObject:[dic objectForKey:kDownloadTaskId]];
    });
}

- (void)startDownload
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // 满足下载条件以后，从等待下载数组拿出第一个对象开始下载，并将该对象添加进下载中数组，然后再从等待下载数组中移除
        if (self.downLoadwaitModelsArr.count > 0 && self.downloadingModelsArray.count < self.maxDownloadCount) {
//            NSLog(@"start download ***** ");
            for (int i = 0; i < self.downLoadwaitModelsArr.count; i++) {
                DownLoadModel * model = [self.downLoadwaitModelsArr objectAtIndex:i];
                if (model.downLoadState == DownloadStatePause) {
                    continue;
                }
                model.downLoadState = DownloadStateDownloading;
                [self.downloadingModelsArray addObject:model];
                [self.downLoadwaitModelsArr removeObject:model];
                
                [self startDownload:model];
                
                break;
            }
        }
    });
}

- (void)startDownload:(DownLoadModel *)model
{
    if (model.downloadTask) {
        [model.downloadTask resume];
    }
    
    NSDictionary * dic = model.infoDic;
    NSURL *url = [NSURL URLWithString:[dic objectForKey:kVideoURL]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSData *resumeData = [self resumeDataFromFileWithDownloadModel:model];
    if ([self isValideResumeData:resumeData]) {
        model.downloadTask = [self.AFManager downloadTaskWithResumeData:resumeData progress:^(NSProgress * _Nonnull downloadProgress) {
            float process = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
            
            if (model.DownloadProcessBlock) {
                model.DownloadProcessBlock(process);
            };
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            NSString *docPath = [PathUtility getDocumentPath];
            NSString *path1 = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dic objectForKey:kCoursePath]]];
            NSString *path2 = [path1 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dic objectForKey:kChapterPath]]];
            NSString *path3 = [path2 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dic objectForKey:kVideoPath]]];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:path2 isDirectory:nil]) {
                [fileManager createDirectoryAtPath:path2 withIntermediateDirectories:YES attributes:nil error:nil];
            }
            
            NSLog(@"---- %@ ------ %@ ---",path2, path3);
            
            return [NSURL fileURLWithPath:path3];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error == nil) {
                    [self didDownloadSuccess:model.infoDic];
                }else{
                    NSLog(@"下载失败 %@",error);
                    [self didDownloadFailed:model.infoDic];
                }
            });
        }];
    }else
    {
        model.downloadTask = [self.AFManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            float process = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
            
            if (model.DownloadProcessBlock) {
                model.DownloadProcessBlock(process);
            };;
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            NSString *docPath = [PathUtility getDocumentPath];
            NSString *path1 = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dic objectForKey:kCoursePath]]];
            NSString *path2 = [path1 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dic objectForKey:kChapterPath]]];
            NSString *path3 = [path2 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dic objectForKey:kVideoPath]]];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:path2 isDirectory:nil]) {
                [fileManager createDirectoryAtPath:path2 withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSLog(@"---- %@ ------ %@ ---",path2, path3);
            return [NSURL fileURLWithPath:path3];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error == nil) {
                    [self didDownloadSuccess:model.infoDic];
                }else{
                    NSLog(@"下载失败 %@",error);
                    [self didDownloadFailed:model.infoDic];
                }
            });
        }];
    }
    
    
    NSURLSessionDownloadTask * task = model.downloadTask;
    NSLog(@"开始下载 %@, %p", [model.infoDic objectForKey:kVideoName], &task);
    [model.downloadTask resume];
}


- (void)removeFirstDownloadObject:(NSDictionary *)dic withDownloadDone:(BOOL)downloadDone
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // 下载完成或者失败，将包含该下载信息字典的model对象从下载中数组中移除
        for (int i = 0; i < self.downloadingModelsArray.count; i++) {
            DownLoadModel * model = self.downloadingModelsArray[i];
            if ([[model.infoDic objectForKey:kDownloadTaskId] isEqualToString:[dic objectForKey:kDownloadTaskId]]) {
                if (!downloadDone) {
                    [self.downLoadwaitModelsArr addObject:model];
                }
                [self.downloadingModelsArray removeObject:model];
                break;
            }
        }
        
        [self.downloadTaskIdQueue removeObject:[dic objectForKey:kDownloadTaskId]];
        
    });
}

// 暂停下载
- (void)pauseDownloadWithModel:(DownLoadModel *)model
{
    
    NSURLSessionDownloadTask * task = model.downloadTask;
    NSURLSessionTaskState state = task.state;
    if (state == NSURLSessionTaskStateRunning) {
        [(NSURLSessionDownloadTask *)model.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            @synchronized (self) {
                model.downLoadState = DownloadStatePause;
                model.resumeData = resumeData;
                [model.resumeData writeToFile:model.filePath atomically:YES];
                [[DBManager sharedManager] saveDownLoadingInfo:model.infoDic];
                [self.downLoadwaitModelsArr addObject:model];
                [self.downloadingModelsArray removeObject:model];
                [self startDownload];
            }
            
        }];
    }
}

// 恢复下载
- (void)unPauseDownloadWithModel:(DownLoadModel *)model
{
    model.downLoadState = DownloadStateWait;
    [self startDownload];
}

- (void)deleteDownloadtask:(DownLoadModel *)model
{
    NSURLSessionDownloadTask * task = model.downloadTask;
    
    if (!task) {
        [self.downLoadwaitModelsArr removeObject:model];
        if (isObjectNotNil(self.processDownloadDelegate)) {
            [self.processDownloadDelegate deleteDownloadTask];
        };
        return;
    }
    
    
    NSURLSessionTaskState state = task.state;
    if (state == NSURLSessionTaskStateRunning) {
        [(NSURLSessionDownloadTask *)model.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            @synchronized (self) {
                model.downLoadState = DownloadStatePause;
                [[DBManager sharedManager] deletedownLoadVideoWithId:model.infoDic];
                NSDictionary * dic = model.infoDic;
                NSString *docPath = [PathUtility getDocumentPath];
                NSString *path1 = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dic objectForKey:kCoursePath]]];
                NSString *path2 = [path1 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dic objectForKey:kChapterPath]]];
                NSString *path3 = [path2 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dic objectForKey:kVideoPath]]];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                
                if ([fileManager fileExistsAtPath:path3]) {
                    [fileManager removeItemAtPath:path3 error:nil];
                }
//                [self.downloadingModelsArray removeObject:model];
                
                for (int i = 0; i < self.downloadingModelsArray.count; i++) {
                    DownLoadModel * dModel = [self.downloadingModelsArray objectAtIndex:i];
                    if ([[dModel.infoDic objectForKey:kVideoId] isEqual:[model.infoDic objectForKey:kVideoId]]) {
                        [self.downloadingModelsArray removeObject:dModel];
                        break;
                    }
                }
                
                [self startDownload];
                if (isObjectNotNil(self.processDownloadDelegate)) {
                    [self.processDownloadDelegate deleteDownloadTask];
                };
            }
            
        }];
        return;
    }else
    {
        @synchronized (self) {
            model.downLoadState = DownloadStatePause;
            [[DBManager sharedManager] deletedownLoadVideoWithId:model.infoDic];
            NSDictionary * dic = model.infoDic;
            NSString *docPath = [PathUtility getDocumentPath];
            NSString *path1 = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dic objectForKey:kCoursePath]]];
            NSString *path2 = [path1 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dic objectForKey:kChapterPath]]];
            NSString *path3 = [path2 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dic objectForKey:kVideoPath]]];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            if ([fileManager fileExistsAtPath:path2]) {
                NSError * error;
                if ([fileManager removeItemAtPath:path3 error:&error]) {
                    
                    NSLog(@"model 删除成功 %@", error);
                }else
                {
                    NSLog(@"model 删除失败 %@", error);
                }
            }else
            {
                NSLog(@"fileManager 不存在 path3路径下文件");
            }
//            [self.downLoadwaitModelsArr removeObject:model];
            
            for (int i = 0; i < self.downLoadwaitModelsArr.count; i++) {
                DownLoadModel * dModel = [self.downLoadwaitModelsArr objectAtIndex:i];
                if ([[dModel.infoDic objectForKey:kVideoId] isEqual:[model.infoDic objectForKey:kVideoId]]) {
                    [self.downLoadwaitModelsArr removeObject:dModel];
                    break;
                }
            }
            
            [self startDownload];
            if (isObjectNotNil(self.processDownloadDelegate)) {
                [self.processDownloadDelegate deleteDownloadTask];
            };
        }
        return;
    }
    if (isObjectNotNil(self.processDownloadDelegate)) {
        [self.processDownloadDelegate deleteDownloadTask];
    };
}


- (void)writeToDBWith:(NSDictionary *)dic
{
    [[DBManager sharedManager] saveDownloadInfo:dic];
}

- (NSArray *)getDownloadCourseInfoArray
{
    NSMutableArray *downloadCourseInfo = [[NSMutableArray alloc] init];
    NSArray *coursInfos = [[DBManager sharedManager] getDownloadedCourseInfo];
    for (NSDictionary *courseDic in coursInfos) {
        for (NSDictionary *chapDic in [courseDic objectForKey:kCourseChapterInfos]){
            NSArray *videoInfos = [chapDic objectForKey:kChapterVideoInfos];
            if (videoInfos.count != 0) {
                [downloadCourseInfo addObject:courseDic];
                break;
            }
        }
    }
    
    return downloadCourseInfo;
}

- (NSArray *)getDownloadingVideoInfoArray
{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    for (DownLoadModel * model in self.downloadingModelsArray) {
        if (model) {
            [array addObject:model.infoDic];
        }
    }
    for (DownLoadModel *model in self.downLoadwaitModelsArr) {
        if (model) {
            [array addObject:model.infoDic];
        };
    }
    return array;
}

- (NSArray *)getDownloadCourseDetailWithCourseId:(NSNumber *)courseId
{
    return nil;
}

- (BOOL)getIsDownloadPause
{
    return self.isDownloadPause;
}

#pragma mark - download delegate

- (void)didDownloadSuccess:(NSDictionary *)dic
{
    [self writeDB:dic];
    [self removeFirstDownloadObject:dic withDownloadDone:YES];
    [self startDownload];
    if (isObjectNotNil(self.processDownloadDelegate)) {
//        NSLog(@"下载完成%@", [dic description]);
        [self.processDownloadDelegate didDownloadSuccess];
    }
}

- (void)didDownloadFailed:(NSDictionary *)dic
{
    [self removeFirstDownloadObject:dic withDownloadDone:YES];
    [self startDownload];
    if (isObjectNotNil(self.processDownloadDelegate)) {
        [self.processDownloadDelegate didDownloadFailed];
    }
}

- (DownLoadModel *)getDownLoadModelWithDownloadTsakId:(NSString *)taskId
{
    for (DownLoadModel * model in self.downloadingModelsArray) {
        if ([[model.infoDic objectForKey:kDownloadTaskId] isEqualToString:taskId]) {
            return model;
        }
    }
    for (DownLoadModel *model in self.downLoadwaitModelsArr) {
        if ([[model.infoDic objectForKey:kDownloadTaskId] isEqualToString:taskId]) {
            return model;
        }
    }
    return nil;
}
- (BOOL)isValideResumeData:(NSData *)resumeData
{
    if (!resumeData || resumeData.length == 0) {
        return NO;
    }
    return YES;
}
- (NSString *)getFilePath:(NSDictionary *)dic
{
    NSString *docPath = [PathUtility getDocumentPath];
    NSString *path1 = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dic objectForKey:kCoursePath]]];
    NSString *path2 = [path1 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dic objectForKey:kChapterPath]]];
    NSString *path3 = [path2 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dic objectForKey:kVideoPath]]];
    return path3;
}
// 获取resumeData
- (NSData *)resumeDataFromFileWithDownloadModel:(DownLoadModel *)model
{
    NSDictionary * dic = model.infoDic;
    if (model.resumeData) {
        return model.resumeData;
    }
    
    NSString *docPath = [PathUtility getDocumentPath];
    NSString *path1 = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dic objectForKey:kCoursePath]]];
    NSString *path2 = [path1 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dic objectForKey:kChapterPath]]];
    NSString *path3 = [path2 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dic objectForKey:kVideoPath]]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path3]) {
        NSData *resumeData = [NSData dataWithContentsOfURL:[NSURL URLWithString:path3]];
        return resumeData;
    }
    return nil;
}

#pragma mark - TY
- (void)TY_addDownloadTask:(NSMutableDictionary *)dic
{
    
    if (![[DBManager sharedManager] isExitDownloadingVideo:dic]) {
        [[DBManager sharedManager] saveDownLoadingInfo:dic];
    }
    
    TYDownloadModel * downLoadModel = [[TYDownloadModel alloc]initWithURLString:[dic objectForKey:kVideoURL] filePath:[self getFilePath:dic] infoDic:dic];
    
    TYDownloadSessionManager *manager = [TYDownloadSessionManager manager];
    __weak typeof(self) weakSelf = self;
    [manager startWithDownloadModel:downLoadModel progress:^(TYDownloadProgress *progress) {
       
    } state:^(TYDownloadState state, NSString *filePath, NSError *error) {
        if (state == TYDownloadStateCompleted) {
            [weakSelf writeDB:dic];
            if (isObjectNotNil(weakSelf.processDownloadDelegate)) {
                //        NSLog(@"下载完成%@", [dic description]);
                [weakSelf.processDownloadDelegate didDownloadSuccess];
            }
        }else if (state == TYDownloadStateNone){
            if (isObjectNotNil(self.processDownloadDelegate)) {
                [weakSelf.processDownloadDelegate deleteDownloadTask];
            };
        }else if (state == TYDownloadStateSuspended){
            if (isObjectNotNil(self.processDownloadDelegate)) {
                [weakSelf.processDownloadDelegate didDownloadSuspend];
            };
        }
        
        //NSLog(@"state %ld error%@ filePath%@",state,error,filePath);
    }];
}

- (void)writeDB:(NSDictionary *)dic
{
    NSLog(@"下载完成 dic = %@", dic);
    [[DBManager sharedManager] deletedownLoadVideoWithId:dic];
    [[DBManager sharedManager] saveDownloadInfo:dic];
}

- (TYDownloadModel *)TY_getDownLoadModelWithDownloadVideoURL:(NSString *)videoURL
{
    return [[TYDownloadSessionManager manager] downLoadingModelForURLString:videoURL];
}

- (NSArray *)TY_getDownloadingVideoInfoArray
{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    
    TYDownloadSessionManager *manager = [TYDownloadSessionManager manager];
    for (DownLoadModel * model in manager.downloadingModels) {
        if (model) {
            [array addObject:model.infoDic];
        }
    }
    for (DownLoadModel *model in manager.waitingDownloadModels) {
        if (model) {
            [array addObject:model.infoDic];
        };
    }
    
    return array;
}

- (BOOL)TY_isTaskAddToDownloadedQueue:(NSString *)VideoUrl
{
    TYDownloadModel *model = [[TYDownloadSessionManager manager] downLoadingModelForURLString:VideoUrl];
    if (model) {
        return YES;
    }else
    {
        return NO;
    }
}

- (BOOL)isVideoIsDownloadedWithVideoId:(NSDictionary *)videoInfo
{
    BOOL isDownloaded = [[DBManager sharedManager] isVideoDownload:videoInfo];
    return isDownloaded;
}

// 暂停下载
- (void)TY_pauseDownloadWithModel:(TYDownloadModel *)model
{
    TYDownloadSessionManager *manager = [TYDownloadSessionManager manager];
    [manager suspendWithDownloadModel:model];
}

// 恢复下载
- (void)TY_unPauseDownloadWithModel:(TYDownloadModel *)model
{
    TYDownloadSessionManager *manager = [TYDownloadSessionManager manager];
    [manager startWithDownloadModel:model];
}

// 删除下载任务
- (void)TY_deleteDownloadtask:(TYDownloadModel *)model
{
    TYDownloadSessionManager *manager = [TYDownloadSessionManager manager];
    [manager deleteFileWithDownloadModel:model];
    [[DBManager sharedManager] deletedownLoadVideoWithId:model.infoDic];
}

@end
