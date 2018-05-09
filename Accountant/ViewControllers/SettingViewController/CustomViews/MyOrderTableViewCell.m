//
//  MyOrderTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/12/4.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "MyOrderTableViewCell.h"

@interface MyOrderTableViewCell ()

@property (nonatomic, strong)NSDictionary * infoDic;

@end

@implementation MyOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetWithInfo:(NSDictionary *)infoDic
{
    self.infoDic = infoDic;
    
    self.myOrderTimeLB.text = [infoDic objectForKey:kOrderTime];
    self.myOrderIDLB.text = [infoDic objectForKey:kOrderId];
    [self.myOrderCourseIconImageView sd_setImageWithURL:[NSURL URLWithString:[infoDic objectForKey:kCourseCover]]];
    self.myOrderCOurseNameLB.text = [infoDic objectForKey:kCourseName];
    self.myOrderCoursetimeLengthLB.text = [infoDic objectForKey:kDeadLineTime];
    int payType = [[infoDic objectForKey:@"payType"] intValue];
    if (payType == 1) {
        self.myOrderCOursePriceLB.text = @"微信支付";
    }else
    {
        self.myOrderCOursePriceLB.text = @"支付宝支付";
    }
    
    if ([[infoDic objectForKey:kOrderStatus] intValue] == 0) {
        self.myOrderPayStateLB.text = @"待付款";
        [self.myOrderPayStateBtn setTitle:@"去支付" forState:UIControlStateNormal];
        self.myOrderPayStateBtn.layer.borderColor = UIColorFromRGB(0xff4f00).CGColor;
        [self.myOrderPayStateBtn setTitleColor:UIColorFromRGB(0xff4f00) forState:UIControlStateNormal];
    }else
    {
        self.myOrderPayStateLB.text = @"交易成功";
        [self.myOrderPayStateBtn setTitle:@"已支付" forState:UIControlStateNormal];
        self.myOrderPayStateBtn.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
        [self.myOrderPayStateBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        self.myOrderPayStateBtn.enabled = NO;
    }
    
    self.myOrderPayStateBtn.layer.borderWidth = 1;
    self.myOrderPayStateBtn.layer.cornerRadius = 3;
    self.myOrderPayStateBtn.layer.masksToBounds = YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)orderPayStateAction:(id)sender {
    
    if (self.payOrderBlock) {
        self.payOrderBlock(self.infoDic);
    }
    
}



@end
