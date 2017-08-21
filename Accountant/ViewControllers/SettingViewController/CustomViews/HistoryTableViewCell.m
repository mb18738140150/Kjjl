//
//  HistoryTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/3/17.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "HistoryTableViewCell.h"
#import "SettingMacro.h"
#import "UIMacro.h"
#import "CommonMacro.h"
#import "UIUtility.h"

@interface HistoryTableViewCell ()


@property (nonatomic,strong) UIView                         *headerImageView;
@property (nonatomic,strong) UILabel                        *courseLabel;
@property (nonatomic,strong) UILabel                        *videoLabel;

@end

@implementation HistoryTableViewCell

- (void)resetSubviews
{
    [self.headerImageView removeFromSuperview];
    [self.courseLabel removeFromSuperview];
    [self.videoLabel removeFromSuperview];
}

- (void)resetCellWithInfo:(NSDictionary *)infoDic
{
    self.cellInfoDic = infoDic;
    self.backgroundColor = [UIColor whiteColor];
    [self resetSubviews];
    
    self.headerImageView = [[UIView alloc] initWithFrame:CGRectMake(25, 0, 1, kHistoryCellHeight)];
    self.headerImageView.backgroundColor = kTableViewCellSeparatorColor;
    [self addSubview:self.headerImageView];
    
    self.courseLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, kScreenWidth, 30)];
    self.courseLabel.text = [infoDic objectForKey:kCourseName];
    self.courseLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.courseLabel];
    
    self.videoLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, kScreenWidth - 80, 20)];
    if ([[infoDic objectForKey:kVideoName] length] != 0) {
        self.videoLabel.text = [infoDic objectForKey:kVideoName];
    }else
    {
        self.videoLabel.text = [infoDic objectForKey:kChapterName];
    }
    self.videoLabel.font = [UIFont systemFontOfSize:14];
    self.videoLabel.numberOfLines = 0;
    self.videoLabel.textColor = [UIColor grayColor];
    CGFloat contentHeight = [UIUtility getHeightWithText:self.videoLabel.text font:[UIFont systemFontOfSize:14] width:kScreenWidth - 80];
    if (contentHeight > 20) {
        self.videoLabel.frame =CGRectMake(70, 30, kScreenWidth - 80, contentHeight);
        self.headerImageView.frame = CGRectMake(25, 0, 1, kHistoryCellHeight + contentHeight - 20);
    }
    
    [self addSubview:self.videoLabel];
    
}

@end
