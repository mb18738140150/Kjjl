//
//  HttpUploaderManager.h
//  Accountant
//
//  Created by aaa on 2017/3/15.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpUploadProtocol.h"

@interface HttpUploaderManager : NSObject

+ (instancetype)sharedManager;

- (void)uploadImage:(NSData *)imageData withProcessDelegate:(id<HttpUploadProtocol>)processObject;

@end
