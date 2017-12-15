//
//  PayView.m
//  Accountant
//
//  Created by aaa on 2017/12/5.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "PayView.h"

@implementation PayView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.priceLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth / 2, 50)];
    self.priceLB.backgroundColor = [UIColor whiteColor];
    self.priceLB.textColor = UIColorFromRGB(0x333333);
    self.priceLB.textAlignment = 1;
    self.price = @"0";
    self.priceLB.font = kMainFont;
    [self addSubview:self.priceLB];
    
    self.payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.payBtn.frame = CGRectMake(kScreenWidth / 2, 0, kScreenWidth / 2, 50);
    self.payBtn.backgroundColor = UIColorFromRGB(0xff4f00);
    [self.payBtn setTitle:@"去支付" forState:UIControlStateNormal];
    [self.payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.payBtn.titleLabel.font = kMainFont;
    [self addSubview:self.payBtn];
    
}
- (void)setPrice:(NSString *)price
{
    NSString * priceStr = [NSString stringWithFormat:@"总价: %@元",price];
    NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc]initWithString:priceStr];
    NSDictionary * attribute = @{NSFontAttributeName:kMainFont,NSForegroundColorAttributeName:UIColorFromRGB(0xff4f00)};
    [mStr setAttributes:attribute range:NSMakeRange(3, priceStr.length - 3)];
    self.priceLB.attributedText = mStr;
}


@end
