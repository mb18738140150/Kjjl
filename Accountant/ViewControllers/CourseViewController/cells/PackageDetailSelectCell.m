//
//  PackageDetailSelectCell.m
//  Accountant
//
//  Created by aaa on 2018/4/18.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "PackageDetailSelectCell.h"

@implementation PackageDetailSelectCell

- (void)refreshWithInfo:(NSDictionary *)infoDic
{
    [self.contentView removeAllSubviews];
    self.backgroundColor = [UIColor whiteColor];
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(1, 1, self.hd_width - 2, self.hd_height - 2)];
    self.titleLB.layer.cornerRadius = 3;
    self.titleLB.layer.borderWidth = 1;
    self.titleLB.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    self.titleLB.layer.masksToBounds = YES;
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.font = kMainFont;
    self.titleLB.textAlignment = NSTextAlignmentCenter;
    self.titleLB.text = [infoDic objectForKey:@"name"];
    [self.contentView addSubview:self.titleLB];
    
}

- (void)resetSelectState
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.titleLB.backgroundColor = UIColorFromRGB(0xff0000);
        self.titleLB.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
        self.titleLB.textColor = UIColorFromRGB(0xffffff);
    });
}

@end
