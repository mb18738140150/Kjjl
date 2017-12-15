//
//  BuyMemberSort.m
//  Accountant
//
//  Created by aaa on 2017/11/7.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "BuyMemberSort.h"

@implementation BuyMemberSort

- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUIWithImage:image andTtle:title];
    }
    return self;
}

- (void)prepareUIWithImage:(UIImage *)image andTtle:(NSString *)title
{
    UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(self.hd_width / 5, 0, self.hd_width / 5 * 3, self.hd_width / 5 * 3)];
    imageview.image = image;
    [self addSubview:imageview];
    
    UILabel * titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageview.frame) + 10, self.hd_width, 12)];
    titleLB.text = title;
    titleLB.textAlignment = 1;
    titleLB.textColor = UIColorFromRGB(0x999999);
    titleLB.font = [UIFont systemFontOfSize:12];
    [self addSubview:titleLB];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
