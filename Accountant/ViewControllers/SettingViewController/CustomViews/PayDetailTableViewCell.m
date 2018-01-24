//
//  PayDetailTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/11/21.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "PayDetailTableViewCell.h"

@implementation PayDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetUIWith:(NSDictionary *)infoDic
{
    [self.contentView removeAllSubviews];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    self.imageV.image = [UIImage imageNamed:[infoDic objectForKey:@"imageName"]];
    [self.contentView addSubview:self.imageV];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imageV.frame) + 10, 10, 80, 30)];
    self.titleLB.text = [infoDic objectForKey:@"title"];
    self.titleLB.textColor = kMainTextColor;
    self.titleLB.font = kMainFont;
    [self.contentView addSubview:self.titleLB];
    
    self.payType = [[infoDic objectForKey:@"payType"] integerValue];
    
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn.frame = CGRectMake(kScreenWidth - 40, 15, 20, 20);
    [self.selectBtn addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.selectBtn];
    
    if (self.isSelect) {
        [self.selectBtn setImage:[UIImage imageNamed:@"icon_radio_s"] forState:UIControlStateNormal];
    }else
    {
        [self.selectBtn setImage:[UIImage imageNamed:@"icon_radio"] forState:UIControlStateNormal];
    }
}

- (void)selectAction
{
    if (self.payBlock) {
        self.payBlock(self.payType);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
