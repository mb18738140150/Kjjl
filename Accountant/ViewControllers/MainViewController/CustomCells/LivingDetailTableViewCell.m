//
//  LivingDetailTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/8/9.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "LivingDetailTableViewCell.h"

@implementation LivingDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetWithInfoDic:(NSDictionary *)infoDic
{
    if (!self.contentLB) {
        
        CGFloat height;
        UIFont *font = kMainFont;
        CGFloat contentHeight = [UIUtility getSpaceLabelHeght:[infoDic objectForKey:kLivingDetail] font:font width:kScreenWidth - 40];
        height = contentHeight;
        
        self.contentLB = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, kScreenWidth - 40, height)];
        self.contentLB.attributedText = [UIUtility getSpaceLabelStr:[infoDic objectForKey:kLivingDetail] withFont:kMainFont];
        self.contentLB.numberOfLines = 10000;
        self.contentLB.font = kMainFont;
        self.contentLB.textColor = kMainTextColor_100;
        [self.contentView addSubview:self.contentLB];
        
    }
}


@end
