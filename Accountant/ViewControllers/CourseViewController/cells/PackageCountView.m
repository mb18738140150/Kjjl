//
//  PackageCountView.m
//  Accountant
//
//  Created by aaa on 2018/4/17.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "PackageCountView.h"

@implementation PackageCountView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.musBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.musBtn.frame = CGRectMake(0, 0, 23, 23);
    [self.musBtn setImage:[UIImage imageNamed:@"count_minus"] forState:UIControlStateNormal];
    [self addSubview:self.musBtn];
    
    self.countLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.musBtn.frame), 0, 50, 23)];
    self.countLB.text = @"1";
    self.countLB.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.countLB];
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addBtn.frame = CGRectMake(CGRectGetMaxX(self.countLB.frame), 0, 23, 23);
    [self.addBtn setImage:[UIImage imageNamed:@"count_add"] forState:UIControlStateNormal];
    [self addSubview:self.addBtn];
    
    [self.musBtn addTarget:self action:@selector(musAction) forControlEvents:UIControlEventTouchUpInside];
    [self.addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)reset
{
    self.countLB.text = @"1";
}

- (void)musAction
{
    if (self.countLB.text.intValue >1) {
        int count = self.countLB.text.intValue - 1;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.countLB.text = [NSString stringWithFormat:@"%d", count];
            [self changeCount];
        });
    }
}

- (void)addAction
{
    int count = self.countLB.text.intValue + 1;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.countLB.text = [NSString stringWithFormat:@"%d", count];
        [self changeCount];
    });
}

- (void)changeCount
{
    if (self.countBlock) {
        self.countBlock(self.countLB.text.intValue);
    }
}

@end
