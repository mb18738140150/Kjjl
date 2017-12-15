//
//  HYSegmentedControl.h
//  CustomSegControlView
//
//  Created by sxzw on 14-6-12.
//  Copyright (c) 2014年 sxzw. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYSegmentedControlDelegate <NSObject>

@required
//代理函数 获取当前下标
- (void)hySegmentedControlSelectAtIndex:(NSInteger)index;

@end

@interface HYSegmentedControl : UIView

@property (nonatomic,assign)BOOL drop;
@property (assign, nonatomic) id<HYSegmentedControlDelegate>delegate;
@property (nonatomic, assign)int selectIndex;

//初始化函数 
- (id)initWithOriginY:(CGFloat)y Titles:(NSArray *)titles delegate:(id)delegate;
- (id)initWithOriginX:(CGFloat)X OriginY:(CGFloat)y Titles:(NSArray *)titles delegate:(id)delegate;

- (id)initWithOriginY:(CGFloat)y Titles:(NSArray *)titles delegate:(id)delegate drop:(BOOL)drop;
- (id)initWithOriginY:(CGFloat)y Titles:(NSArray *)titles delegate:(id)delegate drop:(BOOL)drop color:(UIColor *)color;
- (id)initWithOriginX:(CGFloat)X OriginY:(CGFloat)y Titles:(NSArray *)titles delegate:(id)delegate  drop:(BOOL)drop;
- (id)initWithOriginX:(CGFloat)X OriginY:(CGFloat)y Titles:(NSArray *)titles delegate:(id)delegate  drop:(BOOL)drop color:(UIColor *)color;

//提供方法改变 index
- (void)changeSegmentedControlWithIndex:(NSInteger)index;

- (void)clickBT:(NSInteger)index;

- (void)changeTitle:(NSString *)title withIndex:(NSInteger)index;

- (void)addTipWithIndex:(NSInteger)index;
- (void)cancelTipWithIndex:(NSInteger)index;

- (void)hideTitlesWith:(NSArray *)titlesArray;
- (void)showTitlesWith:(NSArray *)titlesArray;

- (void)resetColor:(UIColor *)color;
- (void)hideBottomLine;

@end
