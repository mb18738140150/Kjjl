//
//  MemberCourse.m
//  Accountant
//
//  Created by aaa on 2017/11/9.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "MemberCourse.h"

@interface MemberCourse ()
@property (nonatomic, strong)UILabel * titleLB;
@end

@implementation MemberCourse

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUI:title];
    }
    return self;
}

- (void)prepareUI:(NSString *)title
{
    self.backgroundColor = [UIColor whiteColor];
    CAShapeLayer * layer = [[CAShapeLayer alloc]init];
    layer.frame = self.bounds;
    
    UIBezierPath *bezier = [UIBezierPath bezierPath];
    bezier.lineWidth = 1;
    [bezier moveToPoint:CGPointMake(0, 0)];
    [bezier addLineToPoint:CGPointMake(0, self.hd_height)];
    [bezier addLineToPoint:CGPointMake(self.hd_width, self.hd_height)];
    [bezier addLineToPoint:CGPointMake(self.hd_width, 0)];
    
    layer.path = bezier.CGPath;
    layer.strokeColor = UIColorFromRGB(0xcccccc).CGColor;
    layer.fillColor = [UIColor whiteColor].CGColor;
    
    [self.layer addSublayer:layer];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(self.hd_centerX - 20, self.hd_height / 2 - 30, 20, 60)];
    self.titleLB.text = title;
    self.titleLB.numberOfLines = 0;
    self.titleLB.font = [UIFont systemFontOfSize:12];
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.textAlignment = 1;
    [self addSubview:self.titleLB];
}

@end
