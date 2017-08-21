//
//  DownloadedCourseTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/3/10.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadedCourseTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView        *courseCoverImageView;
@property (nonatomic,strong) UILabel            *courseNameLabel;
@property (nonatomic,strong) UILabel            *courseCountLabel;

- (void)resetCellContent:(NSDictionary *)courseInfo;

@end
