//
//  ClassroomLivingTableViewCell_IPAD.h
//  Accountant
//
//  Created by aaa on 2018/10/11.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShakeView.h"

@interface ClassroomLivingTableViewCell_IPAD : UITableViewCell


@property (strong, nonatomic)  UILabel *payTypeLB;


@property (strong, nonatomic)  UIImageView *bofangImageView;

@property (strong, nonatomic)  UIImageView *livingIconImageView;// 课程图片
@property (strong, nonatomic)  UILabel *livingTitleleLabel;// 课程名称
@property (strong, nonatomic)  UILabel *livingStartTimeLB;// 开课时间

@property (strong, nonatomic)  UIImageView *teacherIconImageView;// 老师头像
@property (strong, nonatomic)  UILabel *teachernameLB;

@property (strong, nonatomic)  UIImageView *livingStateImageView;// 直播时间倒计时
@property (strong, nonatomic)  UILabel *timeLB;

@property (strong, nonatomic)  UIButton *stateBT;

@property (strong, nonatomic)  UIView *markView;
@property (strong, nonatomic) ShakeView *shakeView;
@property (strong, nonatomic)  UILabel *livingLabel;


@property (nonatomic, copy)void(^countDownFinishBlock)();

@property(nonatomic, assign)BOOL livingDetailVC;

@property (nonatomic, copy)void(^LivingPlayBlock)(LivingPlayType playType);

- (void)resetWithDic:(NSDictionary *)infoDic;

@end
