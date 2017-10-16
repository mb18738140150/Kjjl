//
//  LivingCourseCollectionViewCell.h
//  Accountant
//
//  Created by aaa on 2017/9/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LivingCourseCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)UIImageView * imageView;
@property (nonatomic, strong)UILabel     * titleLabel;
- (void)resetInfo:(NSDictionary *)infoDic;

- (void)resetTitleWith:(NSString *)title;

- (void)refreshTitletextColorWith:(UIColor *)color;

@end
