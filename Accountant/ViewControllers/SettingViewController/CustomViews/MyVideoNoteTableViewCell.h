//
//  MyVideoNoteTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/3/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyVideoNoteTableViewCell : UITableViewCell

@property (nonatomic, strong)UILabel            *timeLabel;
@property (nonatomic,strong) UILabel            *contentLabel;
@property (nonatomic,strong) UILabel            *videoInfoLabel;

- (void)resetCellWithInfo:(NSDictionary *)dic;

@end
