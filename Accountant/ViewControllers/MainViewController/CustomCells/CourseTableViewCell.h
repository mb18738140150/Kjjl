//
//  CourseTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseTableViewCell : UITableViewCell

- (void)resetCellContentWithTwoCourseInfo:(NSArray *)infoArray;

- (void)resetCellContentWithOneCourseInfo:(NSArray *)infoArray;

@end
