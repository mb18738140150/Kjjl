//
//  SimpleHeaderCollectionViewCell.h
//  Accountant
//
//  Created by aaa on 2017/3/21.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleHeaderCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIView             *grayView;
@property (nonatomic,strong) UILabel            *categoryLabel;
@property (nonatomic,strong) UIView             *lineView;

- (void)resetViewWithInfo:(NSString *)dic;

@end
