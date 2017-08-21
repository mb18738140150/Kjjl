//
//  CourseTypeBottomCollectionViewCell.m
//  Accountant
//
//  Created by aaa on 2017/6/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "CourseTypeBottomCollectionViewCell.h"

@implementation CourseTypeBottomCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer * collectTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
    [self.collectView addGestureRecognizer:collectTap];
    
    UITapGestureRecognizer * wrongTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
    [self.wrongView addGestureRecognizer:wrongTap];
}

- (void)click:(UITapGestureRecognizer *)sender
{
    if (self.SelectTypeBlock) {
        if ([sender.view isEqual:self.collectView]) {
            self.SelectTypeBlock(Type_collect);
        }else
        {
            self.SelectTypeBlock(Type_wrong);
        }
    }
}

@end
