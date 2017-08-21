//
//  SimulateresultCollectionReusableView.m
//  Accountant
//
//  Created by aaa on 2017/4/5.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "SimulateresultCollectionReusableView.h"
#import "UIMacro.h"

@implementation SimulateresultCollectionReusableView

- (void)resetWithTitle:(NSString *)title
{
    [self.topView removeFromSuperview];
    [self.seperateView removeFromSuperview];
    [self.titleLabel removeFromSuperview];
    [self.imageView removeFromSuperview];
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    self.topView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    //    [self addSubview:self.topView];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 22, 14, 10)];
    self.imageView.image = [UIImage imageNamed:@"simulateQestionTypeimage"];
    //    [self addSubview:self.imageView];
    
    self.seperateView = [[UIView alloc]initWithFrame:CGRectMake(15, 42, kScreenWidth - 30, .8)];
    self.seperateView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    //    [self addSubview:self.seperateView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12,self.frame.size.height / 2 - 10, kScreenWidth - 34, 20)];
    self.titleLabel.textColor = [UIColor colorWithWhite:.2 alpha:1];
    self.titleLabel.text = title;
    self.titleLabel.textColor = kMainTextColor_100;
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.titleLabel];
    
}

@end
