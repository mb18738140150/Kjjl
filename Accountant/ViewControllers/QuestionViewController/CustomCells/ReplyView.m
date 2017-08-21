//
//  ReplyView.m
//  Accountant
//
//  Created by aaa on 2017/6/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "ReplyView.h"

#define Space 5.0

#define kTopSpace 10

@implementation ReplyView


- (instancetype)initWithFrame:(CGRect)frame tipPoint:(CGPoint)toppoint
{
    if (self = [super initWithFrame:frame]) {
        self.point = toppoint;
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.backgroundColor = kBackgroundGrayColor;
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(Space, kTopSpace * 2, 40, 40)];
    self.iconImageView.image = [UIImage imageNamed:@"head-pic"];
    self.iconImageView.layer.cornerRadius = self.iconImageView.hd_height / 2;
    self.iconImageView.layer.masksToBounds = YES;
    [self addSubview:self.iconImageView];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 5, kTopSpace * 2, 50, 15)];
    self.nameLabel.text = @"王老师";
    self.nameLabel.textColor = kCommonMainTextColor_50;
    self.nameLabel.font = kMainFont;
    [self addSubview:self.nameLabel];
    
    self.remarkLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 5, self.nameLabel.hd_y, 35, 13)];
    self.remarkLB.textColor = kCommonMainTextColor_100;
    self.remarkLB.textAlignment = 1;
    self.remarkLB.font = [UIFont systemFontOfSize:12];
    self.remarkLB.layer.borderWidth = 1;
    self.remarkLB.layer.borderColor = kCommonMainTextColor_150.CGColor;
    self.remarkLB.text = @"老师";
    [self addSubview:self.remarkLB];
    
    self.timeLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 5, CGRectGetMaxY(self.nameLabel.frame) + 5, self.hd_width - 60, 15)];
    self.timeLB.font = [UIFont systemFontOfSize:12];
    self.timeLB.textColor = kCommonMainTextColor_100;
    self.timeLB.text = @"2017-10-28 00：00";
    [self addSubview:self.timeLB];
    
    self.contentLB = [[UILabel alloc]initWithFrame:CGRectMake(Space, CGRectGetMaxY(self.iconImageView.frame) + Space * 2, self.hd_width - 2 *Space, 100)];
    self.contentLB.textColor = kCommonMainTextColor_50;
    self.contentLB.font = kMainFont;
    self.contentLB.numberOfLines = 0;
    [self addSubview:self.contentLB];
}

- (void)resetInfo:(NSDictionary *)infoDic{
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[infoDic objectForKey:@"coachImg"]] placeholderImage:[UIImage imageNamed:@"stuhead"]];
    self.nameLabel.text = [infoDic objectForKey:@"coachName"];
    self.timeLB.text = [infoDic objectForKey:@"replyTime"];
    
    CGFloat nameidth = [self.nameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
    self.nameLabel.hd_width = nameidth;
    self.remarkLB.hd_x = CGRectGetMaxX(self.nameLabel.frame) + 5;
    
    CGFloat contentHeight = [[infoDic objectForKey:@"replyCon"] boundingRectWithSize:CGSizeMake(self.hd_width - Space * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont} context:nil].size.height;
    self.contentLB.text = [infoDic objectForKey:@"replyCon"];
    self.frame = CGRectMake(self.hd_x, self.hd_y, self.hd_width, contentHeight + 80);
    self.contentLB.hd_height = contentHeight;
    
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, kTopSpace)];
    [bezierPath addLineToPoint:CGPointMake(self.point.x - kTopSpace / 2, kTopSpace)];
    [bezierPath addLineToPoint:CGPointMake(self.point.x, 0)];
    [bezierPath addLineToPoint:CGPointMake(self.point.x + kTopSpace / 2, kTopSpace)];
    [bezierPath addLineToPoint:CGPointMake(self.hd_width, kTopSpace)];
    [bezierPath addLineToPoint:CGPointMake(self.hd_width, self.frame.size.height)];
    [bezierPath addLineToPoint:CGPointMake(0, self.frame.size.height)];
    [bezierPath stroke];
    
    CAShapeLayer * layer = [[CAShapeLayer alloc]init];
    layer.frame = self.bounds;
    layer.path = bezierPath.CGPath;
    
    self.layer.mask = layer;
    
    self.height = contentHeight + 80;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
