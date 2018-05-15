//
//  VerifyInAppPuchaseOperation.m
//  Accountant
//
//  Created by aaa on 2018/5/13.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "VerifyInAppPuchaseOperation.h"

#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"

@interface VerifyInAppPuchaseOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_VerifyInAppPurchase> notifiedObject;

@end

@implementation VerifyInAppPuchaseOperation

- (void)didRequestVerifyInAppPurchaseWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_VerifyInAppPurchase>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestInAppPurchaseWith:infoDic andProcessDelegate:self];
}


- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [[UserManager sharedManager] resetGoldCoinCount:[[successInfo objectForKey:@"coinCount"] intValue]];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestInAppPurchaseSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestInAppPurchaseFailed:failInfo];
    }
}

@end
