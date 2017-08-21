//
//  SectionListTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/3/23.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionListTableViewCell : UITableViewCell

@property (nonatomic,strong) UIView                 *lineView;
@property (nonatomic,strong) UIView                 *circleView;
@property (nonatomic,strong) UILabel                *titleLabel;
@property (nonatomic, strong)UILabel                *detailLabel;

- (void)resetTitleStr:(NSDictionary *)info;

@end
