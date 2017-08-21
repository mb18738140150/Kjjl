//
//  DownloadingTableViewCell.m
//  Accountant
//
//  Created by 阴天翔 on 2017/3/12.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DownloadingTableViewCell.h"
#import "UIMacro.h"
#import "DelayButton+helper.h"

@implementation DownloadingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)resetContents
{
    [self.videoNameLabel removeFromSuperview];
    [self.downloadProcessLabel removeFromSuperview];
    [self.stateBT removeFromSuperview];
    
    self.videoNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 150, 50)];
    self.videoNameLabel.font = [UIFont systemFontOfSize:15];
    
    [self addSubview:self.videoNameLabel];
    
    self.downloadProcessLabel = [[UILabel alloc] initWithFrame:CGRectMake( kScreenWidth - 150, 0, 80, 50)];
    self.downloadProcessLabel.textColor = [UIColor grayColor];
    self.downloadProcessLabel.textAlignment = 1;
    self.downloadProcessLabel.font = kMainFont;
    [self addSubview:self.downloadProcessLabel];
    
    self.stateBT = [DelayButton buttonWithType:UIButtonTypeCustom];
    self.stateBT.frame = CGRectMake(kScreenWidth - 60, 10, 20, 20);
    self.stateBT.clickDurationTime = 1;
    [self.stateBT setImage:[UIImage imageNamed:@"download-pause"] forState:UIControlStateNormal];
    [self.stateBT setImage:[UIImage imageNamed:@"download-play"] forState:UIControlStateSelected];
    [self addSubview:self.stateBT];
    [self.stateBT addTarget:self action:@selector(downStateAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)downStateAction:(UIButton *)button
{
    button.selected = !button.selected;
    if (self.DownStateBlock) {
        self.DownStateBlock(button.selected);
    }
}

@end
