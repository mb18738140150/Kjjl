//
//  MyVideoNoteTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/3/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "MyVideoNoteTableViewCell.h"
#import "UIMacro.h"
#import "CommonMacro.h"
#import "UIUtility.h"

@interface MyVideoNoteTableViewCell ()


@end

@implementation MyVideoNoteTableViewCell

- (void)resetCellWithInfo:(NSDictionary *)dic
{
    [self.contentLabel removeFromSuperview];
    [self.videoInfoLabel removeFromSuperview];
    
    
    NSString *content = [dic objectForKey:kNoteVideoNoteContent];
    CGFloat maxHeight = 80;
    CGFloat contentHeight = [UIUtility getHeightWithText:content font:kMainFont width:kScreenWidth - 20];
    CGFloat height = 0;
    if (maxHeight > contentHeight) {
        height = contentHeight;
    }else{
        height = maxHeight;
    }
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 20)];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    if ([dic objectForKey:@"time"] && [[dic objectForKey:@"time"] length] != 0) {
        self.timeLabel.text = [dic objectForKey:@"time"];
    }else
    {
        self.timeLabel.text = @"2017/1/1";
    }
    self.timeLabel.font = kMainFont;
    self.timeLabel.textColor = kCommonMainTextColor_100;
    [self addSubview:self.timeLabel];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.timeLabel.frame) + 5, kScreenWidth - 20, height)];
    self.contentLabel.font = kMainFont;
    self.contentLabel.numberOfLines = 100000;
    self.contentLabel.text = [dic objectForKey:kNoteVideoNoteContent];
    self.contentLabel.textColor = kMainTextColor;
    [self addSubview:self.contentLabel];
    
    self.videoInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + 5, kScreenWidth - 20, 20)];
    self.videoInfoLabel.textColor = [UIColor grayColor];
    self.videoInfoLabel.text = [dic objectForKey:kVideoName];
    self.videoInfoLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.videoInfoLabel];
    
}

@end
