//
//  LivingCourseTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/9/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LivingCourseTableViewCell : UITableViewCell

@property (nonatomic, copy)void(^LivingCourseBlock)(NSDictionary *infoDic);
- (void)resetInfoWithArray:(NSArray *)array;

@end
