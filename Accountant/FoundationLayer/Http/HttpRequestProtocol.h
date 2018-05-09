//
//  HttpRequestProtocol.h
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HttpRequestProtocol <NSObject>

- (void)didRequestSuccessed:(NSDictionary *)successInfo;
- (void)didRequestFailed:(NSString *)failInfo;
- (void)didRequestFailedWithInfo:(NSDictionary *)failedInfo;

@end
