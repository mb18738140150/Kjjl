//
//  CourseTypeCollectionViewCell.m
//  Accountant
//
//  Created by aaa on 2017/6/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "CourseTypeCollectionViewCell.h"

@implementation CourseTypeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetWithInfo:(NSDictionary *)infoDic
{
    self.imageView.image = [UIImage imageNamed:[infoDic objectForKey:@"iconUrl"]];
    self.titleLB.text = [infoDic objectForKey:@"title"];
    self.detailLB.text = [infoDic objectForKey:@"content"];
}

@end
