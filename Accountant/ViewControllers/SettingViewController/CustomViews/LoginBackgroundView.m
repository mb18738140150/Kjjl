//
//  LoginBackgroundView.m
//  LoginTest
//
//  Created by aaa on 2017/3/1.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "LoginBackgroundView.h"

@implementation LoginBackgroundView


//- (void)drawRect:(CGRect)rect {
//    CGContextRef context1=UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context1,3);
//    CGContextBeginPath(context1);
//    CGContextMoveToPoint(context1, 5, 0);
//    CGContextAddLineToPoint(context1,self.frame.size.width-5, 0);
//    CGContextClosePath(context1);
//    [[UIColor grayColor] setStroke];
//    CGContextStrokePath(context1);
//    
//    CGContextRef context=UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context,0.2);
//    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, 5, 50);
//    CGContextAddLineToPoint(context,self.frame.size.width-5, 50);
//    CGContextClosePath(context);
//    [[UIColor grayColor] setStroke];
//    CGContextStrokePath(context);
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        self.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.layer.shadowOffset = CGSizeMake(20, 20);
//        self.layer.shadowOpacity = 1;
//        self.layer.shadowRadius = 10;
    }
    return self;
}


@end
