//
//  SubmitOpinionOperation.m
//  Accountant
//
//  Created by aaa on 2018/1/12.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "SubmitOpinionOperation.h"
#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"

@interface SubmitOpinionOperation ()<HttpRequestProtocol>

@property (nonatomic,weak) id<UserModule_SubmitOperationProtocol> notifiedObject;

@end

@implementation SubmitOpinionOperation

- (void)didRequestSubmitOpinionWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_SubmitOperationProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestSubmitOpinionWithInfoDic:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestSubmitOperationSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestSubmitOperationFailed:failInfo];
    }
}

@end
