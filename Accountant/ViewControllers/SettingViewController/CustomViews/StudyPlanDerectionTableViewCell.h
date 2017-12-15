//
//  StudyPlanDerectionTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/12/12.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudyPlanDerectionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *jieduanLB;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *detailLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLBWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewWidth;

- (void)resetWith:(NSDictionary *)infoDic;

@end
