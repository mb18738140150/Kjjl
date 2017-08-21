//
//  AnswerCardAnswerCollectionViewCell.m
//  Accountant
//
//  Created by aaa on 2017/3/30.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "AnswerCardAnswerCollectionViewCell.h"
#import "UIMacro.h"
#import "CommonMacro.h"

#define kcellWidth (kScreenWidth/6 * 0.75)
#define kcellHeight (kScreenWidth/6 * 0.75) *0.75

@implementation AnswerCardAnswerCollectionViewCell

- (void)resetCellWithInfo:(NSDictionary *)infoDic
{
    self.dic = infoDic;
    [self.bgView removeFromSuperview];
    [self.answerLabel removeFromSuperview];
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/4-1, 40)];
    self.bgView.backgroundColor = kBackgroundGrayColor;
    self.bgView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.bgView.layer.borderWidth = 1;
    //    [self addSubview:self.bgView];
    
    self.answerLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 6 / 2 - kcellWidth / 2, kScreenWidth/6/2 - kcellHeight / 2, kcellWidth, kcellHeight)];
    self.answerLabel.backgroundColor = [UIColor clearColor];
    //    self.answerLabel.text = [NSString stringWithFormat:@"  %@.%@",[infoDic objectForKey:kTestQuestionIndex],[infoDic objectForKey:kTestQuestionAnswers]];
    self.answerLabel.text = [NSString stringWithFormat:@"%@",[infoDic objectForKey:kTestQuestionNumber]];
    self.answerLabel.textColor = kCommonMainTextColor_50;
    self.answerLabel.font = [UIFont systemFontOfSize:14];
    self.answerLabel.textAlignment = NSTextAlignmentCenter;
    
    self.answerLabel.layer.borderWidth = 0.5;
    self.answerLabel.layer.borderColor = kCommonMainColor.CGColor;
    
    if ([[infoDic objectForKey:kTestQuestionIsAnswered] intValue] == 0) {
        self.answerLabel.backgroundColor = [UIColor whiteColor];
    }else
    {
        self.answerLabel.backgroundColor = kCommonMainColor;
        self.answerLabel.textColor = [UIColor whiteColor];
    }
    
    [self addSubview:self.answerLabel];
}

@end
