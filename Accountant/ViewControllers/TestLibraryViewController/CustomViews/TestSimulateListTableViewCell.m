//
//  TestSimulateListTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/3/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestSimulateListTableViewCell.h"
#import "UIMacro.h"
#import "CommonMacro.h"
#import "UIUtility.h"

@implementation TestSimulateListTableViewCell

- (void)resetContentWithInfo:(NSDictionary *)dic withItem:(NSInteger)item
{
    [self.iconImageView removeFromSuperview];
    [self.titleLabel removeFromSuperview];
    [self.totalCountLabel removeFromSuperview];
    [self.startBT removeFromSuperview];
    
    self.backgroundColor = kBackgroundGrayColor;
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 12 , 10, kScreenWidth / 8 * 3, kScreenWidth / 8 * 3 * 1.2)];
    
    if (item % 2 != 0) {
        self.iconImageView.hd_x =kScreenWidth / 24;
    }
    self.iconImageView.image = [UIImage imageNamed:@"tiku_file"];
    
    
    [self addSubview:self.iconImageView];
    
    CGFloat height = [UIUtility getHeightWithText:[dic objectForKey:kTestSimulateName] font:kMainFont width:self.iconImageView.hd_width - 10];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.iconImageView.frame) + 5, self.iconImageView.hd_y + self.iconImageView.hd_height / 3, self.iconImageView.hd_width - 10, height)];
    self.titleLabel.numberOfLines = 10000;
    self.titleLabel.font = kMainFont;
    self.titleLabel.textColor = kMainTextColor_100;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.text = [dic objectForKey:kTestSimulateName];
    [self addSubview:self.titleLabel];
    
    self.totalCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-90, 55, 80, 20)];
    self.totalCountLabel.font = [UIFont systemFontOfSize:15];
    self.totalCountLabel.text = [NSString stringWithFormat:@"共%@道题",[dic objectForKey:kTestSimulateQuestionCount]];
    self.totalCountLabel.textColor = UIRGBColor(180, 180, 180);
    //    [self addSubview:self.totalCountLabel];
    
    
    self.startBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.startBT.frame = CGRectMake(self.iconImageView.hd_x, CGRectGetMaxY(self.iconImageView.frame) + 10, self.iconImageView.hd_width, 30);
    [self.startBT setBackgroundImage:[UIImage imageNamed:@"tiku_圆角矩形-1"] forState:UIControlStateNormal];
    
    [self.startBT setTitle:@"开始做题" forState:UIControlStateNormal];
    self.startBT.titleLabel.font = kMainFont;
    [self.startBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:self.startBT];
    [self.startBT addTarget:self action:@selector(startAnswerClick) forControlEvents:UIControlEventTouchUpInside];
    
    if(IS_PAD)
    {
        self.iconImageView.image = [UIImage imageNamed:@"img_file"];
        self.iconImageView.frame = CGRectMake(self.hd_width * 0.115 , self.hd_height * 0.07, self.hd_width * 0.77, self.hd_height * 0.7);
        CGFloat height1 = [UIUtility getHeightWithText:[dic objectForKey:kTestSimulateName] font:[UIFont systemFontOfSize:17] width:self.iconImageView.hd_width - 10];
        self.titleLabel.frame = CGRectMake(CGRectGetMinX(self.iconImageView.frame) + 5, self.iconImageView.hd_y + self.iconImageView.hd_height / 3, self.iconImageView.hd_width - 10, height1);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.startBT.frame = CGRectMake(self.iconImageView.hd_x, CGRectGetMaxY(self.iconImageView.frame) + 15, self.iconImageView.hd_width, self.hd_height * 0.115);
        self.startBT.layer.cornerRadius = self.startBT.hd_height / 2;
        self.startBT.layer.masksToBounds = YES;
        [self.startBT setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        self.startBT.backgroundColor = UIColorFromRGB(0x008cfd);
    }
    
    
}
- (void)startAnswerClick
{
    if (self.StartAnswer) {
        self.StartAnswer();
    }
}

@end
