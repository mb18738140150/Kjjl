//
//  MainViewMacro.h
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#ifndef MainViewMacro_h
#define MainViewMacro_h

#import "UIMacro.h"

#define kCellHeightOfBanner (kScreenWidth/3)
#define kCellHeightOfCategoryImage 60
#define kCellHeightOfCategoryView 70
#define kCellWidthOfCategoryImage 40
#define kCellHeightOfCourseTitle 40

#define kCellEdgeOfCourseImage 10

#define kImageWidthOfCourse (kScreenWidth/2 - 2*kCellEdgeOfCourseImage)
#define kImageWidthOfCourseOfVideo ((kScreenWidth - 100)/2 - 2*kCellEdgeOfCourseImage)

#define kImageHeightOfCourse (kImageWidthOfCourse/14*8)
#define kImageHeightOfCourseOfVideo (kImageWidthOfCourseOfVideo/14*8)

#define kCellHeightOfCourse (kImageHeightOfCourse + 50)
#define kCellHeightOfCourseOfVideo (kImageHeightOfCourseOfVideo + 50)

#endif /* MainViewMacro_h */
