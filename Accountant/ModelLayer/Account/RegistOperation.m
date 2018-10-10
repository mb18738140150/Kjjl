//
//  RegistOperation.m
//  Accountant
//
//  Created by aaa on 2017/9/13.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "RegistOperation.h"

#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"

@interface RegistOperation ()<HttpRequestProtocol>

@property (nonatomic,weak) id<UserModule_RegistProtocol> notifiedObject;

@end

@implementation RegistOperation

- (void)didRequestRegistWithWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_RegistProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustRegistWithdic:infoDic andProcessDelegate:self];
}

#pragma mark - http request
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRegistSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRegistFailed:failInfo];
    }
}


@end
