//
//  NewCourseExchangeTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/10/10.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewCourseExchangeTableViewCell : UITableViewCell

@property (nonatomic, copy)void (^ExchangeBlock)(int number);
@property (nonatomic, copy)void (^MoreLivingCourseBlock)(BOOL showMore);

- (void)resetCell;

- (void)resetMoreInfo;

- (void)resetMoreInfoWithNotTopLine;

@end
