//
//  FuliTableViewCell.h
//  Accountant
//
//  Created by aaa on 2018/2/5.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FuliTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *detailLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;

- (void)resetWith:(NSDictionary *)infoDic;

@end
