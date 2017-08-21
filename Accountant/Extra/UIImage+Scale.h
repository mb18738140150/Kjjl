//
//  UIImage+Scale.h
//  Accountant
//
//  Created by aaa on 2017/3/2.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

+ (CGFloat)imageGetHeight:(UIImage *)image;

@end
