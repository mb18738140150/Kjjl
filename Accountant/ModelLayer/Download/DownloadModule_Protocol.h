//
//  DownloadModule_Protocol.h
//  Accountant
//
//  Created by aaa on 2017/3/10.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DownloadModule_DownloadProtocol <NSObject>

- (void)didDownloadSuccess;
- (void)didDownloadFailed;
- (void)deleteDownloadTask;
- (void)didDownloadSuspend;

@end
