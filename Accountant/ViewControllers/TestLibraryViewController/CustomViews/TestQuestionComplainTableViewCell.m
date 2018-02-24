//
//  TestQuestionComplainTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/3/24.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestQuestionComplainTableViewCell.h"
#import "CommonMacro.h"
#import "UIMacro.h"
#import "TestMacro.h"
#import "UIUtility.h"

@implementation TestQuestionComplainTableViewCell

- (void)resetWithInfo:(NSDictionary *)infoDic
{
    [self.titleLabel removeFromSuperview];
    [self.complainLabel removeFromSuperview];
    
    self.backgroundColor = UIRGBColor(254, 244, 227);
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kScreenWidth - 40, 20)];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = @"题目解析:";
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    self.titleLabel.textColor = kMainTextColor;
    [self addSubview:self.titleLabel];
    
    UIFont *font = kMainFont;
    CGFloat height = [UIUtility getHeightWithText:[infoDic objectForKey:kTestQuestionComplain] font:font width:(kScreenWidth - 40)];
    height = [UIUtility getSpaceLabelHeght:[infoDic objectForKey:kTestQuestionComplain] font:font width:(kScreenWidth - 40)];
    self.complainLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height+10, kScreenWidth - 40, height)];
    self.complainLabel.font = font;
    NSString *complainStr = [infoDic objectForKey:kTestQuestionComplain];
    if (complainStr.length > 4) {
        if ([[complainStr substringFromIndex:(complainStr.length-4)] isEqualToString:@"</p>"]) {
            NSString * str = [complainStr substringToIndex:complainStr.length - 4];
            self.complainLabel.attributedText = [UIUtility getSpaceLabelStr:str withFont:font];
        }else{
            self.complainLabel.attributedText = [UIUtility getSpaceLabelStr:complainStr withFont:font];
        }
    }else
    {
        self.complainLabel.attributedText = [UIUtility getSpaceLabelStr:complainStr withFont:font];
    }
    self.complainLabel.numberOfLines = 100000;
    self.complainLabel.textColor = kMainTextColor_100;
    self.complainLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:self.complainLabel];
    
}

@end
