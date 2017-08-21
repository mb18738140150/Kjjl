//
//  MyQuestionTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/3/21.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "MyQuestionTableViewCell.h"
#import "CommonMacro.h"
#import "UIUtility.h"
#import "UIMacro.h"

@implementation MyQuestionTableViewCell

- (void)resetContentWithInfo:(NSDictionary *)infoDic andIsReply:(BOOL)isReply
{
    [self.contentLabel removeFromSuperview];
    [self.replyInfoLabel removeFromSuperview];
    
    NSString *content = [infoDic objectForKey:kQuestionContent];
    
    CGFloat maxHeight = 80;
    CGFloat contentHeight = [UIUtility getHeightWithText:content font:kMainFont width:kScreenWidth - 40];
    CGFloat height = 0;
    if (maxHeight > contentHeight) {
        height = contentHeight;
    }else{
        height = maxHeight;
    }
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kScreenWidth - 40, height)];
    self.contentLabel.font = kMainFont;
    self.contentLabel.numberOfLines = 100000;
    self.contentLabel.text = content;
    self.contentLabel.textColor = kMainTextColor;
    [self addSubview:self.contentLabel];
    
    if (isReply) {
        self.replyInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + 5, kScreenWidth - 40, 20)];
        self.replyInfoLabel.textColor = [UIColor grayColor];
        self.replyInfoLabel.text = [NSString stringWithFormat:@"回复数:%@",[infoDic objectForKey:kQuestionReplyCount]];
        self.replyInfoLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.replyInfoLabel];
    }
}

@end
