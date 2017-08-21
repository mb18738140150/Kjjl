//
//  SectionListTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/3/23.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "SectionListTableViewCell.h"
#import "UIMacro.h"
#import "CommonMacro.h"

@implementation SectionListTableViewCell

- (void)resetTitleStr:(NSDictionary *)info
{
    [self.lineView removeFromSuperview];
    [self.circleView removeFromSuperview];
    [self.titleLabel removeFromSuperview];
    [self.detailLabel removeFromSuperview];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(25, 0, 1, 50)];
    self.lineView.backgroundColor = kTableViewCellSeparatorColor;
    [self addSubview:self.lineView];
    
    self.circleView = [[UIView alloc] initWithFrame:CGRectMake(22.5, 20, 6, 6)];
    self.circleView.backgroundColor = kTableViewCellSeparatorColor;
    self.circleView.layer.cornerRadius = 3;
    [self addSubview:self.circleView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, kScreenWidth-110, 50)];
    self.titleLabel.text = [info objectForKey:kTestSectionName];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.titleLabel];
    
    self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 60, 0, 60, 50)];
    self.detailLabel.text = [NSString stringWithFormat:@"%@", [info objectForKey:kTestSectionQuestionCount]];
    self.detailLabel.textColor = kTableViewCellSeparatorColor;
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    self.detailLabel.font = kMainFont;
    [self addSubview:self.detailLabel];
}

@end
