//
//  GetIntegralTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/12/6.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "GetIntegralTableViewCell.h"

@implementation GetIntegralTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetcellWith:(NSDictionary *)infoDic
{
    if (self.haveDone) {
        self.doBtn.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [self.doBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        self.doBtn.enabled = NO;
    }else
    {
        self.doBtn.backgroundColor = UIColorFromRGB(0xfd614d);
        [self.doBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.doBtn.enabled = YES;
    }
    
    self.iconImageView.image = [UIImage imageNamed:[infoDic objectForKey:@"icon"]];
    self.titleLB.text = [infoDic objectForKey:@"title"];
    self.detailLB.text = [infoDic objectForKey:@"detail"];
    
}
- (IBAction)doAction:(id)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
