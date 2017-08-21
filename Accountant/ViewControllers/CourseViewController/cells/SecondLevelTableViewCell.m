//
//  SecondLevelTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/4/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "SecondLevelTableViewCell.h"
#import "UIMacro.h"

@implementation SecondLevelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetCellContent:(NSString *)title
{
    [self.titleLabel removeFromSuperview];
    self.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 13, self.frame.size.width - 15, 16)];
    self.titleLabel.textColor = kMainTextColor;
    self.titleLabel.font = kMainFont;
    if (title.length > 0) {
        self.titleLabel.text = title;
    }else
    {
        self.titleLabel.text = @"全部";
    }
    [self.contentView addSubview:self.titleLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
