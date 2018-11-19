//
//  BuyCoinFootTableViewCell.m
//  Accountant
//
//  Created by aaa on 2018/5/13.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "BuyCoinFootTableViewCell.h"

@implementation BuyCoinFootTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetUI
{
    self.detailLB.text = @"1、充值比例：￥1=1金币 \n2、iOS设备上的充值不能在非iOS设备上使用 \n3、如需帮助，请联系客服";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
