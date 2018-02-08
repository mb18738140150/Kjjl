//
//  SubmitGiftCodeOperation.m
//  Accountant
//
//  Created by aaa on 2018/2/5.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "SubmitGiftCodeOperation.h"
#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"

@interface SubmitGiftCodeOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_SubmitGiftCode> notifiedObject;

@end
@implementation SubmitGiftCodeOperation

- (void)didRequestSubmitGiftCodeWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_SubmitGiftCode>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestSubmitGiftCodeWithInfoDic:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestSubmitGiftCodeSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestSubmitGiftCodeFailed:failInfo];
    }
}

@end
