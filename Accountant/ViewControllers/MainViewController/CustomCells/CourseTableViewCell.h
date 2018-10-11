//
//  CourseTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseTableViewCell : UITableViewCell

@property (nonatomic, assign)BOOL isVideoCourse;
@property (nonatomic, assign)BOOL isTaocan;

- (void)resetCellContentWithTwoCourseInfo:(NSArray *)infoArray;

- (void)resetCellContentWithOneCourseInfo:(NSArray *)infoArray;

- (void)resetCellContentWithThreeCourseInfo:(NSArray *)infoArray;
- (void)resetCellContentWithThree_TwoCourseInfo:(NSArray *)infoArray;
- (void)resetCellContentWithThree_OneCourseInfo:(NSArray *)infoArray;

@end
