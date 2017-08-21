//
//  HistoryTableHeaderView.m
//  Accountant
//
//  Created by aaa on 2017/3/17.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "HistoryTableHeaderView.h"
#import "SettingMacro.h"
#import "UIMacro.h"

@implementation HistoryTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(25, 0, 1, kHistoryCellHeight)];
        self.headerView.backgroundColor = kTableViewCellSeparatorColor;
        [self addSubview:self.headerView];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, kScreenWidth, kHistoryCellHeight)];
        self.timeLabel.textColor = kCommonMainColor;
        [self addSubview:self.timeLabel];
        
        self.circleView = [[UIView alloc] initWithFrame:CGRectMake(20, kHistoryCellHeight/2-5, 10, 10)];
        self.circleView.backgroundColor=  kCommonMainColor;
        self.circleView.layer.cornerRadius = 5;
        [self addSubview:self.circleView];
    }
    return self;
}

- (void)setTime:(NSString *)timeStr
{
    self.timeLabel.text = timeStr;
}

@end
