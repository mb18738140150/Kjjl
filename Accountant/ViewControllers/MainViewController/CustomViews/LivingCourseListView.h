//
//  LivingCourseListView.h
//  Accountant
//
//  Created by aaa on 2017/10/11.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LivingCourseListView : UIView

@property (nonatomic, strong)void(^LivingPlayViewBlock)(NSDictionary *infoDic,NSInteger playType);

@property (nonatomic, copy)void(^countDownBlock)(NSDictionary *infoDic);

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSArray * dataArr;

@property (nonatomic, strong)NSDictionary * selectLivingSectionInfoDic;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)removeAll;

@end
