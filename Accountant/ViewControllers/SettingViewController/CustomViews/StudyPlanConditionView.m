//
//  StudyPlanConditionView.m
//  Accountant
//
//  Created by aaa on 2017/12/8.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "StudyPlanConditionView.h"

@interface StudyPlanConditionView ()

@property (nonatomic, strong)UIButton * selectBtn;

@end

@implementation StudyPlanConditionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.hd_height / 2 - 9, 18, 18)];
    self.imageView.image = [UIImage imageNamed:@"btn_lb_n"];
    [self addSubview:self.imageView];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame) + 5, self.hd_height / 2 - 8, self.hd_width - 10 - 18, 16)];
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.titleLB];
    
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn.frame = CGRectMake(0, 0, self.hd_width, self.hd_height);
    [self addSubview:self.selectBtn];
    [self.selectBtn addTarget:self action:@selector(selectBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)resetTitle:(NSString *)title
{
    self.titleLB.text = title;
}

- (void)selectBtnAction
{
    if (self.SelectConditionBlock) {
        self.SelectConditionBlock(self.tag);
    }
}

- (void)selectAction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = [UIImage imageNamed:@"btn_lb_s"];
    });
}
- (void)nomalAction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = [UIImage imageNamed:@"btn_lb_n"];
    });
}

@end
