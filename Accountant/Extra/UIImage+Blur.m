//
//  UIImage+Blur.m
//  Accountant
//
//  Created by aaa on 2017/3/2.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "UIImage+Blur.h"
#import <Accelerate/Accelerate.h>

#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )
#define A(x) ( Mask8(x >> 24) )
#define RGBMake(r,g,b,a)(Mask8(r) | Mask8(g) << 8 | Mask8(b) << 16 | Mask8(a) << 24)

@implementation UIImage (Blur)

- (UIImage *)coreBlurWithBlurNumber:(CGFloat)blur
{
/*    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage= [CIImage imageWithCGImage:self.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey]; [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;*/
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = self.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate( outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
}

+(UIImage *)imageGray:(UIImage *)image andRGBValue:(unsigned int)value
{
    CGImageRef cgImage = image.CGImage;
    NSUInteger width = CGImageGetWidth(cgImage);
    NSUInteger height = CGImageGetHeight(cgImage);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    uint32_t*inputPixels = (uint32_t *)calloc(width * height, sizeof(UInt32));
    CGContextRef context = CGBitmapContextCreate(inputPixels, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
    
    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            UInt32 *currentPixel = inputPixels + (i * width) + j;
            UInt32 color = *currentPixel;
            UInt32 thisR ,thisG, thisB ,thisA;
            thisR = R(color);
            thisR = value;
            thisB = B(color);
            thisB = 121;
            thisG = G(color);
            thisG = 121;
            thisA = A(color);
            *currentPixel = RGBMake(thisR, thisG, thisB, thisA);
        }
    }
    
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage * newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CGImageRelease(newImageRef);
    free(inputPixels);
    
    return newImage;
}

@end
