//
//  LivingDetailTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/8/9.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LivingDetailTableViewCell : UITableViewCell

@property(nonatomic, strong)UILabel * contentLB;

- (void)resetWithInfoDic:(NSDictionary *)infoDic;

@end
