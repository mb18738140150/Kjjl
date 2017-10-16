//
//  UIImage+Blur.h
//  Accountant
//
//  Created by aaa on 2017/3/2.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Blur)

- (UIImage *)coreBlurWithBlurNumber:(CGFloat)blur;

+(UIImage *)imageGray:(UIImage *)image andRGBValue:(unsigned int)value;

@end
