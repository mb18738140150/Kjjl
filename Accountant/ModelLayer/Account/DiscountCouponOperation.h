//
//  DiscountCouponOperation.h
//  Accountant
//
//  Created by aaa on 2017/12/19.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "DiscountCouponModel.h"
@interface DiscountCouponOperation : NSObject

@property (nonatomic, strong)NSMutableArray *discountCouponArray;

- (void)didRequestDiscountCouponWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_discountCouponProtocol>)object;

@end
