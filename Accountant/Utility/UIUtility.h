//
//  UIUtility.h
//  Accountant
//
//  Created by aaa on 2017/3/3.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIUtility : NSObject

+ (UITableViewCell *)getCellWithCellName:(NSString *)reuseName inTableView:(UITableView *)table andCellClass:(Class)cellClass;

+ (CGFloat)getHeightWithText:(NSString *)content font:(UIFont *)textFont width:(CGFloat)width;

+ (CGFloat)getWidthWithText:(NSString *)content font:(UIFont *)textFont height:(CGFloat)height;

+ (CGFloat)getSpaceLabelHeght:(NSString *)content font:(UIFont *)font width:(CGFloat)width;

+ (NSAttributedString *)getSpaceLabelStr:(NSString *)content withFont:(UIFont *)font color:(UIColor *)color;

+ (NSAttributedString *)getSpaceLabelStr:(NSString *)content withFont:(UIFont *)font;

+ (NSAttributedString *)getSpaceLabelStr:(NSString *)content withFont:(UIFont *)font withAlignment:(NSTextAlignment)aligment;

+ (NSAttributedString *)getSpaceLabelStr:(NSString *)content withFont:(UIFont *)font withFirstLineHeadIndent:(CGFloat)headIndent;

+ (NSString *)judgeStr:(id)str;

+ (NSMutableAttributedString *)getLineSpaceLabelStr:(NSMutableAttributedString *)content withFont:(UIFont *)font;

+ (CGFloat)getLineSpaceLabelHeght:(NSString *)content font:(UIFont *)font width:(CGFloat)width;

+ (void)codefileData:(NSString *)filePath;

@end
