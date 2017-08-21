
//
//  DownLoadModel.m
//  Accountant
//
//  Created by aaa on 2017/4/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DownLoadModel.h"

@implementation DownLoadModel

- (instancetype)init
{
    if (self = [super init]) {
        self.downLoadOperation = [[DownloadOperation alloc] init];
        self.downLoadOperation.downloadResultDelegate = self;
        self.fileSize = @"0";
        self.cueerntFileSize = @"0";
    }
    return self;
}


#pragma mark - download delegate
- (void)didDownloadSuccess
{
    if ([self.delegate respondsToSelector:@selector(didDownloadSuccess:)]) {
        [self.delegate didDownloadSuccess:self.infoDic];
    }
    
}

- (void)didDownloadFailed
{
    if ([self.delegate respondsToSelector:@selector(didDownloadFailed:)]) {
        [self.delegate didDownloadFailed:self.infoDic];
    }
}

- (void)didDownloadProcess:(float)process
{
    if (self.DownloadProcessBlock) {
        self.DownloadProcessBlock(process);
    }
}

- (void)pause
{
    [self.downLoadOperation pauseDownload];
    self.downLoadState = DownloadStatePause;
    if ([self.delegate respondsToSelector:@selector(pauseDownload:)]) {
        [self.delegate pauseDownload:self.infoDic];
    }
}
- (void)unPause
{
    [self.downLoadOperation unpauseDownload];
    self.downLoadState = DownloadStateWait;
    if ([self.delegate respondsToSelector:@selector(unpauseDownload:)]) {
        [self.delegate unpauseDownload:self.infoDic];
    }
}

@end
