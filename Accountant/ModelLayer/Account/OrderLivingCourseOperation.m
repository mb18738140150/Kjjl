//
//  OrderLivingCourseOperation.m
//  Accountant
//
//  Created by aaa on 2017/7/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "OrderLivingCourseOperation.h"
#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"
@interface OrderLivingCourseOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_OrderLivingCourseProtocol> notifiedObject;
@end
@implementation OrderLivingCourseOperation
- (void)didRequestOrderLivingCourseWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_OrderLivingCourseProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustOrderLivingCourseWithInfo:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestOrderLivingSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestOrderLivingFailed:failInfo];
    }
}

@end
