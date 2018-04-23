//
//  TextAswerCell.m
//  Accountant
//
//  Created by aaa on 2018/4/18.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "TextAswerCell.h"

@implementation TextAswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetProperty
{
    [self.contentView removeAllSubviews];
    
    MKPPlaceholderTextView *textView = [[MKPPlaceholderTextView alloc]init];
    textView.placeholder = @"这里录入答案";
    textView.frame = CGRectMake(20, 20, kScreenWidth - 20, 100);
    textView.delegate = self;
    textView.layer.cornerRadius = 5;
    textView.layer.masksToBounds = YES;
    textView.layer.borderColor = UIColorFromRGB(0xdddddd).CGColor;
    textView.layer.borderWidth = 1;
    [self.contentView addSubview:textView];
    self.opinionTextView = textView;
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (self.textAnswerBlock) {
        self.textAnswerBlock(textView.text);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
