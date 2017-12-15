//
//  CoursePriceTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/11/7.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "CoursePriceTableViewCell.h"

@interface CoursePriceTableViewCell ()

@property (nonatomic, strong)UIImageView * coverImageView;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UILabel * priceLB;
@property (nonatomic, strong)UILabel *oldPriceLB;
@property (nonatomic, strong)UILabel * totalPriceLB;
@property (nonatomic, strong)UIButton *buyBtn;

@property (nonatomic, strong)NSDictionary * infoDic;

@end

@implementation CoursePriceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetWith:(NSDictionary *)infoDic
{
    [self.contentView removeAllSubviews];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.infoDic = infoDic;
    self.backgroundColor = UIRGBColor(245, 245, 245);
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    
    self.coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 120, 70)];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[infoDic objectForKey:kCourseCover]] placeholderImage:[UIImage imageNamed:@""]];
    [self.contentView addSubview:self.coverImageView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.coverImageView.frame) + 10, self.coverImageView.hd_y + 5, kScreenWidth - 150, 15)];
    self.titleLabel.font = kMainFont;
    self.titleLabel.textColor = UIColorFromRGB(0x666666);
    self.titleLabel.text = [infoDic objectForKey:kCourseName];
    [self.contentView addSubview:self.titleLabel];
    
    self.priceLB = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.hd_x, CGRectGetMaxY(self.titleLabel.frame) + 15, 100, 15)];
    self.priceLB.textColor = UIColorFromRGB(0xfd760e);
    self.priceLB.textAlignment = 1;
    [self.contentView addSubview:self.priceLB];
    self.priceLB.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:kCourseID]];
    CGFloat priceLBWidth = [UIUtility getWidthWithText:[NSString stringWithFormat:@"%@", [infoDic objectForKey:kCourseID]] font:[UIFont systemFontOfSize:17] height:15];
    self.priceLB.hd_width = priceLBWidth + 20;
    
    self.oldPriceLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.priceLB.frame), self.priceLB.hd_y + 4, 100, 11)];
    self.oldPriceLB.textColor = UIColorFromRGB(0x999999);
    self.oldPriceLB.font = kMainFont;
    self.oldPriceLB.attributedText = [self getOldPaice:[NSString stringWithFormat:@"%@", [infoDic objectForKey:kCourseID]]];
    [self.contentView addSubview:self.oldPriceLB];
    
    self.totalPriceLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, kScreenWidth / 2, 60)];
    self.totalPriceLB.font = kMainFont;
    self.totalPriceLB.textColor = UIColorFromRGB(0x999999);
    self.totalPriceLB.text = [NSString stringWithFormat:@"总价: ￥%@", [NSString stringWithFormat:@"%@", [infoDic objectForKey:kCourseID]]];
    [self.contentView addSubview:self.totalPriceLB];
    
    self.buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buyBtn.frame = CGRectMake(kScreenWidth - 110, 112, 100, 36);
    self.buyBtn.backgroundColor = UIColorFromRGB(0xff750d);
    [self.buyBtn setTitle:@"点击购买" forState:UIControlStateNormal];
    [self.buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.buyBtn.layer.cornerRadius = 3;
    self.buyBtn.layer.masksToBounds = YES;
    self.buyBtn.titleLabel.font = kMainFont;
    [self.contentView addSubview:self.buyBtn];
    [self.buyBtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)buyAction
{
    if (self.buyCourseBlock) {
        self.buyCourseBlock(self.infoDic);
    }
}

- (NSMutableAttributedString*)getOldPaice:(NSString *)oldPrice
{
    NSString *oldPriceStr = [NSString stringWithFormat:@"￥%@", oldPrice];
    NSMutableAttributedString *aOldStr = [[NSMutableAttributedString alloc]initWithString:oldPriceStr];
    [aOldStr addAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0, oldPriceStr.length)];
    
    return aOldStr;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
