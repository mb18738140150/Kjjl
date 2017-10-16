//
//  VerifyCodeOperation.m
//  Accountant
//
//  Created by aaa on 2017/9/13.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "VerifyCodeOperation.h"

#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"

@interface VerifyCodeOperation ()<HttpRequestProtocol>

@property (nonatomic,weak) id<UserModule_VerifyCodeProtocol> notifiedObject;

@end

@implementation VerifyCodeOperation

- (void)didRequestVerifyCodeWithWithPhoneNumber:(NSString *)phoneNumber withNotifiedObject:(id<UserModule_VerifyCodeProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustVerifyCodeWithPhoneNumber:phoneNumber andProcessDelegate:self];
}

#pragma mark - http request
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.verifyCode = [successInfo objectForKey:@"verifyCode"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didVerifyCodeSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didVerifyCodeFailed:failInfo];
    }
}

@end
