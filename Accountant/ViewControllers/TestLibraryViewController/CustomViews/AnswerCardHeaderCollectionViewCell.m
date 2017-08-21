//
//  AnswerCardHeaderCollectionViewCell.m
//  Accountant
//
//  Created by aaa on 2017/3/30.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "AnswerCardHeaderCollectionViewCell.h"
#import "UIMacro.h"

@implementation AnswerCardHeaderCollectionViewCell

- (void)resetTitleLabel
{
    [self.titleLabel removeFromSuperview];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    self.titleLabel.text = @"答题卡";
    self.titleLabel.font = [UIFont systemFontOfSize:20];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = kCommonNavigationBarColor;
    [self addSubview:self.titleLabel];
}

@end
