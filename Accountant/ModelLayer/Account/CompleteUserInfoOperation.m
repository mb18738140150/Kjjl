//
//  CompleteUserInfoOperation.m
//  Accountant
//
//  Created by aaa on 2017/9/18.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "CompleteUserInfoOperation.h"
#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"
@interface CompleteUserInfoOperation ()<HttpRequestProtocol>

@property (nonatomic,weak) id<UserModule_CompleteUserInfoProtocol> notifiedObject;

@end

@implementation CompleteUserInfoOperation

- (void)didRequestCompleteUserInfoWithWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_CompleteUserInfoProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager]reqeustCompleteUserInfoWithDic:infoDic andProcessDelegate:self];
}

#pragma mark - http request
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didCompleteUserSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didCompleteUserFailed:failInfo];
    }
}

@end
