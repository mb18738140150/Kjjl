//
//  LivingCourseDetailButton+category.m
//  Accountant
//
//  Created by aaa on 2018/5/8.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "LivingCourseDetailButton+category.h"

@implementation LivingCourseDetailButton (category)

- (void)resetDownload
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setTitle:@"下载" forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    });
}

- (void)resetPay
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setImage:[UIImage imageNamed:@"icon_buy"] forState:UIControlStateNormal];
        [self setTitle:@"购买" forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        self.backgroundColor = UIRGBColor(255, 152, 2);
    });
}

@end
