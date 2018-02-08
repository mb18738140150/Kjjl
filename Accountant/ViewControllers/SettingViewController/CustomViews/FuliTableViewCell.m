//
//  FuliTableViewCell.m
//  Accountant
//
//  Created by aaa on 2018/2/5.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "FuliTableViewCell.h"

@implementation FuliTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetWith:(NSDictionary *)infoDic
{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[infoDic objectForKey:@"coverUrl"]] placeholderImage:[UIImage imageNamed:@"img_gsfl"]];
    self.titleLB.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"giftTitle"]];
    self.detailLB.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"giftWay"]];
    self.timeLB.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"giftTime"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
