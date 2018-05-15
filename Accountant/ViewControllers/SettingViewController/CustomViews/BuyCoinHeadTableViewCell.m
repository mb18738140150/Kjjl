//
//  BuyCoinHeadTableViewCell.m
//  Accountant
//
//  Created by aaa on 2018/5/13.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "BuyCoinHeadTableViewCell.h"

@implementation BuyCoinHeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetWith:(int)coinCount
{
    self.iconLB.text = [NSString stringWithFormat:@"%d", coinCount];
}

@end
