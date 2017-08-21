//
//  MainBottomTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/6/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "MainBottomTableViewCell.h"

@implementation MainBottomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetInfo{
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    
    self.liveLB = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - 35, 15, 70, 20)];
    self.liveLB.text = @"更多课程";
    self.liveLB.font = kMainFont;
    self.liveLB.textColor = kCommonMainTextColor_100;
    self.liveLB.textAlignment = 1;
    self.liveLB.userInteractionEnabled = YES;
    [bottomView addSubview:self.liveLB];
    
    self.goImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.liveLB.frame), 18, 15, 14)];
    self.goImageView.image = [UIImage imageNamed:@"shouye-trankle"];
    [bottomView addSubview:self.goImageView];
    self.goImageView.userInteractionEnabled = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
