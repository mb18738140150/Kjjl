//
//  CancelOrderLivingCourseOperation.m
//  Accountant
//
//  Created by aaa on 2017/10/13.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "CancelOrderLivingCourseOperation.h"

#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"
@interface CancelOrderLivingCourseOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_CancelOrderLivingCourseProtocol> notifiedObject;
@end
@implementation CancelOrderLivingCourseOperation
- (void)didRequestCancelOrderLivingCourseWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_CancelOrderLivingCourseProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustCancelOrderLivingCourseWithInfo:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestCancelOrderLivingSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestCancelOrderLivingFailed:failInfo];
    }
}


@end
