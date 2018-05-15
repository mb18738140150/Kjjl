//
//  BuyCoinTableViewCell.m
//  Accountant
//
//  Created by aaa on 2018/5/13.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "BuyCoinTableViewCell.h"

@implementation BuyCoinTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetWithInfo:(NSDictionary *)infoDic
{
    self.goldLB.text = [infoDic objectForKey:@"name"];
    self.priceLB.text = [infoDic objectForKey:@"price"];
    if (self.isSelect) {
        self.selectImage.image = [UIImage imageNamed:@"buyCoin_select"];
    }else
    {
        self.selectImage.image = [UIImage imageNamed:@"buyCoin_n"];
    }
}

@end
