//
//  AcquireDiscountCouponSuccess.m
//  Accountant
//
//  Created by aaa on 2018/4/8.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "AcquireDiscountCouponSuccess.h"



@implementation AcquireDiscountCouponSuccess

- (void)didRequestAcquireDiscountCouponSuccessWithCourseInfo:(NSDictionary * )infoDic
{
    [[HttpRequestManager sharedManager] requestAcquireDiscountCouponSuccessWithInfoDic:infoDic andProcessDelegate:nil];
}

@end
