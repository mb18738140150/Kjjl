//
//  AcquireDiscountCouponSuccess.h
//  Accountant
//
//  Created by aaa on 2018/4/8.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"
@interface AcquireDiscountCouponSuccess : NSObject<HttpRequestProtocol>

@property (nonatomic, strong)NSMutableArray *discountCouponArray;

- (void)didRequestAcquireDiscountCouponSuccessWithCourseInfo:(NSDictionary * )infoDic ;

@end
