//
//  StudyPlanConditionView.h
//  Accountant
//
//  Created by aaa on 2017/12/8.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudyPlanConditionView : UIView

@property (nonatomic, copy)void(^SelectConditionBlock)(NSInteger tag);
@property (nonatomic, strong)UIImageView * imageView ;
@property (nonatomic, strong)UILabel * titleLB;
- (void)selectAction;
- (void)nomalAction;

- (void)resetTitle:(NSString *)title;

@end
