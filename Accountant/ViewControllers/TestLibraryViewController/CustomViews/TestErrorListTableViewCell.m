//
//  TestErrorListTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/3/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestErrorListTableViewCell.h"
#import "UIMacro.h"
#import "CommonMacro.h"

@implementation TestErrorListTableViewCell

- (void)resetContentWithInfo:(NSDictionary *)info
{
    [self.circleView removeFromSuperview];
    [self.titleLabel removeFromSuperview];
    [self.detailLabel removeFromSuperview];
    
    self.circleView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 10, 10)];
    self.circleView.backgroundColor = kCommonNavigationBarColor;
    self.circleView.layer.cornerRadius = 5;
    [self addSubview:self.circleView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, kScreenWidth - 120, 50)];
    self.titleLabel.text = [info objectForKey:kTestChapterName];
    [self addSubview:self.titleLabel];
    
    self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 60, 0, 60, 50)];
    self.detailLabel.text = [NSString stringWithFormat:@"%@", [info objectForKey:kTestChapterQuestionCount]];
    self.detailLabel.textColor = kTableViewCellSeparatorColor;
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    self.detailLabel.font = kMainFont;
    [self addSubview:self.detailLabel];
}

@end
