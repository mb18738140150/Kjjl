//
//  GetIntegralTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/12/6.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetIntegralTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *detailLB;
@property (weak, nonatomic) IBOutlet UILabel *coinLB;
@property (weak, nonatomic) IBOutlet UIButton *doBtn;


@property (nonatomic, assign)BOOL haveDone;

- (void)resetcellWith:(NSDictionary *)infoDic;

@end
