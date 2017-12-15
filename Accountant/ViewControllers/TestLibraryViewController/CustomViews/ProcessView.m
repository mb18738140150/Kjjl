//
//  ProcessView.m
//  tiku
//
//  Created by aaa on 2017/5/9.
//  Copyright © 2017年 ytx. All rights reserved.
//

#import "ProcessView.h"
#import "UIMacro.h"

@implementation ProcessView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = frame.size.height / 2;
        self.layer.masksToBounds = YES;
        
        [self setLayers];
        
    }
    return self;
}

- (void)setLayers
{
    // 先画背景轨道
    CGPoint startP = CGPointMake(0, self.frame.size.height / 2);
    CGPoint endP = CGPointMake(self.frame.size.width, self.frame.size.height / 2);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startP];
    [path addLineToPoint:endP];
    
    CAShapeLayer * layer = [[CAShapeLayer alloc]init];
    layer.frame = self.bounds;
    layer.lineWidth = self.frame.size.height;
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = kCommonMainTextColor_200.CGColor;
    [self.layer addSublayer:layer];
    
    // 渐变进度条
    CALayer *gradientLayer = [CALayer layer];
    gradientLayer.frame = self.bounds;
    
    CAGradientLayer * gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = self.bounds;
    [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[[UIColor blueColor] CGColor],(id)[UIColorFromRGB(0x0fbdff) CGColor], nil]];
    [gradientLayer1 setLocations:@[@0, @0.5, @1]];
    [gradientLayer1 setStartPoint:CGPointMake(0, 0.5)];
    [gradientLayer1 setEndPoint:CGPointMake(1, 0.5)];
    [gradientLayer addSublayer:gradientLayer1];
    
    _processLayer = [[CAShapeLayer alloc] init];
    _processLayer.frame = self.bounds;
    _processLayer.fillColor = [UIColor clearColor].CGColor;
    _processLayer.strokeColor = [UIColor whiteColor].CGColor;
    _processLayer.lineWidth = self.frame.size.height;
    _processLayer.lineCap = kCALineCapRound;
    _processLayer.path = path.CGPath;
    _processLayer.strokeEnd = 0;
    
    [gradientLayer setMask:_processLayer];
    
    [self.layer addSublayer:gradientLayer];
}

-(void)setProgress:(CGFloat)progress{
    
//    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    transformAnimation.duration = 1;
//    transformAnimation.fromValue = @(0);
//    transformAnimation.toValue = @(progress);
//    [_processLayer addAnimation:transformAnimation forKey:nil];
    _processLayer.strokeEnd = progress;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
