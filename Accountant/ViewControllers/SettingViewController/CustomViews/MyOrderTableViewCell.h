//
//  MyOrderTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/12/4.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *myOrderTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *myOrderIDLB;
@property (weak, nonatomic) IBOutlet UIImageView *myOrderCourseIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *myOrderCOurseNameLB;
@property (weak, nonatomic) IBOutlet UILabel *myOrderCoursetimeLengthLB;
@property (weak, nonatomic) IBOutlet UILabel *myOrderCOursePriceLB;
@property (weak, nonatomic) IBOutlet UIButton *myOrderPayStateBtn;
@property (weak, nonatomic) IBOutlet UILabel *myOrderPayStateLB;

@property (nonatomic, copy)void(^payOrderBlock)(NSDictionary *infoDIc);

- (void)resetWithInfo:(NSDictionary *)infoDic;



@end
