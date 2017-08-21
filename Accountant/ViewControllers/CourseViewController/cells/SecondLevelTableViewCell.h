//
//  SecondLevelTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/4/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondLevelTableViewCell : UITableViewCell

@property (nonatomic, strong)UILabel * titleLabel;
- (void)resetCellContent:(NSString *)title;

@end
