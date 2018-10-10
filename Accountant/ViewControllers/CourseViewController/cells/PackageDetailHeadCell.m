//
//  PackageDetailHeadCell.m
//  Accountant
//
//  Created by aaa on 2018/4/17.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "PackageDetailHeadCell.h"

@implementation PackageDetailHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetUIWithInfo:(NSDictionary *)infoDic
{
    self.imageHeight.constant = kScreenWidth / 14.0 * 8;
    [self.packageIconImageView sd_setImageWithURL:[NSURL URLWithString:[infoDic objectForKey:@"packageCover"]] placeholderImage:[UIImage imageNamed:@""]];
    self.packageTitleLB.text = [infoDic objectForKey:@"packageName"];
    self.priceLB.text = [NSString stringWithFormat:@"%@ %@",[SoftManager shareSoftManager].coinName, [infoDic objectForKey:@"packagePrice"]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
