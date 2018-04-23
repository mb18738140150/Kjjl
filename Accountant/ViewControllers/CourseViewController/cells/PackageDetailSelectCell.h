//
//  PackageDetailSelectCell.h
//  Accountant
//
//  Created by aaa on 2018/4/18.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PackageDetailSelectCell : UICollectionViewCell

@property (nonatomic, strong)UILabel * titleLB;
@property (nonatomic, strong)NSDictionary * infoDic;

- (void)refreshWithInfo:(NSDictionary *)infoDic;

- (void)resetSelectState;

@end
