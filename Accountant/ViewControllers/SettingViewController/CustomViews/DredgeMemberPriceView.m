//
//  DredgeMemberPriceView.m
//  Accountant
//
//  Created by aaa on 2017/12/5.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DredgeMemberPriceView.h"

@interface DredgeMemberPriceView ()

@property (nonatomic, strong)UILabel * realityPriceLB;
@property (nonatomic, strong)UILabel *priceLB;
@property (nonatomic, strong)UILabel *memberLevelLB;
@property (nonatomic, strong)UIImageView *chaozhiImageView;
@property (nonatomic, strong)UIImageView *selectImageView;
@property (nonatomic, strong)UIButton * selectBtn;


@end

@implementation DredgeMemberPriceView

- (instancetype)initWithFrame:(CGRect)frame andInfoDic:(NSDictionary *)infopDic
{
    if (self = [super initWithFrame:frame]) {
        self.infoDic = infopDic;
        [self prepareUI:infopDic];
    }
    return self;
}

- (void)prepareUI:(NSDictionary *)infoDic
{
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.hd_width - 15, 80)];
    backView.backgroundColor = UIColorFromRGB(0xe4e4e4);
    backView.tag = 1000;
    [self addSubview:backView];
    
    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(1, 1, backView.hd_width - 2 - 32, backView.hd_height - 2)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:whiteView];
    
    self.realityPriceLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, whiteView.hd_width, 15)];
    self.realityPriceLB.textColor = UIColorFromRGB(0xff4f00);
    self.realityPriceLB.font = kMainFont;
    self.realityPriceLB.textAlignment = 1;
    self.realityPriceLB.text = [NSString stringWithFormat:@"%@元", [infoDic objectForKey:kPrice]];
    [whiteView addSubview:self.realityPriceLB];
    
    self.priceLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 10 + CGRectGetMaxY(self.realityPriceLB.frame), whiteView.hd_width, 15)];
    self.priceLB.textColor = UIColorFromRGB(0xcccccc);
    self.priceLB.font = kMainFont;
    self.priceLB.textAlignment = 1;
    self.priceLB.attributedText = [self getPriceText:[NSString stringWithFormat:@"%@元", [infoDic objectForKey:kOldPrice]]];
    [whiteView addSubview:self.priceLB];
    
    self.memberLevelLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(whiteView.frame), 1, 32, backView.hd_height - 2)];
    self.memberLevelLB.textColor = UIColorFromRGB(0x333333);
    self.memberLevelLB.backgroundColor = UIColorFromRGB(0xf0f0f0);
    self.memberLevelLB.font = kMainFont;
    self.memberLevelLB.textAlignment = 1;
    self.memberLevelLB.numberOfLines = 0;
    [backView addSubview:self.memberLevelLB];
    self.memberLevelLB.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:kMemberLevel]];
    self.memberLevel = [NSString stringWithFormat:@"%@", [infoDic objectForKey:kMemberLevel]];
    
    
    self.chaozhiImageView = [[UIImageView alloc]initWithFrame:CGRectMake(1, 1, 25, 13)];
    self.chaozhiImageView.image = [UIImage imageNamed:@"icon_cz"];
    [backView addSubview:self.chaozhiImageView];
    if ([[infoDic objectForKey:@"chaozhi"] intValue] == 0) {
        self.chaozhiImageView.hidden = YES;
    }
    
    self.selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(backView.hd_width - 31, backView.hd_height - 31, 30, 30)];
    self.selectImageView.image = [UIImage imageNamed:@"icon_xz"];
    self.selectImageView.hidden = YES;
    [backView addSubview:self.selectImageView];
    if (self.selectType == DredgeMemberPrice_Select) {
        [self selectAction];
    }
    
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn.frame = CGRectMake(0, 0, backView.hd_width, backView.hd_height);
    self.selectBtn.backgroundColor = [UIColor clearColor];
    [self.selectBtn addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self.selectBtn];
    
}

- (void)setSelectType:(DredgeMemberPriceSelectType)selectType
{
    [self selectAction];
}

- (void)selectAction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView * backView = [self viewWithTag:1000];
        backView.backgroundColor = UIColorFromRGB(0xff4f00);
        self.selectImageView.hidden = NO;
    });
    
    if (self.MemberSelectBlock) {
        self.MemberSelectBlock(self.infoDic);
    }
}

- (void)resetView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView * backView = [self viewWithTag:1000];
        backView.backgroundColor = UIColorFromRGB(0xe4e4e4);
        self.selectImageView.hidden = YES;
    });
}

- (NSMutableAttributedString *)getPriceText:(NSString *)priceStr
{
    NSMutableAttributedString * aPriceStr = [[NSMutableAttributedString alloc]initWithString:priceStr];
    NSDictionary * attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:UIColorFromRGB(0xcccccc),NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)};
    [aPriceStr setAttributes:attribute range:NSMakeRange(0, priceStr.length)];
    
    return aPriceStr;
}

@end
