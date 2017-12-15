//
//  DredgememberTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/12/5.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DredgememberTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *iconImageView;
@property (nonatomic, strong)UILabel *titleLB;
@property (nonatomic, strong)UILabel *memberLevelLB;

- (void)resetCell:(NSDictionary *)infoDic;

@end
