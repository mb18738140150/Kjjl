//
//  ResetPwdOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/7.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "ResetPwdOperation.h"
#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"
#import "CommonMacro.h"

@interface ResetPwdOperation ()<HttpRequestProtocol>

@property (nonatomic,weak) id<UserModule_ResetPwdProtocol> notifiedObject;

@end

@implementation ResetPwdOperation

- (void)didRequestResetPwdWithOldPwd:(NSString *)oldPwd andNewPwd:(NSString *)newPwd withNotifiedObject:(id<UserModule_ResetPwdProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestResetPwdWithOldPassword:oldPwd andNewPwd:newPwd andProcessDelegate:self];
}

#pragma mark - http request
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didResetPwdSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didResetPwdFailed:failInfo];
    }
}

@end
