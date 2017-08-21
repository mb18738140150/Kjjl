//
//  DownloadTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/3/9.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView            *titleImageView;
@property (nonatomic,strong) UILabel                *nameLabel;
@property (nonatomic,strong) UILabel                *downloadDetailLabel;

- (void)resetSubviews;

@end
