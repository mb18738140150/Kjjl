//
//  DiscountCouponTCCell.h
//  Accountant
//
//  Created by aaa on 2018/3/16.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscountCouponTCCell : UITableViewCell

@property (strong, nonatomic)  UILabel *activityLB;
@property (strong, nonatomic)  UILabel *deadlineLB;
@property (strong, nonatomic)  UILabel *discountPriceLB;
@property (strong, nonatomic)  UILabel *manPriceLB;

- (void)refreshWithInfoDic:(NSDictionary *)infoDic;

@end
