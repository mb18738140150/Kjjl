//
//  PackageCountView.h
//  Accountant
//
//  Created by aaa on 2018/4/17.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PackageCountView : UIView

@property (nonatomic, strong)UIButton * musBtn;
@property (nonatomic, strong)UILabel * countLB;
@property (nonatomic, strong)UIButton * addBtn;

@property (nonatomic, copy)void(^countBlock)(int count);

- (void)reset;

@end
