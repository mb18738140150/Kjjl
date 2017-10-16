//
//  LivingCourseCollectionViewCell.m
//  Accountant
//
//  Created by aaa on 2017/9/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "LivingCourseCollectionViewCell.h"

@implementation LivingCourseCollectionViewCell

- (void)resetInfo:(NSDictionary *)infoDic
{
    [self.contentView removeAllSubviews];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, self.hd_width - 15, self.hd_height)];
    [self.contentView addSubview:self.imageView];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[infoDic objectForKey:kCourseCover]] placeholderImage:[UIImage imageNamed:@"course-pic1"]];
}

- (void)resetTitleWith:(NSString *)title
{
    [self.contentView removeAllSubviews];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, self.hd_height)];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.text = title;
    self.titleLabel.textColor = kCommonMainTextColor_50;
}

- (void)refreshTitletextColorWith:(UIColor *)color
{
    self.titleLabel.textColor = color;
}

@end
