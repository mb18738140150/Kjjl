//
//  MemberCoursePriceView.m
//  Accountant
//
//  Created by aaa on 2017/11/9.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "MemberCoursePriceView.h"

@interface MemberCoursePriceView ()

@property (nonatomic ,strong)UIImageView * imageView;
@property (nonatomic, strong)UILabel * titleLB;

@end

@implementation MemberCoursePriceView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
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
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.hd_width / 2 - 10, self.hd_height / 2 - 10, 20, 20)];
    self.imageView.image = [UIImage imageNamed:@"icon_Right@3x"];
    [self addSubview:self.imageView];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, self.hd_height - 1)];
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.textAlignment = 1;
    self.titleLB.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.titleLB];
    
}

- (void)resetWithTitle:(NSString *)title
{
    self.imageView.hidden = YES;
    self.titleLB.text = title;
}
- (void)resetWithImage:(UIImage *)image
{
    self.titleLB.hidden = YES;
    self.imageView.image = image;
}
- (void)resetWithImage:(UIImage *)image andTitle:(NSString *)title
{
    self.imageView.image = image;
    self.titleLB.text = title;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.frame = CGRectMake(self.hd_width / 2 - 30, self.hd_height / 2 - 10, 20, 20);
        self.titleLB.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 4, 0, self.hd_width / 2, self.hd_height - 1);
        self.titleLB.textAlignment = 0;
    });
}

@end
