//
//  UIMacro.h
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#ifndef UIMacro_h
#define UIMacro_h

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


#define kNavigationBarHeight 44
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)

#define UIRGBColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kCommonMainOringeColor UIRGBColor(245.0,104.0,6.0)
#define kCommonMainColor UIRGBColor(20.0,120.0,210.0)
//#define kCommonNavigationBarColor UIRGBColor(20.0,120.0,210.0)
#define kCommonNavigationBarColor UIRGBColor(255.0,255.0,255.0)
#define kTableViewCellSeparatorColor UIRGBColor(220,220,220)
#define kBackgroundGrayColor UIRGBColor(240,240,240)
#define kMainTextColor UIRGBColor(50,50,50)
#define kMainTextColor_100 UIRGBColor(100,100,100)
#define kMainFont [UIFont systemFontOfSize:14]
#define kUILABEL_LINE_SPACE 5

#define kCommonMainTextColor_50 [UIColor colorWithWhite:0.2 alpha:1]
#define kCommonMainTextColor_100 [UIColor colorWithWhite:0.4 alpha:1]
#define kCommonMainTextColor_150 [UIColor colorWithWhite:0.6 alpha:1]
#define kCommonMainTextColor_200 [UIColor colorWithWhite:0.8 alpha:1]

#endif /* UIMacro_h */
