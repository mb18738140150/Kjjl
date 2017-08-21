//
//  AnswerCardFooterCollectionViewCell.m
//  Accountant
//
//  Created by aaa on 2017/3/30.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "AnswerCardFooterCollectionViewCell.h"
#import "UIMacro.h"

@implementation AnswerCardFooterCollectionViewCell

- (void)resetLabel
{
    [self.titlelabel removeFromSuperview];
    self.titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    self.titlelabel.backgroundColor = kCommonNavigationBarColor;
    self.titlelabel.text = @"提交";
    [self addSubview:self.titlelabel];
}

@end
