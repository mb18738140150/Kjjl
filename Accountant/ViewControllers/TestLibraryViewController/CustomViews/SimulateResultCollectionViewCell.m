//
//  SimulateResultCollectionViewCell.m
//  Accountant
//
//  Created by aaa on 2017/4/5.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "SimulateResultCollectionViewCell.h"
#import "UIMacro.h"
#import "CommonMacro.h"



@implementation SimulateResultCollectionViewCell

- (void)resetCellWithinfo:(NSDictionary *)questionInfo
{
    self.backgroundColor = [UIColor whiteColor];
    [self.questionNumberLabel removeFromSuperview];
    [self.imageView removeFromSuperview];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 - 15, self.frame.size.height / 2 - 15, 30, 30)];
    self.imageView.backgroundColor = [UIColor whiteColor];
    //    [self addSubview:self.imageView];
    
    self.questionNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 7, self.hd_width - 14, self.hd_width - 14)];
    [self addSubview:self.questionNumberLabel];
    self.questionNumberLabel.textColor = UIColorFromRGB(0x666666);
    self.questionNumberLabel.font = kMainFont;
    self.questionNumberLabel.textAlignment = 1;
    self.questionNumberLabel.layer.cornerRadius = self.questionNumberLabel.hd_width / 2;
    self.questionNumberLabel.layer.masksToBounds = YES;
    self.questionNumberLabel.layer.borderWidth = 1;
    self.questionNumberLabel.layer.borderColor = UIColorFromRGB(0xc8c8c8).CGColor;
    
    self.questionNumberLabel.text = [NSString stringWithFormat:@"%@",[questionInfo objectForKey:kTestQuestionNumber]];
    
    if ([[questionInfo objectForKey:kTestQuestionIsAnswerCorrect] intValue]) {
        self.questionNumberLabel.layer.borderColor = UIColorFromRGB(0x008aff).CGColor;
        self.questionNumberLabel.textColor = UIColorFromRGB(0x008aff);
    }else
    {
        self.questionNumberLabel.layer.borderColor = UIColorFromRGB(0xff0000).CGColor;
        self.questionNumberLabel.textColor = UIColorFromRGB(0xff0000);
    }
    
    if (![[questionInfo objectForKey:kTestQuestionIsAnswered] intValue]) {
        self.questionNumberLabel.layer.borderColor = UIColorFromRGB(0xc8c8c8).CGColor;
        self.questionNumberLabel.textColor = UIColorFromRGB(0x666666);
    }
    
}

@end
