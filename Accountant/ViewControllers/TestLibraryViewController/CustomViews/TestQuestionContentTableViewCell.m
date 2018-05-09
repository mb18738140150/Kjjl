//
//  TestQuestionContentTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/3/24.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestQuestionContentTableViewCell.h"
#import "CommonMacro.h"
#import "UIMacro.h"
#import "UIUtility.h"
#import "TestMacro.h"

@implementation TestQuestionContentTableViewCell

- (void)resetWithInfo:(NSDictionary *)infoDic
{
    [self.headView removeFromSuperview];
    [self.testContentLabel removeFromSuperview];
    [self.testTypeLabel removeFromSuperview];
    [self.contentLB removeFromSuperview];
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
    self.headView.backgroundColor = kBackgroundGrayColor;
    [self addSubview:self.headView];
    
    UIFont *font = kMainFont;
    
    CGFloat height = [UIUtility getSpaceLabelHeght:[infoDic objectForKey:kTestQuestionContent] font:font width:(kScreenWidth - 40)];
    
    
    self.testTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth, 15)];
    self.testTypeLabel.text = [NSString stringWithFormat:@"[%@]",[infoDic objectForKey:kTestQuestionType]];
    self.testTypeLabel.font = kMainFont;
    self.testTypeLabel.textColor = kMainTextColor_100;
    [self addSubview:self.testTypeLabel];
    
    if (self.isTextAnswer) {
         NSAttributedString * attributeStr = [[NSAttributedString alloc] initWithData:[[infoDic objectForKey:kTestQuestionContent] dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
         height = [attributeStr boundingRectWithSize:CGSizeMake(kScreenWidth - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
        
        self.contentLB = [[UITextView alloc]initWithFrame:CGRectMake(20, 30, kScreenWidth - 40, height)];
        self.contentLB.editable = NO;
        self.contentLB.textColor = UIColorFromRGB(0x666666);
        self.contentLB.font = kMainFont;
        [self addSubview:self.contentLB];
        self.contentLB.scrollEnabled = NO;
        self.contentLB.attributedText = attributeStr;
    }else
    {
        
        self.testContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, kScreenWidth - 40, height)];
        
        NSString *content = [infoDic objectForKey:kTestQuestionContent];
        
        //    NSLog(@"content = %@", content);
        
        NSMutableString *contentStr = [NSMutableString stringWithString:content];
        while (1) {
            if ([contentStr containsString:@"&nbsp;"] != 0) {
                NSRange range = [content rangeOfString:@"&nbsp;"];
                [contentStr deleteCharactersInRange:range];
            }else{
                break;
            }
        }
        
        self.testContentLabel.attributedText = [UIUtility getSpaceLabelStr:contentStr withFont:font];
        self.testContentLabel.numberOfLines = 100000;
        self.testContentLabel.font = font;
        self.testContentLabel.textColor = kMainTextColor_100;
        self.testContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:self.testContentLabel];
        
    }
    
    [self.questionCountLabel removeFromSuperview];
    [self.questionCurrentLabel removeFromSuperview];
    
    self.questionCurrentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-120, 0, 60, 15)];
    self.questionCurrentLabel.textAlignment = NSTextAlignmentRight;
    self.questionCurrentLabel.text = [NSString stringWithFormat:@"%d",self.questionCurrentIndex+1];
    self.questionCurrentLabel.textColor = kMainTextColor_100;
    self.questionCurrentLabel.font = kMainFont;
    [self addSubview:self.questionCurrentLabel];
    
    self.questionCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-60, 0, 60, 15)];
    self.questionCountLabel.textAlignment = NSTextAlignmentLeft;
    self.questionCountLabel.text = [NSString stringWithFormat:@" / %d",self.questionTotalCount];
    self.questionCountLabel.textColor = kMainTextColor_100;
    self.questionCountLabel.font = kMainFont;
    [self addSubview:self.questionCountLabel];
    
}

@end
