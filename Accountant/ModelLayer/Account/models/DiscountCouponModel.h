//
//  DiscountCouponModel.h
//  Accountant
//
//  Created by aaa on 2017/12/19.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscountCouponModel : NSObject

@property (nonatomic, strong)NSString * discountCouponID;
@property (nonatomic, strong)NSString * title;
@property (nonatomic, strong)NSString * detail;
@property (nonatomic, strong)NSString * deadLineTime;
@property (nonatomic, assign)double price;
@property (nonatomic, assign)double manPrice;
@property (nonatomic, assign)int useType;

- (instancetype)initWithDictionery:(NSDictionary *)dic;

@end
