//
//  DredgememberTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/12/5.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DredgememberTableViewCell.h"

@implementation DredgememberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetCell:(NSDictionary *)infoDic
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 16, 39, 39)];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[infoDic objectForKey:kUserHeaderImageUrl]] placeholderImage:[UIImage imageNamed:@"img_tx"]];
    [self.contentView addSubview:self.iconImageView];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 11, 16, 200, 15)];
    self.titleLB.text = [infoDic objectForKey:kUserNickName];
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.font = kMainFont;
    [self.contentView addSubview:self.titleLB];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 11, CGRectGetMaxY(self.titleLB.frame) + 10, 200, 15)];
    self.titleLB.text = [infoDic objectForKey:kUserNickName];
    self.titleLB.textColor = UIColorFromRGB(0xdab584);
    self.titleLB.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.titleLB];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
