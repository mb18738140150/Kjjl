//
//  DailyPracticeTableViewCell.h
//  Accountant
//
//  Created by aaa on 2018/1/20.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyPracticeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *detailLB;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@property (nonatomic, copy)void (^PracticeBlock)(NSDictionary *infoDic);
@property (nonatomic, strong)NSDictionary * infoDic;
- (void)resetWithInfoDic:(NSDictionary *)infoDic;

@end
