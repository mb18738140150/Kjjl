//
//  AllCategoryTableViewCell.m
//  Accountant
//
//  Created by 阴天翔 on 2017/3/9.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "AllCategoryTableViewCell.h"
#import "UIMacro.h"
#import "CommonMacro.h"
#import "NotificaitonMacro.h"

@implementation AllCategoryTableViewCell

- (void)resetOneCellContent:(NSArray *)array
{
    [self.firstButton removeFromSuperview];
    [self.secButton removeFromSuperview];
    [self.lineView removeFromSuperview];
    
    self.courseInfoArray = array;
    
    NSDictionary *firstInfo = [array objectAtIndex:0];
    
    self.firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.firstButton.frame = CGRectMake(0, 0, kScreenWidth/2, 40);
    [self.firstButton setTitle:[firstInfo objectForKey:kCourseName] forState:UIControlStateNormal];
    [self.firstButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.firstButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.firstButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2, 5, 1, 30)];
    self.lineView.backgroundColor = kTableViewCellSeparatorColor;
    [self.firstButton addTarget:self action:@selector(tap1Click) forControlEvents:UIControlEventTouchUpInside];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2, 5, 1, 30)];
    self.lineView.backgroundColor = kTableViewCellSeparatorColor;
    
    [self addSubview:self.lineView];
    
    [self addSubview:self.firstButton];
}

- (void)resetTwoCellContent:(NSArray *)array
{
    [self.firstButton removeFromSuperview];
    [self.secButton removeFromSuperview];
    [self.lineView removeFromSuperview];
    
    self.courseInfoArray = array;
    
    NSDictionary *firstInfo = [array objectAtIndex:0];
    NSDictionary *secInfo = [array objectAtIndex:1];
    
    self.firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.firstButton.frame = CGRectMake(0, 0, kScreenWidth/2, 40);
    [self.firstButton setTitle:[firstInfo objectForKey:kCourseName] forState:UIControlStateNormal];
    [self.firstButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.firstButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.firstButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.firstButton addTarget:self action:@selector(tap1Click) forControlEvents:UIControlEventTouchUpInside];
    
    self.secButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.secButton.frame = CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, 40);
    [self.secButton setTitle:[secInfo objectForKey:kCourseName] forState:UIControlStateNormal];
    [self.secButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.secButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.secButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.secButton addTarget:self action:@selector(tap2Click) forControlEvents:UIControlEventTouchUpInside];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2, 5, 1, 30)];
    self.lineView.backgroundColor = kTableViewCellSeparatorColor;
    
    [self addSubview:self.lineView];
    [self addSubview:self.firstButton];
    [self addSubview:self.secButton];
}

- (void)tap1Click
{
    NSDictionary *firstInfo = [self.courseInfoArray objectAtIndex:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfCourseClick object:firstInfo];
}

- (void)tap2Click
{
    NSDictionary *firstInfo = [self.courseInfoArray  objectAtIndex:1];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfCourseClick object:firstInfo];
}

@end
