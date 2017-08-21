//
//  CoursecategoryTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/4/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "CoursecategoryTableViewCell.h"
#import "CommonMacro.h"
#import "UIImageView+AFNetworking.h"
#import "UIUtility.h"
#import "UIMacro.h"
#import "DelayButton+helper.h"

@implementation CoursecategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetCellContent:(NSDictionary *)courseInfo
{
    
    [self removeAllSubviews];
    
    self.backgroundColor = [UIColor colorWithWhite:.98 alpha:1];
    
    // 课程icon
    self.courseCoverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 120, 80)];
    [self.courseCoverImageView setImageWithURL:[NSURL URLWithString:[courseInfo objectForKey:kCourseCover]]];
    [self addSubview:self.courseCoverImageView];
    
    CGFloat courseChapterNameLabelWidth = [UIUtility getWidthWithText:[courseInfo objectForKey:kCourseSecondName] font:[UIFont systemFontOfSize:11] height:15];
    // 课程分类
    self.courseChapterNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.courseCoverImageView.frame) - courseChapterNameLabelWidth, 10, courseChapterNameLabelWidth, 15)];
    self.courseChapterNameLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.courseChapterNameLabel.textColor = [UIColor whiteColor];
    self.courseChapterNameLabel.text = [courseInfo objectForKey:kCourseSecondName];
    self.courseChapterNameLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:self.courseChapterNameLabel];
    
    // 蒙版
    self.maskView = [[UIView alloc]initWithFrame:self.courseCoverImageView.frame];
    self.maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [self addSubview:self.maskView];
    
    // 状态按钮
    self.stateBT = [DelayButton buttonWithType:UIButtonTypeCustom];
    self.stateBT.frame = CGRectMake(self.maskView.hd_centerX - 10, 10, 20, 20);
    self.stateBT.clickDurationTime = 1;
    [self.stateBT setImage:[UIImage imageNamed:@"download-pause"] forState:UIControlStateNormal];
    [self.stateBT setImage:[UIImage imageNamed:@"download-play"] forState:UIControlStateSelected];
    [self addSubview:self.stateBT];
    [self.stateBT addTarget:self action:@selector(downStateAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 进度条
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(self.maskView.hd_x + 15, self.maskView.hd_centerY - 2, self.maskView.hd_width - 30, 4)];
    self.progressView.progress = 0;
    [self addSubview:self.progressView];
    // 进度
    self.progresslabel = [[UILabel alloc]initWithFrame:CGRectMake(self.maskView.hd_x, self.maskView.hd_centerY + 5, self.maskView.hd_width, 15)];
    self.progresslabel.textColor = [UIColor whiteColor];
    self.progresslabel.font = kMainFont;
    self.progresslabel.textAlignment = 1;
    [self addSubview:self.progresslabel];
    
    // 课程名称
    CGFloat height = [UIUtility getHeightWithText:[courseInfo objectForKey:kCourseName] font:kMainFont width:kScreenWidth - (self.courseCoverImageView.frame.origin.x + self.courseCoverImageView.frame.size.width + 20) - 20];
    self.courseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.courseCoverImageView.frame.origin.x + self.courseCoverImageView.frame.size.width + 20, 20, kScreenWidth -(self.courseCoverImageView.frame.origin.x + self.courseCoverImageView.frame.size.width + 20) - 20 , height  + 5)];
    self.courseNameLabel.text = [courseInfo objectForKey:kCourseName];
    self.courseNameLabel.font = kMainFont;
    self.courseNameLabel.numberOfLines = 0;
    self.courseNameLabel.textColor = kMainTextColor;
    [self addSubview:self.courseNameLabel];
    
    
    // 讲师
    self.teacherIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.courseCoverImageView.frame) + 20, 73, 14, 14)];
    self.teacherIconImageView.image = [UIImage imageNamed:@"shouye-人"];
    [self addSubview:self.teacherIconImageView];
    
    self.teacherNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.teacherIconImageView.frame) + 5, 70, 60, 20)];
    self.teacherNameLabel.font = [UIFont systemFontOfSize:14];
    self.teacherNameLabel.textColor = [UIColor grayColor];
    self.teacherNameLabel.text = [courseInfo objectForKey:kCourseTeacherName];
    [self addSubview:self.teacherNameLabel];
    
    // 章节
    self.countImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.teacherNameLabel.frame) + 20, 73, 14, 14)];
    self.countImageView.image = [UIImage imageNamed:@"course-章节"];
//    [self addSubview:self.countImageView];
    
    self.courseCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.countImageView.frame) + 5, 70, 100, 20)];
    self.courseCountLabel.font = [UIFont systemFontOfSize:14];
    self.courseCountLabel.textColor = [UIColor grayColor];
//    self.courseCountLabel.text = [courseInfo objectForKey:kCourseTeacherName];
//    [self addSubview:self.courseCountLabel];
    
    // 分割线
    self.seperateLine = [[UIView alloc]initWithFrame:CGRectMake(self.courseCoverImageView.hd_x, 99, kScreenWidth - 20, 1)];
    self.seperateLine.backgroundColor = kCommonMainTextColor_200;
    [self addSubview:self.seperateLine];
    
    switch (self.courseType) {
        case CourseCategoryType_hot:
            [self resetHotCell:courseInfo];
            break;
        case CourseCategoryType_nomal:
            [self resetNomalCell:courseInfo];
            break;
        case CourseCategoryType_downLoading:
            [self resetDownloadingCell:courseInfo];
            break;
        default:
            break;
    }
}

- (void)downStateAction:(UIButton *)button
{
    button.selected = !button.selected;
    if (self.DownStateBlock) {
        self.DownStateBlock(button.selected);
    }
}

- (void)resetHotCell:(NSDictionary *)infoDic
{
    [self hiddenMask];
    
    self.courseChapterNameLabel.frame = CGRectMake(CGRectGetMaxX(self.courseCoverImageView.frame) + 20, 50, self.courseChapterNameLabel.hd_width, 15);
    self.courseChapterNameLabel.backgroundColor = [UIColor whiteColor];
    self.courseChapterNameLabel.layer.cornerRadius = self.courseChapterNameLabel.hd_height / 2;
    self.courseChapterNameLabel.layer.masksToBounds = YES;
    self.courseChapterNameLabel.layer.borderWidth = 1;
    self.courseChapterNameLabel.layer.borderColor = [UIColor purpleColor].CGColor;
}

- (void)resetNomalCell:(NSDictionary *)infoDic
{
    [self hiddenMask];
    
    self.seperateLine.frame = CGRectMake(0, 99, kScreenWidth, 1);
}

- (void)resetDownloadingCell:(NSDictionary *)infoDic
{
    self.seperateLine.frame = CGRectMake(0, 99, kScreenWidth, 1);
}

- (void)hiddenMask
{
    self.maskView.hidden = YES;
    self.progresslabel.hidden = YES;
    self.progressView.hidden = YES;
    self.stateBT.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
