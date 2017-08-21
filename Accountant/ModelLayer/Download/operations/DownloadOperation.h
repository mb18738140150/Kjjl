//
//  DownloadOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/10.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadModule_Protocol.h"
#import "AFNetworking.h"
@interface DownloadOperation : NSObject

@property (nonatomic,weak) id<DownloadModule_DownloadProtocol> downloadResultDelegate;

- (void)startDownloadWithManager:(AFURLSessionManager *)manager withInfoDic:(NSDictionary *)dic;

- (void)pauseDownload;
- (void)unpauseDownload;

@end
