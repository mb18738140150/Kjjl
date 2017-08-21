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

#define kcellWidth (kScreenWidth/6 * 0.75)
#define kcellHeight (kScreenWidth/6 * 0.75) *0.75

@implementation SimulateResultCollectionViewCell

- (void)resetCellWithinfo:(NSDictionary *)questionInfo
{
    self.backgroundColor = [UIColor whiteColor];
    [self.questionNumberLabel removeFromSuperview];
    [self.imageView removeFromSuperview];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 - 15, self.frame.size.height / 2 - 15, 30, 30)];
    self.imageView.backgroundColor = [UIColor whiteColor];
    //    [self addSubview:self.imageView];
    
    self.questionNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 6 / 2 - kcellWidth / 2, kScreenWidth/6/2 - kcellHeight / 2, kcellWidth, kcellHeight)];
    [self addSubview:self.questionNumberLabel];
    self.questionNumberLabel.textColor = kCommonMainColor;
    self.questionNumberLabel.font = kMainFont;
    self.questionNumberLabel.textAlignment = 1;
    
    self.questionNumberLabel.layer.borderWidth = 0.5;
    self.questionNumberLabel.layer.borderColor = kCommonMainColor.CGColor;
    
    self.questionNumberLabel.text = [NSString stringWithFormat:@"%@",[questionInfo objectForKey:kTestQuestionNumber]];
    
    if ([[questionInfo objectForKey:kTestQuestionIsAnswerCorrect] intValue]) {
        self.questionNumberLabel.backgroundColor = kCommonMainColor;
        self.questionNumberLabel.textColor = [UIColor whiteColor];
    }else
    {
        self.questionNumberLabel.backgroundColor = UIRGBColor(242, 62, 52);
        self.questionNumberLabel.layer.borderWidth = 0;
        self.questionNumberLabel.textColor = [UIColor whiteColor];
    }
    
    if (![[questionInfo objectForKey:kTestQuestionIsAnswered] intValue]) {
        self.imageView.hidden = YES;
        self.questionNumberLabel.backgroundColor = [UIColor whiteColor];
        self.questionNumberLabel.textColor = kCommonMainColor;
        self.questionNumberLabel.layer.borderWidth = 0.5;
    }
    
}

@end
