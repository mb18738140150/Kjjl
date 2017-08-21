//
//  CategoryTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryView.h"

@interface CategoryTableViewCell : UITableViewCell

- (void)resetWithCategoryInfos:(NSArray *)infoArray;

@property (nonatomic,assign) PageType            pageType;

@property (nonatomic, strong)UIImageView *backImageView;

@property (nonatomic, strong)UIView *topView;

@end
