//
//  PayCourseOperation.m
//  Accountant
//
//  Created by aaa on 2017/11/22.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "PayCourseOperation.h"

#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"
@interface PayCourseOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_PayOrderProtocol> notifiedObject;
@end

@implementation PayCourseOperation

- (void)didRequestPayOrderWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_PayOrderProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestPayOrderWith:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.payOrderDetailInfo = successInfo;
    
    [[UserManager sharedManager] resetGoldCoinCount:[[successInfo objectForKey:@"coinCount"] intValue]];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestPayOrderSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestPayOrderFailed:failInfo];
    }
}

@end
