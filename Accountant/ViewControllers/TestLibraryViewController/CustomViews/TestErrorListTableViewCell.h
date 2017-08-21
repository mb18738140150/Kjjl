//
//  TestErrorListTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/3/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestErrorListTableViewCell : UITableViewCell

@property (nonatomic,strong) UIView         *circleView;
@property (nonatomic,strong) UILabel        *titleLabel;
@property (nonatomic, strong) UILabel       *detailLabel;

- (void)resetContentWithInfo:(NSDictionary *)info;

@end
