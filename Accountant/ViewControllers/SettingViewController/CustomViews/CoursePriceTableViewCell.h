//
//  CoursePriceTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/11/7.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoursePriceTableViewCell : UITableViewCell

@property (nonatomic, copy)void (^buyCourseBlock)(NSDictionary *infoDic);

- (void)resetWith:(NSDictionary *)infoDic;



@end
