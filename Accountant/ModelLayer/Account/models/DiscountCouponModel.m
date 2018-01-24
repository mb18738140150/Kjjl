//
//  DiscountCouponModel.m
//  Accountant
//
//  Created by aaa on 2017/12/19.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DiscountCouponModel.h"

@implementation DiscountCouponModel

- (instancetype)initWithDictionery:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    NSLog(@"UndefinedKey = %@", key);
}

@end
