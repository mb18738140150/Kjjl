//
//  TestQuestionResultTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/3/24.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestQuestionResultTableViewCell.h"
#import "TestMacro.h"
#import "CommonMacro.h"
#import "UIMacro.h"

@implementation TestQuestionResultTableViewCell

- (void)resetWithInfo:(NSDictionary *)infoDic
{
    [self.myLabel removeFromSuperview];
    [self.myTextLabel removeFromSuperview];
    [self.correctLabel removeFromSuperview];
    [self.correctTextLabel removeFromSuperview];
    [self.bgView removeFromSuperview];
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, kScreenWidth-40, kHeightOfTestMyAnswer-20)];
    self.bgView.backgroundColor = kBackgroundGrayColor;
    //    [self addSubview:self.bgView];
    
    //    CGSize bgViewSize = self.bgView.frame.size;
    
    self.correctLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, kScreenWidth - 30, 20)];
    NSString *test = [NSString stringWithFormat:@"正确答案:%@", [infoDic objectForKey:kTestQuestionCorrectAnswersId]];
    self.correctLabel.textColor = kMainTextColor;
    self.correctLabel.font = [UIFont systemFontOfSize:16];
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:test];
    NSDictionary * dic = @{NSForegroundColorAttributeName:kCommonMainColor};
    [attributeStr setAttributes:dic range:NSMakeRange(5, test.length - 5)];
    self.correctLabel.attributedText = attributeStr;
    
    [self addSubview:self.correctLabel];
    
    self.myLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 15 - 80, 15, 80, 20)];
    self.myLabel.font = [UIFont systemFontOfSize:16];
    self.myLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.myLabel];
    
    NSArray *selectedArray = [infoDic objectForKey:kTestQuestionSelectedAnswers];
    NSMutableString *myStr = [[NSMutableString alloc] init];
    for (NSNumber *number in selectedArray) {
        [myStr appendString:[NSString stringWithFormat:@"%@",number]];
    }
    
    if ([[infoDic objectForKey:kTestQuestionCorrectAnswersId] isEqualToString:myStr]) {
        self.myLabel.attributedText = [self getMyresultString:YES];
    }else
    {
        self.myLabel.attributedText = [self getMyresultString:NO];
    }
    
    if (self.isRecord) {
        if ([[infoDic objectForKey:kTestQuestionCorrectAnswersId] isEqualToString:[infoDic objectForKey:kTestMyanswer]]) {
            self.myLabel.attributedText = [self getMyresultString:YES];
        }else
        {
            self.myLabel.attributedText = [self getMyresultString:NO];
        }
        if (![[infoDic objectForKey:kTestIsResponse] intValue]) {
            self.myLabel.attributedText = [self getMyresultStringNOresponse];
        }
    }
}

- (NSMutableAttributedString *)getMyresultStringNOresponse
{
    NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc]initWithString:@"未作答"];
    NSDictionary * attribute = @{NSForegroundColorAttributeName:kCommonMainColor};
    [mStr setAttributes:attribute range:NSMakeRange(0, 3)];
    return mStr;
}

- (NSMutableAttributedString *)getMyresultString:(BOOL)right
{
    if (right) {
        NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc]initWithString:@"回答正确"];
        NSDictionary * attribute = @{NSForegroundColorAttributeName:kCommonMainColor};
        [mStr setAttributes:attribute range:NSMakeRange(2, 2)];
        return mStr;
    }else
    {
        NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc]initWithString:@"回答错误"];
        NSDictionary * attribute = @{NSForegroundColorAttributeName:[UIColor redColor]};
        [mStr setAttributes:attribute range:NSMakeRange(2, 2)];
        return mStr;
    }
}

@end
