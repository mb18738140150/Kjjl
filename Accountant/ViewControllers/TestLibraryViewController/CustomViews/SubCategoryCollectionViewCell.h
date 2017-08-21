//
//  SubCategoryCollectionViewCell.h
//  Accountant
//
//  Created by aaa on 2017/3/21.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubCategoryCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UILabel                    *titleLabel;
- (void)resetViewWithDic:(NSDictionary *)infoDic indexPath:(NSIndexPath *)indexPath;

- (void)resetViewWithDic:(NSDictionary *)infoDic position:(int)position;

@end
