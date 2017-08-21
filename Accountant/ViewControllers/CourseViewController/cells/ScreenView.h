//
//  ScreenView.h
//  Accountant
//
//  Created by aaa on 2017/4/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenView : UIView

- (instancetype)initWithFrame:(CGRect)frame withArr:(NSArray*)titleArr;

@property (nonatomic, strong)NSMutableArray *titleArr;
@property (nonatomic, copy)void(^selectBlock)(NSString *selectType, NSInteger item);

- (void)selectCourse:(NSString *)title index:(int)row;

@end
