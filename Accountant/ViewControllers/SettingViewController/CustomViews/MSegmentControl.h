//
//  MSegmentControl.h
//  Accountant
//
//  Created by aaa on 2017/11/9.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSegmentControl : UIView

@property (nonatomic, copy)void (^segmentClickBlock)(int index);

- (instancetype)initWithFrame:(CGRect)frame andItems:(NSArray *)items;

- (void)selectWith:(int)tag;

@end
