//
//  DownLoadModel.h
//  Accountant
//
//  Created by aaa on 2017/4/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadOperation.h"

@protocol DownloadModelProtocol <NSObject>

- (void)didDownloadSuccess:(NSDictionary *)dic;
- (void)didDownloadFailed:(NSDictionary *)dic;

- (void)pauseDownload:(NSDictionary *)dic;

- (void)unpauseDownload:(NSDictionary *)dic;

@end

typedef enum {
    DownloadStateWait,
    DownloadStatePause,
    DownloadStateDownloading
}DownloadState;

@interface DownLoadModel : NSObject<DownloadModule_DownloadProtocol>

@property (nonatomic, assign)id<DownloadModelProtocol> delegate;

// 下载状态
@property (nonatomic, assign)DownloadState downLoadState;
// 下载类
@property (nonatomic, strong)DownloadOperation *downLoadOperation;// 没有使用

// 下载信息
@property (nonatomic, strong)NSDictionary * infoDic;
/** 文件的总长度 */
@property (nonatomic,strong) NSString      *fileSize;
@property (nonatomic,strong) NSString      *cueerntFileSize;
/** 保存资源文件信息 路径 */
@property (nonatomic, copy, nullable) NSString *filePath;

@property (nonatomic, copy)void (^DownloadProcessBlock)(float process);

@property (nonatomic,strong) NSURLSessionDownloadTask       *downloadTask;

@property (nonatomic, strong)NSData * resumeData;


//- (void)pause;
//- (void)unPause;

@end
