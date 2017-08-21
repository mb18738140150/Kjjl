//
//  AllCategoryTableViewCell.h
//  Accountant
//
//  Created by 阴天翔 on 2017/3/9.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllCategoryTableViewCell : UITableViewCell

@property (nonatomic,strong) UIButton           *firstButton;
@property (nonatomic,strong) UIButton           *secButton;

@property (nonatomic,strong) UIView             *lineView;

@property (nonatomic,strong) NSArray            *courseInfoArray;

- (void)resetOneCellContent:(NSArray *)array;

- (void)resetTwoCellContent:(NSArray *)array;


@end
