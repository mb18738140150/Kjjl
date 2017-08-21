//
//  UploadImageOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/16.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "UploadImageOperation.h"
#import "HttpUploaderManager.h"
#import "HttpUploadProtocol.h"

@interface UploadImageOperation ()<HttpUploadProtocol>

@property (nonatomic,weak) id<ImageModule_UploadProtocol>            notifiedObject;

@end

@implementation UploadImageOperation

- (void)didUploadImage:(NSData *)imageData withNotifiedObject:(id<ImageModule_UploadProtocol>)notifiedObject
{
    self.notifiedObject = notifiedObject;
    [[HttpUploaderManager sharedManager] uploadImage:imageData withProcessDelegate:self];
}

#pragma mark - upload delegate
- (void)didUploadSuccess:(NSDictionary *)successInfo
{
    NSLog(@"3333333%@",successInfo);
}

- (void)didUploadFailed:(NSString *)uploadFailed
{
    NSLog(@"44444%@",uploadFailed);
}

@end
