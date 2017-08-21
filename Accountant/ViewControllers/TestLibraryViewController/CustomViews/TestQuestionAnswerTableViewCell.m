//
//  TestQuestionAnswerTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/3/24.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestQuestionAnswerTableViewCell.h"
#import "UIMacro.h"
#import "CommonMacro.h"
#import "TestMacro.h"
#import "UIUtility.h"

@implementation TestQuestionAnswerTableViewCell

- (void)resetWithInfo:(NSDictionary *)infoDic andIsSelect:(BOOL)isSelected
{
    [self.separateLine removeFromSuperview];
    [self.contentLabel removeFromSuperview];
    //    [self.idLabel removeFromSuperview];
    //    [self.idView removeFromSuperview];
    [self.idBT removeFromSuperview];
    
    self.separateLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    self.separateLine.backgroundColor = kTableViewCellSeparatorColor;
    [self addSubview:self.separateLine];
    
    self.idBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.idBT.frame = CGRectMake(20, 10, 30, 30);
    [self.idBT setBackgroundImage:[UIImage imageNamed:@"tiku_d-1"] forState:UIControlStateNormal];
    [self.idBT setTitleColor:UIRGBColor(26, 66, 248) forState:UIControlStateNormal];
    [self.idBT setTitle:[NSString stringWithFormat:@"%@", [[infoDic objectForKey:kTestAnswerContent] substringWithRange:NSMakeRange(0, 1)]] forState:UIControlStateNormal];
    //    self.idBT.enabled = NO;
    [self addSubview:self.idBT];
    
    //    self.idView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
    //    self.idView.backgroundColor = kCommonNavigationBarColor;
    //    self.idView.layer.cornerRadius = 15;
    //    [self addSubview:self.idView];
    
    //    self.idLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    //    self.idLabel.backgroundColor = [UIColor clearColor];
    //    self.idLabel.font = kMainFont;
    //    self.idLabel.textAlignment = NSTextAlignmentCenter;
    //    self.idLabel.text = [[infoDic objectForKey:kTestAnswerContent] substringWithRange:NSMakeRange(0, 1)];
    //    [self.idView addSubview:self.idLabel];
    
    CGFloat minHeight = kHeightOfTestQuestionAnswer;
    UIFont *font = kMainFont;
    CGFloat height = [UIUtility getHeightWithText:[infoDic objectForKey:kTestAnswerContent] font:font width:kScreenWidth - 80];
    if (height < minHeight) {
        height = minHeight;
    }
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, kScreenWidth-80, height+10)];
    self.contentLabel.numberOfLines = 10000;
    self.contentLabel.font = kMainFont;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.text = [[infoDic objectForKey:kTestAnswerContent] substringFromIndex:2];
    
    [self addSubview:self.contentLabel];
    
    if (!isSelected) {
        [self.idBT setBackgroundImage:[UIImage imageNamed:@"tiku_d-1"] forState:UIControlStateNormal];
        [self.idBT setTitleColor:UIRGBColor(26, 66, 248) forState:UIControlStateNormal];
        
        self.contentLabel.textColor = [UIColor colorWithWhite:.7 alpha:1];
    }else{
        [self.idBT setBackgroundImage:[UIImage imageNamed:@"tiku_d-2"] forState:UIControlStateNormal];
        [self.idBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.contentLabel.textColor = kMainTextColor;
    }
}

@end
