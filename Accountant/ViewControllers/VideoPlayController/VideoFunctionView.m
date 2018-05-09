//
//  VideoFunctionView.m
//  Accountant
//
//  Created by aaa on 2017/11/2.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "VideoFunctionView.h"

@interface VideoFunctionView ()

@property (nonatomic, assign)BOOL isBuy;

@property (nonatomic, strong)UIButton *cansultBtn;
@property (nonatomic, strong)UIView * priceView;
@property (nonatomic, strong)UILabel *nowPrice;
@property (nonatomic, strong)UILabel *oldPrice;
@property (nonatomic, strong)UIButton *buyBtn;

@end

@implementation VideoFunctionView

- (instancetype)initWithFrame:(CGRect)frame andIsBuy:(BOOL)isBuy
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isBuy = isBuy;
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.backgroundColor = UIRGBColor(200, 200, 200);
    
    self.priceView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth / 3, 0, kScreenWidth / 3, 50)];
    self.priceView.backgroundColor = UIRGBColor(230, 230, 230);
    [self addSubview:self.priceView];
    
    self.nowPrice = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.priceView.hd_width, 15)];
    self.nowPrice.textAlignment = 1;
    self.nowPrice.textColor = kMainTextColor;
    self.nowPrice.font = [UIFont systemFontOfSize:15];
    [self.priceView addSubview:self.nowPrice];
    
    self.oldPrice = [[UILabel alloc]initWithFrame:CGRectMake(0, 28, self.priceView.hd_width, 15)];
    self.oldPrice.textAlignment = 1;
    self.oldPrice.textColor = kMainTextColor_100;
    self.oldPrice.font = [UIFont systemFontOfSize:14];
    [self.priceView addSubview:self.oldPrice];
    
    
    self.cansultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cansultBtn.frame = CGRectMake(0, 0, kScreenWidth / 3, 50);
    [self.cansultBtn setImage:[UIImage imageNamed:@"btn_zixun"] forState:UIControlStateNormal];
    self.cansultBtn.backgroundColor = UIRGBColor(240, 240, 240);
    [self.cansultBtn setTitle:@"咨询" forState:UIControlStateNormal];
    self.cansultBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    self.cansultBtn.titleLabel.font = kMainFont;
    [self.cansultBtn setTitleColor:kMainTextColor_100 forState:UIControlStateNormal];
    [self addSubview:self.cansultBtn];
    [self.cansultBtn addTarget:self action:@selector(cansultAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buyBtn.frame = CGRectMake(kScreenWidth / 3 * 2, 0, kScreenWidth / 3, 50);
    self.buyBtn.backgroundColor = UIRGBColor(251, 75, 33);
    [self.buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buyBtn setTitle:@"购买" forState:UIControlStateNormal];
    self.buyBtn.titleLabel.font = kMainFont;
    [self addSubview:self.buyBtn];
    [self.buyBtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
    
    if (!self.isBuy) {
        self.priceView.hidden = YES;
        self.buyBtn.hidden = YES;
        self.cansultBtn.frame = CGRectMake(0, 0, kScreenWidth, 50);
    }
    
}

- (void)refreshWithInfoDic:(NSDictionary *)infoDic
{
    self.nowPrice.attributedText = [self getNowPriceWith:[NSString stringWithFormat:@"%@", [infoDic objectForKey:kPrice]]];
    self.oldPrice.attributedText = [self getOldPaice:[NSString stringWithFormat:@"%@", [infoDic objectForKey:kOldPrice]]];
}

- (void)cansultAction
{
    if (self.cansultBlock) {
        self.cansultBlock();
    }
}

- (void)buyAction
{
    if (self.buyBlock) {
        self.buyBlock();
    }
}

- (NSMutableAttributedString *)getNowPriceWith:(NSString *)nowPrice
{
    NSString * nowPriceStr = [NSString stringWithFormat:@"现价￥%@", nowPrice];
    NSMutableAttributedString * aStr = [[NSMutableAttributedString alloc]initWithString:nowPriceStr];
    NSDictionary * attribute = @{NSForegroundColorAttributeName:UIRGBColor(251, 75, 33)};
    [aStr setAttributes:attribute range:NSMakeRange(2, nowPriceStr.length - 2)];

    return aStr;
}

- (NSMutableAttributedString*)getOldPaice:(NSString *)oldPrice
{
    NSString *oldPriceStr = [NSString stringWithFormat:@"原价￥%@", oldPrice];
    NSMutableAttributedString *aOldStr = [[NSMutableAttributedString alloc]initWithString:oldPriceStr];
    [aOldStr addAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0, oldPriceStr.length)];
    
    return aOldStr;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
