//
//  DownloadTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/3/9.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DownloadTableViewCell.h"
#import "UIMacro.h"

@interface DownloadTableViewCell ()



@end

@implementation DownloadTableViewCell

- (void)resetSubviews
{
    [self.titleImageView removeFromSuperview];
    [self.nameLabel removeFromSuperview];
    [self.downloadDetailLabel removeFromSuperview];
    self.titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [self addSubview:self.titleImageView];
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 30)];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.nameLabel];
    self.downloadDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 80, 10, 60, 30)];
    self.downloadDetailLabel.font = [UIFont systemFontOfSize:14];
    self.downloadDetailLabel.textAlignment = NSTextAlignmentRight;
    self.downloadDetailLabel.textColor = [UIColor grayColor];
    
    [self addSubview:self.downloadDetailLabel];
}

@end
