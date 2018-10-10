//
//  DiscountCouponTCCell.m
//  Accountant
//
//  Created by aaa on 2018/3/16.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "DiscountCouponTCCell.h"

#define kScal 0.3

@implementation DiscountCouponTCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)refreshWithInfoDic:(NSDictionary *)infoDic
{
    [self.contentView removeAllSubviews];
    [self prepareUI];
    
    self.discountPriceLB.attributedText = [self getPrice:[NSString stringWithFormat:@"%@%@",[SoftManager shareSoftManager].coinName, [infoDic objectForKey:@"CouponPrice"]]];
    self.manPriceLB.text = [NSString stringWithFormat:@"满%@可用", [infoDic objectForKey:@"Area"]];
    self.activityLB.text = [infoDic objectForKey:@"MakeText"];
    self.deadlineLB.text = [NSString stringWithFormat:@"有效期至：%@", [infoDic objectForKey:@"EndDate"]];
    
}

- (void)prepareUI
{
    self.backgroundColor = [UIColor clearColor];
    UIImageView * backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, self.hd_height - 8)];
    backImageView.image = [UIImage imageNamed:@"discountCoupon_yhq_bg"];
    [self.contentView addSubview:backImageView];
    
    self.discountPriceLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.hd_width * kScal - 10, backImageView.hd_height / 2)];
    self.discountPriceLB.textColor = UIColorFromRGB(0xfc5442);
    self.discountPriceLB.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.discountPriceLB];
    
    self.manPriceLB = [[UILabel alloc]initWithFrame:CGRectMake(self.discountPriceLB.hd_x, CGRectGetMaxY(self.discountPriceLB.frame) + 5, self.discountPriceLB.hd_width, 15)];
    self.manPriceLB.textColor = UIColorFromRGB(0x999999);
    self.manPriceLB.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:self.manPriceLB];
    
    self.activityLB = [[UILabel alloc]initWithFrame:CGRectMake(self.hd_width * kScal + 10, backImageView.hd_centerY - 20, self.hd_width * (1 - kScal) - 10, 15)];
    self.activityLB.textColor = UIColorFromRGB(0xee3e2f);
    self.activityLB.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.activityLB];
    
    self.deadlineLB = [[UILabel alloc]initWithFrame:CGRectMake(self.hd_width * kScal + 10, backImageView.hd_centerY + 5, self.hd_width * (1 - kScal) - 10, 13)];
    self.deadlineLB.textColor = UIColorFromRGB(0x999999);
    self.deadlineLB.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:self.deadlineLB];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSMutableAttributedString *)getPrice:(NSString *)price
{
    NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc]initWithString:price];
    NSDictionary * attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:25]};
    [mStr setAttributes:attribute range:NSMakeRange(1, price.length - 1)];
    return mStr;
}

@end
