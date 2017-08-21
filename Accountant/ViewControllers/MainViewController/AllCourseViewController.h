//
//  AllCourseViewController.h
//  Accountant
//
//  Created by aaa on 2017/3/1.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    IntoPageTypeAllCourse,
    IntoPageTypeCategoryCourse
}IntoPageType;

@interface AllCourseViewController : UIViewController

@property (nonatomic,assign) int                         courseCategoryId;

@property (nonatomic,assign) IntoPageType                intoType;

@property (nonatomic,strong) NSString                   *categoryName;

@end
