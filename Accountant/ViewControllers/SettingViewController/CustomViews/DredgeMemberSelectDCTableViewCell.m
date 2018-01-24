//
//  DredgeMemberSelectDCTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/12/5.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DredgeMemberSelectDCTableViewCell.h"

@implementation DredgeMemberSelectDCTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetCell:(NSDictionary *)infoDic
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.selectTypeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 20, 20)];
    self.selectTypeImageView.image = [UIImage imageNamed:@"icon_radio"];
    [self.contentView addSubview:self.selectTypeImageView];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.selectTypeImageView.frame) + 11, 14, 50, 20)];
    self.titleLB.text = @"代金券";
    self.titleLB.textColor = UIColorFromRGB(0x999999);
    self.titleLB.font = kMainFont;
    [self.contentView addSubview:self.titleLB];
    self.detailLB.text = @"您还没有使用优惠券哦";
    
    self.detailLB = [[UILabel alloc]initWithFrame:CGRectMake(90, 14, kScreenWidth - 90 - 40, 20)];
    self.detailLB.textAlignment = NSTextAlignmentRight;
    self.detailLB.textColor = UIColorFromRGB(0xcccccc);
    
    self.detailLB.font = kMainFont;
    [self.contentView addSubview:self.detailLB];
    
    
    self.goImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 20, 17, 10, 15)];
    self.goImageView.image = [UIImage imageNamed:@"icon_gd"];
    [self.contentView addSubview:self.goImageView];
    
    if ([infoDic objectForKey:kPrice]) {
        self.detailLB.text = [NSString stringWithFormat:@"-%@",[infoDic objectForKey:kPrice]];
        self.goImageView.image = [UIImage imageNamed:@" icon_radio_s"];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
