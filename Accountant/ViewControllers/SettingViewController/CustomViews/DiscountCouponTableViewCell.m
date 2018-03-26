//
//  DiscountCouponTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/12/4.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DiscountCouponTableViewCell.h"

@implementation DiscountCouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addDashLine];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)resetWithInfo:(NSDictionary *)infoDic
{
    
    [self refreshWith:self.useState];
}

- (void)refreshWith:(DiscountCouponUserState)state
{
    self.useStateImageView.hidden = YES;
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.activityLB.textColor = UIColorFromRGB(0x1c8afa);
    self.deadlineLB.textColor = UIColorFromRGB(0x999999);
    self.discountPriceLB.textColor = UIColorFromRGB(0xff4f01);
    self.manPriceLB.textColor = UIColorFromRGB(0x999999);
    switch (state) {
        case DiscountCouponUserState_normal:
            
            break;
        case DiscountCouponUserState_cannotUse:
        {
            self.deadlineLB.textColor = UIColorFromRGB(0x999999);
            self.discountPriceLB.textColor = UIColorFromRGB(0x999999);
        }
            break;
        case DiscountCouponUserState_haveUseed:
        {
            self.useStateImageView.hidden = NO;
            self.useStateImageView.image = [UIImage imageNamed:@"img_ysy"];
            self.titleLB.textColor = UIColorFromRGB(0xcccccc);
            self.activityLB.textColor = UIColorFromRGB(0xcccccc);
            self.deadlineLB.textColor = UIColorFromRGB(0xcccccc);
            self.discountPriceLB.textColor = UIColorFromRGB(0xcccccc);
            self.manPriceLB.textColor = UIColorFromRGB(0xcccccc);
        }
            break;
        case DiscountCouponUserState_expire:
            self.useStateImageView.hidden = NO;
            self.useStateImageView.image = [UIImage imageNamed:@"img_ygq"];
            self.titleLB.textColor = UIColorFromRGB(0xcccccc);
            self.activityLB.textColor = UIColorFromRGB(0xcccccc);
            self.deadlineLB.textColor = UIColorFromRGB(0xcccccc);
            self.discountPriceLB.textColor = UIColorFromRGB(0xcccccc);
            self.manPriceLB.textColor = UIColorFromRGB(0xcccccc);
            break;
            
        default:
            break;
    }
}

- (void)displayLayer:(CALayer *)layer
{
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 200, 300) cornerRadius:5];
    path.lineWidth = 2;
    path.lineJoinStyle = kCGLineJoinRound;
    
    CAShapeLayer *shapLayer = [[CAShapeLayer alloc]init];
    [shapLayer setStrokeColor:UIColorFromRGB(0xff0000).CGColor];
    [shapLayer setFillColor:UIColorFromRGB(0xfefefe).CGColor];
    shapLayer.path = path.CGPath;
    
    layer.mask = shapLayer;
}

- (void)addDashLine
{
    CAShapeLayer * shapLayer = [CAShapeLayer layer];
    [shapLayer setBounds:self.xuxianView.bounds];
    [shapLayer setPosition:CGPointMake(self.xuxianView.hd_width / 2, self.xuxianView.hd_height / 2)];
    [shapLayer setStrokeColor:UIColorFromRGB(0xdddddd).CGColor];
    [shapLayer setLineWidth:self.xuxianView.hd_width];
    [shapLayer setLineJoin:kCALineJoinRound];
    [shapLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:2] ,nil]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, 0, self.xuxianView.hd_height);
    [shapLayer setPath:path];
    CGPathRelease(path);
    
    [self.xuxianView.layer addSublayer:shapLayer];
 
}


@end
