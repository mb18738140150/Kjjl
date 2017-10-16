//
//  VerifyAccountOperation.m
//  Accountant
//
//  Created by aaa on 2017/9/15.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "VerifyAccountOperation.h"
#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"

@interface VerifyAccountOperation ()<HttpRequestProtocol>

@property (nonatomic,weak) id<UserModule_VerifyAccountProtocol> notifiedObject;

@end

@implementation VerifyAccountOperation


- (void)didRequestVerifyAccountWithWithAccountNumber:(NSString *)accountNumber withNotifiedObject:(id<UserModule_VerifyAccountProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustVerifyAccountWithAccountNumber:accountNumber andProcessDelegate:self];
}


#pragma mark - http request
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.verifyPhoneNumber = [NSString stringWithFormat:@"%@", [successInfo objectForKey:@"phoneNumber"]];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didVerifyAccountSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didVerifyAccountFailed:failInfo];
    }
}


@end
