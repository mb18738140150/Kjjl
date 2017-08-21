//
//  ReplyView.h
//  Accountant
//
//  Created by aaa on 2017/6/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplyView : UIView

@property (nonatomic, strong)UIImageView *iconImageView;
@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UILabel * remarkLB;
@property (nonatomic, strong)UILabel *timeLB;

@property (nonatomic, strong)UILabel *contentLB;

@property (nonatomic, assign)CGFloat height;
@property (nonatomic, assign)CGPoint point;

- (instancetype)initWithFrame:(CGRect)frame tipPoint:(CGPoint)toppoint;

- (void)resetInfo:(NSDictionary *)infoDic;

@end
