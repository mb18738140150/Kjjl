//
//  StudyPlanDerectionTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/12/12.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "StudyPlanDerectionTableViewCell.h"

@implementation StudyPlanDerectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetWith:(NSDictionary *)infoDic
{
    self.jieduanLB.text = [infoDic objectForKey:@"jieduan"];
    self.titleLB.text = [infoDic objectForKey:@"title"];
    self.detailLB.text = [infoDic objectForKey:@"detail"];
    self.jieduanLB.backgroundColor = UIColorFromRGBValue([[infoDic objectForKey:@"color"] longValue]);
    self.bottomView.backgroundColor = UIColorFromRGBValue([[infoDic objectForKey:@"color"] longValue]);
    CGFloat width = [UIUtility getWidthWithText:[infoDic objectForKey:@"title"] font:[UIFont systemFontOfSize:15] height:28];
    self.titleLBWidth.constant = width + 20;
    self.bottomViewWidth.constant = width + 20 + 29;
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, kScreenWidth, self.hd_height);
    [button setTitle:@"" forState:UIControlStateNormal];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
