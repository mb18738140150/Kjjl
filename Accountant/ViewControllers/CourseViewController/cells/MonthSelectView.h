//
//  MonthSelectView.h
//  Accountant
//
//  Created by aaa on 2017/9/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthSelectView : UIView

@property (nonatomic, strong)NSIndexPath *selectIndexpath;

@property (nonatomic, copy)void(^MonthSelectBlock)(int month);

- (void)reloadData;

@end
