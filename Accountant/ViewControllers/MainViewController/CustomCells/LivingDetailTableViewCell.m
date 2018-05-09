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
        CGFloat contentHeight = [UIUtility getSpaceLabelHeght:[infoDic objectForKey:kLivingDetail] font:font width:kScreenWidth - 20];
        height = contentHeight;
        
        UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 1)];
        topView.backgroundColor = UIColorFromRGB(0xeeeeee);
        [self.contentView addSubview:topView];
        
        self.topLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 19, kScreenWidth - 20, 15)];
        self.topLB.text = @"课程简介";
        self.topLB.font = kMainFont;
        [self.contentView addSubview:self.topLB];
        
        self.contentLB = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.topLB.frame) + 12, kScreenWidth - 20, height)];
        self.contentLB.numberOfLines = 10000;
        self.contentLB.font = [UIFont systemFontOfSize:12];
        self.contentLB.textColor = kMainTextColor_100;
        [self.contentView addSubview:self.contentLB];
        
    }
    if ([[infoDic objectForKey:kLivingDetail] length] == 0) {
        self.contentLB.text = @"暂无简介";
    }else
    {
        self.contentLB.attributedText = [UIUtility getSpaceLabelStr:[infoDic objectForKey:kLivingDetail] withFont:kMainFont];
    }
}


@end
