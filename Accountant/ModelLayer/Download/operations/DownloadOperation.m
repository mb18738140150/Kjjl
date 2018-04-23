//
//  DownloadOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/10.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DownloadOperation.h"

#import "CommonMacro.h"
#import "PathUtility.h"
#import "DownloadRquestOperation.h"
#import "PathUtility.h"
#import <objc/runtime.h>

@interface DownloadOperation ()

@property (nonatomic,strong) NSURLSessionDownloadTask       *downloadTask;

@property (nonatomic,strong) NSDictionary                   *downloadInfos;

@end

@implementation DownloadOperation

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)pauseDownload
{
    [self.downloadTask suspend];
}

- (void)unpauseDownload
{
    [self.downloadTask resume];
}

- (void)startDownloadWithManager:(AFURLSessionManager *)manager withInfoDic:(NSDictionary *)dic;
{
//    if (self.downloadTask) {
//        [self.downloadTask resume];
//        return;
//    }
    
    NSURL *url = [NSURL URLWithString:[dic objectForKey:kVideoURL]];
 
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSData *resumeData = [self resumeDataFromFileWithDownloadModel:dic];
    if ([self isValideResumeData:resumeData]) {
        self.downloadTask = [manager downloadTaskWithResumeData:resumeData progress:^(NSProgress * _Nonnull downloadProgress) {
            float process = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
//            [self.downloadResultDelegate didDownloadProcess:process];
            NSLog(@"%.1f", process*100);
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            NSString *docPath = [PathUtility getDocumentPath];
            NSString *path1 = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dic objectForKey:kCoursePath]]];
            NSString *path2 = [path1 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dic objectForKey:kChapterPath]]];
            NSString *path3 = [path2 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dic objectForKey:kVideoPath]]];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:path2 isDirectory:nil]) {
                [fileManager createDirectoryAtPath:path2 withIntermediateDirectories:YES attributes:nil error:nil];
            }
            return [NSURL fileURLWithPath:path3];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error == nil) {
                    [self.downloadResultDelegate didDownloadSuccess];
                }else{
                    NSLog(@"%@",error);
                    [self.downloadResultDelegate didDownloadFailed];
                }
            });
        }];
    }else  
    {
        self.downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            float process = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
//            [self.downloadResultDelegate didDownloadProcess:process];
            NSLog(@"%.1f", process*100);
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            NSString *docPath = [PathUtility getDocumentPath];
            NSString *path1 = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dic objectForKey:kCoursePath]]];
            NSString *path2 = [path1 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dic objectForKey:kChapterPath]]];
            NSString *path3 = [path2 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dic objectForKey:kVideoPath]]];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:path2 isDirectory:nil]) {
                [fileManager createDirectoryAtPath:path2 withIntermediateDirectories:YES attributes:nil error:nil];
            }
            return [NSURL fileURLWithPath:path3];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error == nil) {
                    [self.downloadResultDelegate didDownloadSuccess];
                }else{
                    NSLog(@"%@",error);
                    [self.downloadResultDelegate didDownloadFailed];
                }
            });
        }];
    }
    [self.downloadTask resume];
}


- (BOOL)isValideResumeData:(NSData *)resumeData
{
    if (!resumeData || resumeData.length == 0) {
        return NO;
    }
    return YES;
}

// 获取resumeData
- (NSData *)resumeDataFromFileWithDownloadModel:(NSDictionary *)dic
{
    NSString *docPath = [PathUtility getDocumentPath];
    NSString *path1 = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dic objectForKey:kCoursePath]]];
    NSString *path2 = [path1 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dic objectForKey:kChapterPath]]];
    NSString *path3 = [path2 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dic objectForKey:kVideoPath]]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path3]) {
        NSData *resumeData = [NSData dataWithContentsOfFile:path3];
        return resumeData;
    }
    return nil;
}



@end
