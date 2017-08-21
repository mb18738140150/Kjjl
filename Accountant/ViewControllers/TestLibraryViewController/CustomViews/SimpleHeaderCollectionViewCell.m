//
//  SimpleHeaderCollectionViewCell.m
//  Accountant
//
//  Created by aaa on 2017/3/21.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "SimpleHeaderCollectionViewCell.h"
#import "UIMacro.h"
#import "CommonMacro.h"


@implementation SimpleHeaderCollectionViewCell

- (void)resetViewWithInfo:(NSString *)dic
{
    self.backgroundColor = [UIColor whiteColor];
    [self.grayView removeFromSuperview];
    [self.categoryLabel removeFromSuperview];
    [self.lineView removeFromSuperview];
    
    
    self.grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    self.grayView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.grayView];
    
    self.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, kScreenWidth, 20)];
    self.categoryLabel.text = dic;
    self.categoryLabel.textColor = kMainTextColor_100;
    [self addSubview:self.categoryLabel];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 59, kScreenWidth - 10, 1)];
    self.lineView.backgroundColor = kTableViewCellSeparatorColor;
//    [self addSubview:self.lineView];
    
    
}

@end
