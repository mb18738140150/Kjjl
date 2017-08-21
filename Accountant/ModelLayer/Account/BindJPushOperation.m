//
//  BindJPushOperation.m
//  Accountant
//
//  Created by aaa on 2017/7/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "BindJPushOperation.h"
#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"
@interface BindJPushOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_BindJPushProtocol> notifiedObject;
@end

@implementation BindJPushOperation

- (void)didRequestBindJPushWithCID:(NSString *)cid withNotifiedObject:(id<UserModule_BindJPushProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustBindJPushWithCId:cid andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestBindJPushSuccessed];
    }
}
- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestBindJPushFailed:failInfo];
    }
}
@end
