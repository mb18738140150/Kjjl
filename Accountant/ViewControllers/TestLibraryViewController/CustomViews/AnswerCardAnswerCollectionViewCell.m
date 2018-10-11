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
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(7, 7, self.hd_width - 14, self.hd_width - 14)];
    self.bgView.backgroundColor = kBackgroundGrayColor;
    self.bgView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.bgView.layer.borderWidth = 1;
    //    [self addSubview:self.bgView];
    
    self.answerLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 7, self.hd_width - 14, self.hd_width - 14)];
    self.answerLabel.backgroundColor = [UIColor clearColor];
    self.answerLabel.text = [NSString stringWithFormat:@"%@",[infoDic objectForKey:kTestQuestionNumber]];
    self.answerLabel.textColor = UIColorFromRGB(0x666666);
    self.answerLabel.font = [UIFont systemFontOfSize:14];
    self.answerLabel.layer.cornerRadius = self.answerLabel.hd_width / 2;
    self.answerLabel.layer.masksToBounds = YES;
    self.answerLabel.textAlignment = NSTextAlignmentCenter;
    
    self.answerLabel.layer.borderWidth = 1;
    self.answerLabel.layer.borderColor = UIColorFromRGB(0xc8c8c8).CGColor;
    
    if ([[infoDic objectForKey:kTestQuestionIsAnswered] intValue] == 0) {
        self.answerLabel.layer.borderColor = UIColorFromRGB(0xc8c8c8).CGColor;
        self.answerLabel.textColor = UIColorFromRGB(0x666666);
    }else
    {
        self.answerLabel.layer.borderColor = UIColorFromRGB(0x008aff).CGColor;
        self.answerLabel.textColor = UIColorFromRGB(0x008aff);
    }
    
    [self addSubview:self.answerLabel];
}

@end
