//
//  LivingCourseDetailCell.h
//  Accountant
//
//  Created by aaa on 2018/5/8.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LivingCourseDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UILabel *sectionCountLB;
@property (weak, nonatomic) IBOutlet UILabel *teacherLB;
@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (nonatomic, strong)NSDictionary * infoDic;
@property (nonatomic, copy)void(^payBlock)(NSDictionary * infoDic);

- (void) resetWithInfoDic:(NSDictionary *)infoDic;

@end
