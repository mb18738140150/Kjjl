//
//  DredgeMemberSelectDCTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/12/5.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DredgeMemberSelectDCTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView * selectTypeImageView;
@property (nonatomic, strong)UILabel * titleLB;

@property (nonatomic, strong)UILabel *detailLB;
@property (nonatomic, strong)UIImageView *goImageView;

- (void)resetCell:(NSDictionary *)infoDic;

@end
