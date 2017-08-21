//
//  HistoryTableHeaderView.h
//  Accountant
//
//  Created by aaa on 2017/3/17.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableHeaderView : UIView

@property (nonatomic,strong) UIView     *headerView;
@property (nonatomic,strong) UILabel    *timeLabel;
@property (nonatomic,strong) UIView     *circleView;

- (void)setTime:(NSString *)timeStr;

@end
