//
//  AcquireDiscountCouponOperation.m
//  Accountant
//
//  Created by aaa on 2018/3/19.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "AcquireDiscountCouponOperation.h"

#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"

@interface AcquireDiscountCouponOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_AcquireDiscountCouponProtocol> notifiedObject;
@end


@implementation AcquireDiscountCouponOperation

- (NSMutableArray *)discountCouponArray
{
    if (!_discountCouponArray) {
        _discountCouponArray = [NSMutableArray array];
    }
    return _discountCouponArray;
}

- (void)didRequestAcquireDiscountCouponWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_AcquireDiscountCouponProtocol>)object
{
    self.notifiedObject = object;
    
    [[HttpRequestManager sharedManager] requestAcquireDiscountCouponWithInfoDic:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [self.discountCouponArray removeAllObjects];
    NSArray *dataList = [successInfo objectForKey:@"data"];
    if (dataList == nil || ![dataList isKindOfClass:[NSArray class]]) {
        NSLog(@"[dataList class] = %@", [dataList class]);
        return;
    }
    for (NSDictionary *infoDic in dataList) {
        [self.discountCouponArray addObject:infoDic];
    }
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestAcquireDiscountCouponSuccessed];
    }
}

- (void)didRequestFailedWithInfo:(NSDictionary *)failedInfo
{
    [self.discountCouponArray removeAllObjects];
    NSArray *dataList = [failedInfo objectForKey:@"data"];
    if (dataList == nil || ![dataList isKindOfClass:[NSArray class]]) {
        NSLog(@"[dataList class] = %@", [dataList class]);
        return;
    }
    for (NSDictionary *infoDic in dataList) {
        [self.discountCouponArray addObject:infoDic];
    }
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestAcquireDiscountCouponSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestAcquireDiscountCouponFailed:failInfo];
    }
}

@end
