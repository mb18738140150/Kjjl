//
//  InputTextTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/3/7.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "InputTextTableViewCell.h"
#import "UIMacro.h"

@implementation InputTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetWithInfo:(NSDictionary *)dic
{
    [self.bottomLineView removeFromSuperview];
    [self.inputTextField removeFromSuperview];
    [self.infoLabel removeFromSuperview];
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
    self.infoLabel.backgroundColor = [UIColor grayColor];
    [self addSubview:self.infoLabel];
    
    self.inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 10, 200, 30)];
    self.inputTextField.backgroundColor = [UIColor grayColor];
    [self addSubview:self.inputTextField];
    
    self.bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(20, 49, kScreenWidth, 1)];
    self.bottomLineView.backgroundColor = kTableViewCellSeparatorColor;
    [self addSubview:self.bottomLineView];
}

@end
