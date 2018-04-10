//
//  AcquireDiscountCouponOperation.h
//  Accountant
//
//  Created by aaa on 2018/3/19.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AcquireDiscountCouponOperation : NSObject

@property (nonatomic, strong)NSMutableArray *discountCouponArray;

- (void)didRequestAcquireDiscountCouponWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_AcquireDiscountCouponProtocol>)object;

@end
