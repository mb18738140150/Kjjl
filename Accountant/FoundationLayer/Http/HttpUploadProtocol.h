//
//  HttpUploadProtocol.h
//  Accountant
//
//  Created by aaa on 2017/3/16.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HttpUploadProtocol <NSObject>

- (void)didUploadSuccess:(NSDictionary *)successInfo;
- (void)didUploadFailed:(NSString *)uploadFailed;

@end
