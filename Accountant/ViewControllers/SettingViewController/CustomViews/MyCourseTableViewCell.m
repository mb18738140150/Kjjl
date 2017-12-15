//
//  MyCourseTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/12/1.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "MyCourseTableViewCell.h"
#import "CommonMacro.h"
#import "UIImageView+AFNetworking.h"
#import "UIUtility.h"
#import "UIMacro.h"
#import "DelayButton+helper.h"
@implementation MyCourseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetCellContent:(NSDictionary *)courseInfo
{
    self.infoDic = courseInfo;
    [self.contentView removeAllSubviews];
    
    self.backgroundColor = [UIColor colorWithWhite:.98 alpha:1];
    
    // 课程icon
    self.courseCoverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 120, 80)];
    [self.courseCoverImageView setImageWithURL:[NSURL URLWithString:[courseInfo objectForKey:kCourseCover]]];
    [self.contentView addSubview:self.courseCoverImageView];

    // 课程名称
    CGFloat height = [UIUtility getHeightWithText:[courseInfo objectForKey:kCourseName] font:kMainFont width:kScreenWidth - (self.courseCoverImageView.frame.origin.x + self.courseCoverImageView.frame.size.width + 20) - 20];
    self.courseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.courseCoverImageView.frame.origin.x + self.courseCoverImageView.frame.size.width + 10, 20, kScreenWidth -(self.courseCoverImageView.frame.origin.x + self.courseCoverImageView.frame.size.width + 20) - 20 , height  + 5)];
    self.courseNameLabel.text = [courseInfo objectForKey:kCourseName];
    self.courseNameLabel.font = kMainFont;
    self.courseNameLabel.numberOfLines = 0;
    self.courseNameLabel.textColor = kMainTextColor;
    [self.contentView addSubview:self.courseNameLabel];
    
    // 讲师
    self.teacherIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.courseCoverImageView.frame) + 10, 73, 14, 14)];
    self.teacherIconImageView.image = [UIImage imageNamed:@"shouye-人"];
    [self.contentView addSubview:self.teacherIconImageView];
    
    self.teacherNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.teacherIconImageView.frame) + 5, 70, 60, 20)];
    self.teacherNameLabel.font = [UIFont systemFontOfSize:14];
    self.teacherNameLabel.textColor = [UIColor grayColor];
    self.teacherNameLabel.text = [courseInfo objectForKey:kCourseTeacherName];
    [self.contentView addSubview:self.teacherNameLabel];
    
    // 进度
    self.progresslabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.courseCoverImageView.frame) + 10, self.maskView.hd_centerY + 5, self.maskView.hd_width, 15)];
    self.progresslabel.textColor = [UIColor whiteColor];
    self.progresslabel.font = kMainFont;
    self.progresslabel.textAlignment = 1;
    [self.contentView addSubview:self.progresslabel];
    
    self.learnProcessView = [[ProcessView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.courseCoverImageView.frame) + 10, self.frame.size.height - 13, 230, 5)];
    self.learnProcessView.progress = 0.8;
    [self.contentView addSubview:self.learnProcessView];
    
    
    self.courseStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.courseCoverImageView.frame) + 10, 70, 60, 20)];
    self.courseStateLabel.text = @"已学完";
    [self.contentView addSubview:self.courseStateLabel];
    
    // 删除
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteBtn.frame = CGRectMake(kScreenWidth - 37, 70, 20, 20);
    [self.deleteBtn setImage:[UIImage imageNamed:@"icon_sc"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.deleteBtn];
    [self.deleteBtn addTarget:self action:@selector(deleteCourseAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 分割线
    self.seperateLine = [[UIView alloc]initWithFrame:CGRectMake(self.courseCoverImageView.hd_x, 99, kScreenWidth - 20, 1)];
    self.seperateLine.backgroundColor = kCommonMainTextColor_200;
    [self.contentView addSubview:self.seperateLine];
    
    switch (self.myCourseType) {
        case MyCourseCategoryType_complate:
            [self resetComplate:courseInfo];
            break;
        case MyCourseCategoryType_learning:
            [self resetLearning:courseInfo];
            break;
        case MyCourseCategoryType_collection:
            [self resetCollection:courseInfo];
            break;
        default:
            break;
    }
}

- (void)deleteCourseAction:(UIButton *)button
{
    if (self.DeleteCourseBlock) {
        self.DeleteCourseBlock(self.infoDic,self.myCourseType);
    }
}

- (void)resetComplate:(NSDictionary *)infoDic
{
    self.teacherNameLabel.hidden = YES;
    self.teacherIconImageView.hidden = YES;
    
    self.progresslabel.hidden = YES;
    self.learnProcessView.hidden = YES;
}

- (void)resetLearning:(NSDictionary *)infoDic
{
    self.teacherNameLabel.hidden = YES;
    self.teacherIconImageView.hidden = YES;
    self.courseStateLabel.hidden = YES;
}

- (void)resetCollection:(NSDictionary *)infoDic
{
    self.progresslabel.hidden = YES;
    self.learnProcessView.hidden = YES;
    self.courseStateLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
