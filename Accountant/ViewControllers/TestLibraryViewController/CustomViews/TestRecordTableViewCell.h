//
//  TestRecordTableViewCell.h
//  Accountant
//
//  Created by aaa on 2018/1/19.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *pointImageView;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *detailLB;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UILabel *noComplateLB;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *title_y;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detail_y;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clickBtn_w;


@property (nonatomic, assign)BOOL isShowTime;
@property (nonatomic, assign)BOOL isLast;
@property (nonatomic, assign)BOOL isFirst;
@property (nonatomic, assign)BOOL isDailyPractice;
@property (nonatomic, strong)NSDictionary * infoDic;
@property (nonatomic, copy)void (^lookBlock)(NSDictionary * infoDic);
- (void)resetWithInfoDic:(NSDictionary *)infoDic;


@end
