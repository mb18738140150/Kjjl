//
//  DiscountCouponViewController.h
//  Accountant
//
//  Created by aaa on 2017/12/4.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscountCouponViewController : UIViewController

@property (nonatomic, copy)void(^selectDiscountCouponBlock)(NSDictionary * infoDic);
@property (nonatomic, assign)double  price;
@property (nonatomic, assign)BOOL myDscountCoupon;

@end
