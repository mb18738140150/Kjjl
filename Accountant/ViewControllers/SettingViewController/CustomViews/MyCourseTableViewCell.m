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
    self.teacherIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.courseCoverImageView.frame) + 12, 73, 11, 11)];
    self.teacherIconImageView.image = [UIImage imageNamed:@"shouye-人"];
    [self.contentView addSubview:self.teacherIconImageView];
    
    self.teacherNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.teacherIconImageView.frame) + 5, 70, 60, 20)];
    self.teacherNameLabel.font = [UIFont systemFontOfSize:11];
    self.teacherNameLabel.textColor = [UIColor grayColor];
    self.teacherNameLabel.text = [NSString stringWithFormat:@"%@", [courseInfo objectForKey:kCourseTeacherName]];
    [self.contentView addSubview:self.teacherNameLabel];
    
    // 上次学习时间
    self.lastTimeLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.courseCoverImageView.frame) + 10, self.courseCoverImageView.hd_centerY + 5, 200, 15)];
    self.lastTimeLB.textColor = UIColorFromRGB(0xaaaaaa);
    self.lastTimeLB.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.lastTimeLB];
    
    // 进度
    
    self.learnProcessView = [[ProcessView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.courseCoverImageView.frame) + 10, self.frame.size.height - 13, 115, 5)];
    self.learnProcessView.progress = 0.8;
    [self.contentView addSubview:self.learnProcessView];
    
    self.progresslabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.learnProcessView.frame) + 10, self.learnProcessView.hd_y - 5, 80, 15)];
    self.progresslabel.textColor = UIColorFromRGB(0xff4e00);
    self.progresslabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:self.progresslabel];
    
    self.courseStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.courseCoverImageView.frame) + 10, 70, 60, 20)];
    self.courseStateLabel.text = @"已学完";
    self.courseStateLabel.font = [UIFont systemFontOfSize:11];
    self.courseStateLabel.textColor = UIColorFromRGB(0xaaaaaa);
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
    self.lastTimeLB.hidden = YES;
    self.progresslabel.hidden = YES;
    self.learnProcessView.hidden = YES;
}

- (void)resetLearning:(NSDictionary *)infoDic
{
    self.teacherNameLabel.hidden = YES;
    self.teacherIconImageView.hidden = YES;
    self.courseStateLabel.hidden = YES;
    
    self.learnProcessView.progress = [[self.infoDic objectForKey:kLearnProgress] doubleValue];
    self.progresslabel.text = [NSString stringWithFormat:@"已学%.0f%%", [[self.infoDic objectForKey:kLearnProgress] doubleValue] * 100];
    self.lastTimeLB.text = [self.infoDic objectForKey:kLivingTime];
}

- (void)resetCollection:(NSDictionary *)infoDic
{
    self.lastTimeLB.hidden = YES;
    self.progresslabel.hidden = YES;
    self.learnProcessView.hidden = YES;
    self.courseStateLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
