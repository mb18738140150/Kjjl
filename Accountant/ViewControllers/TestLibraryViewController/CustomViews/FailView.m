//
//  FailView.m
//  tiku
//
//  Created by aaa on 2017/6/1.
//  Copyright © 2017年 ytx. All rights reserved.
//

#import "FailView.h"

@implementation FailView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.backgroundColor = kCommonNavigationBarColor;
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 100, 200, 200)];
    self.imageView.hd_centerX = self.hd_centerX;
    [self addSubview:self.imageView];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.imageView.frame) + 20, kScreenWidth, 15)];
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.textAlignment = 1;
    self.titleLB.font = kMainFont;
    [self addSubview:self.titleLB];
    
    self.refreshBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.refreshBT.frame = CGRectMake(0, CGRectGetMaxY(self.titleLB.frame) + 20, 91, 26);
    self.refreshBT.hd_centerX = self.hd_centerX;
    self.refreshBT.layer.cornerRadius = self.refreshBT.hd_height / 2;
    self.refreshBT.layer.masksToBounds = YES;
    self.refreshBT.layer.borderWidth = 1;
    self.refreshBT.layer.borderColor = UIColorFromRGB(0x1D7AF8).CGColor;
    [self.refreshBT setTitleColor:UIColorFromRGB(0x1D7AF8) forState:UIControlStateNormal];
    [self.refreshBT setTitle:@"刷新" forState:UIControlStateNormal];
    self.refreshBT.titleLabel.font = kMainFont;
    [self addSubview:self.refreshBT];
    [self.refreshBT addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setFailType:(FailType *)failType
{
    _failType = failType;
    if (failType == FailType_NoData) {
        self.imageView.image = [UIImage imageNamed:@"组-2"];
        self.titleLB.text = @"没有匹配数据";
    }else
    {
        self.imageView.image = [UIImage imageNamed:@"on-web"];
        self.titleLB.text = @"暂无网络连接";
    }
}

- (void)refresh
{
    if (self.refreshBlock) {
        self.refreshBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
