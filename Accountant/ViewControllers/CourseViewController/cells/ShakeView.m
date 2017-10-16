//
//  ShakeView.m
//  Accountant
//
//  Created by aaa on 2017/9/21.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "ShakeView.h"

@implementation ShakeView

- (void)prepareUIWithColor:(UIColor *)color
{
    for (int i = 0; i < self.layer.sublayers.count; i++) {
        CALayer * layer = self.layer.sublayers[i];
        [layer removeFromSuperlayer];
    }
    
    //复制层.
    CAReplicatorLayer *repL = [CAReplicatorLayer layer];
    repL.frame = self.bounds;
    
    repL.instanceCount = 4;
    
    repL.instanceTransform = CATransform3DMakeTranslation(self.frame.size.width / 4, 0, 0);
    //设置动画延时执行的时间
    repL.instanceDelay = 0.3;
    
    [self.layer addSublayer:repL];
    
    //创建一个音量震动条
    CALayer *layer = [CALayer layer];
    CGFloat w = self.frame.size.width / 8;
    CGFloat h = self.frame.size.height;
    layer.bounds = CGRectMake(0, 0, w, h);
    layer.backgroundColor = color.CGColor;
    layer.anchorPoint = CGPointMake(0, 1);
    layer.position = CGPointMake(0, self.bounds.size.height);
    [repL addSublayer:layer];
    
    //添加动画
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"transform.scale.y";
    anim.toValue = @0;
    anim.duration = 0.5;
    anim.repeatCount = MAXFLOAT;
    anim.autoreverses = YES;
    
    [layer addAnimation:anim forKey:nil];
}

@end
