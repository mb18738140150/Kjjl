//
//  StudyPlanHeadTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/12/8.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    StudyPlanHead_infomation,
    StudyPlanHead_derection,
    StudyPlanHead_project,
} StudyPlanHead_progress;


@interface StudyPlanHeadTableViewCell : UITableViewCell

@property (nonatomic, assign)StudyPlanHead_progress progress;

- (void)resetInfo;

@end
