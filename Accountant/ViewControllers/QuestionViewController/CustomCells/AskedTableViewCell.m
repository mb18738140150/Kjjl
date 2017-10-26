//
//  AskedTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/10/19.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "AskedTableViewCell.h"

#define kTopSpace 8

@interface AskedTableViewCell ()

@property (nonatomic, strong)NSDictionary *infoDic;
@property (nonatomic, strong)UIImageView *iconImageView;
@property (nonatomic, strong)UILabel * contentLB;
@property (nonatomic, strong)UIView *backView;

@end

@implementation AskedTableViewCell

- (void)resetCellWithInfoDic:(NSDictionary *)infoDic
{
    self.infoDic = infoDic;
    switch ([[infoDic objectForKey:@"identity"] intValue]) {
        case 0:
            [self prepareAskUI];
            break;
        case 1:
            [self prepareReplayUI];
            break;
            
        default:
            break;
    }
}

- (void)prepareAskUI
{
    [self.contentView removeAllSubviews];
    
    CGFloat height = [UIUtility getHeightWithText:[self.infoDic objectForKey:@"replyCon"] font:kMainFont width:kScreenWidth / 2 - 25];
    CGFloat backHeight = height + 10;
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 45, 10 + backHeight / 2 - 15, 30, 30)];
    self.iconImageView.image = [UIImage imageNamed:@"stuhead"];
    self.iconImageView.layer.cornerRadius = self.iconImageView.hd_height / 2;
    [self.contentView addSubview:self.iconImageView];
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 45 - kScreenWidth / 2 - 10, 10, kScreenWidth / 2, backHeight)];
    self.backView.backgroundColor = UIRGBColor(230, 230, 230);
    self.backView.layer.cornerRadius = 3;
    self.backView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.backView];
    
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    [bezier moveToPoint:CGPointMake(0, 0)];
    [bezier addLineToPoint:CGPointMake(self.backView.hd_width - kTopSpace, 0)];
    [bezier addLineToPoint:CGPointMake(self.backView.hd_width - kTopSpace, self.backView.hd_height / 2 - kTopSpace / 2)];
    [bezier addLineToPoint:CGPointMake(self.backView.hd_width, self.backView.hd_height / 2)];
    [bezier addLineToPoint:CGPointMake(self.backView.hd_width - kTopSpace,  self.backView.hd_height / 2 + kTopSpace / 2)];
    [bezier addLineToPoint:CGPointMake(self.backView.hd_width - kTopSpace, self.backView.hd_height )];
    [bezier addLineToPoint:CGPointMake(0, self.backView.hd_height )];
    [bezier stroke];
    
    CAShapeLayer * shapeLayer = [[CAShapeLayer alloc]init];
    shapeLayer.frame = self.backView.bounds;
    shapeLayer.path = bezier.CGPath;
    
    self.backView.layer.mask = shapeLayer;
    
    self.contentLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, kScreenWidth / 2 - 25, height)];
    self.contentLB.text = [self.infoDic objectForKey:@"replyCon"];
    self.contentLB.numberOfLines = 0;
    self.contentLB.font = kMainFont;
    self.contentLB.textColor = kMainTextColor;
    [self.backView addSubview:self.contentLB];
    
}

- (void)prepareReplayUI
{
    [self.contentView removeAllSubviews];
    CGFloat height = [UIUtility getHeightWithText:[self.infoDic objectForKey:@"replyCon"] font:kMainFont width:kScreenWidth / 2 - 25];
    CGFloat backHeight = height + 10;
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10 + backHeight / 2 - 15, 30, 30)];
    self.iconImageView.image = [UIImage imageNamed:@"stuhead"];
    self.iconImageView.layer.cornerRadius = self.iconImageView.hd_height / 2;
    [self.contentView addSubview:self.iconImageView];
    
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(45 + 10, 10, kScreenWidth / 2, backHeight)];
    self.backView.backgroundColor = UIRGBColor(230, 230, 230);
    self.backView.layer.cornerRadius = 3;
    self.backView.layer.masksToBounds = YES;
    self.backView.backgroundColor = UIRGBColor(118, 244, 78);
    [self.contentView addSubview:self.backView];
    
    
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    [bezier moveToPoint:CGPointMake(kTopSpace, 0)];
    [bezier addLineToPoint:CGPointMake(self.backView.hd_width, 0)];
    [bezier addLineToPoint:CGPointMake(self.backView.hd_width, backHeight )];
    [bezier addLineToPoint:CGPointMake(kTopSpace, backHeight )];
    [bezier addLineToPoint:CGPointMake(kTopSpace, backHeight / 2 + kTopSpace / 2)];
    [bezier addLineToPoint:CGPointMake(0, backHeight / 2)];
    [bezier addLineToPoint:CGPointMake(kTopSpace, backHeight / 2 - kTopSpace / 2)];
    [bezier stroke];
    
    CAShapeLayer * shapeLayer = [[CAShapeLayer alloc]init];
    shapeLayer.frame = self.backView.bounds;
    shapeLayer.path = bezier.CGPath;
    
    self.backView.layer.mask = shapeLayer;
    
    self.contentLB = [[UILabel alloc]initWithFrame:CGRectMake(18, 5, kScreenWidth / 2 - 25, height)];
    self.contentLB.text = [self.infoDic objectForKey:@"replyCon"];
    self.contentLB.numberOfLines = 0;
    self.contentLB.font = kMainFont;
    self.contentLB.textColor = kMainTextColor;
    [self.backView addSubview:self.contentLB];
}

@end
