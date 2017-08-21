//
//  DownloadingTableViewCell.h
//  Accountant
//
//  Created by 阴天翔 on 2017/3/12.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelayButton.h"
@interface DownloadingTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel    *videoNameLabel;
@property (nonatomic,strong) UILabel    *downloadProcessLabel;
@property (nonatomic, strong)DelayButton *stateBT;
@property (nonatomic, copy)void(^DownStateBlock)(BOOL isPause);

- (void)resetContents;

@end
