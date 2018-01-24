//
//  DiscountCouponOperation.m
//  Accountant
//
//  Created by aaa on 2017/12/19.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DiscountCouponOperation.h"

#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"

@interface DiscountCouponOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_discountCouponProtocol> notifiedObject;
@end


@implementation DiscountCouponOperation

- (NSMutableArray *)discountCouponArray
{
    if (!_discountCouponArray) {
        _discountCouponArray = [NSMutableArray array];
    }
    return _discountCouponArray;
}

- (void)didRequestDiscountCouponWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_discountCouponProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestDiscountCouponWithInfoDic:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [self.discountCouponArray removeAllObjects];
    NSArray *dataList = [successInfo objectForKey:@"data"];
    for (NSDictionary *infoDic in dataList) {
        [self.discountCouponArray addObject:infoDic];
    }
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestDiscountCouponSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestDiscountCouponFailed:failInfo];
    }
}

@end
