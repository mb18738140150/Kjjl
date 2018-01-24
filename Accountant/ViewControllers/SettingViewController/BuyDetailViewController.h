//
//  BuyDetailViewController.h
//  Accountant
//
//  Created by aaa on 2017/11/21.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PayCourseType_Course=1,
    PayCourseType_Member=5,
    PayCourseType_LivingCourse=6
} PayCourseType;

@interface BuyDetailViewController : UIViewController

@property (nonatomic, strong)NSDictionary *infoDic;
@property (nonatomic, assign)PayCourseType payCourseType;

@end
