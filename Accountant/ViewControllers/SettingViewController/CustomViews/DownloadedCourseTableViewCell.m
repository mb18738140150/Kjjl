//
//  DownloadedCourseTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/3/10.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DownloadedCourseTableViewCell.h"
#import "CommonMacro.h"
#import "UIImageView+AFNetworking.h"

@implementation DownloadedCourseTableViewCell

- (void)resetCellContent:(NSDictionary *)courseInfo
{
    [self.courseNameLabel removeFromSuperview];
    [self.courseCountLabel removeFromSuperview];
    [self.courseCoverImageView removeFromSuperview];
    
    self.courseCoverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 120, 80)];
    [self.courseCoverImageView setImageWithURL:[NSURL URLWithString:[courseInfo objectForKey:kCourseCover]]];
    [self addSubview:self.courseCoverImageView];
    
    self.courseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.courseCoverImageView.frame.origin.x + self.courseCoverImageView.frame.size.width + 20, 20, 200, 40)];
    self.courseNameLabel.text = [courseInfo objectForKey:kCourseName];
    [self addSubview:self.courseNameLabel];
    
    self.courseCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.courseCoverImageView.frame.origin.x + self.courseCoverImageView.frame.size.width + 20, 80, 100, 20)];
    self.courseCountLabel.font = [UIFont systemFontOfSize:14];
    self.courseCountLabel.textColor = [UIColor grayColor];
    self.courseCountLabel.text = @"0 个视频";
    [self addSubview:self.courseCountLabel];
}

@end
