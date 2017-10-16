//
//  CourseTitleTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseTitleTableViewCell : UITableViewCell

@property (nonatomic, assign)BOOL nCourse;
- (void)resetSubviewsWithTitle:(NSString *)title;
- (void)resetSubviewsWithTitle:(NSString *)title withNCourse:(BOOL)nCourse;

@end
