//
//  ClassroomLivingTableViewCell.h
//  tiku
//
//  Created by aaa on 2017/5/12.
//  Copyright © 2017年 ytx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShakeView.h"

typedef enum : NSUInteger {
    LivingPlayType_order,
    LivingPlayType_ordered,
    LivingPlayType_living,
    LivingPlayType_videoBack,
} LivingPlayType;

@interface ClassroomLivingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *payTypeLB;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLBWidth;
@property (weak, nonatomic) IBOutlet UIImageView *livingStateImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payLB_left;


@property (weak, nonatomic) IBOutlet UIImageView *livingIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *livingTitleleLabel;
@property (weak, nonatomic) IBOutlet UILabel *livingTeacherNameLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@property (weak, nonatomic) IBOutlet UIButton *stateBT;

@property (weak, nonatomic) IBOutlet UIView *markView;
@property (weak, nonatomic) IBOutlet ShakeView *shakeView;
@property (weak, nonatomic) IBOutlet UILabel *livingLabel;

@property (weak, nonatomic) IBOutlet UIImageView *CountDownImageView;
@property (weak, nonatomic) IBOutlet UILabel *countDowmLB;

@property (weak, nonatomic) IBOutlet UIImageView *teacherIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *teachernameLB;

@property (nonatomic, copy)void(^countDownFinishBlock)();

@property (nonatomic, copy)void(^LivingPlayBlock)(LivingPlayType playType);

- (void)resetWithDic:(NSDictionary *)infoDic;

@end
