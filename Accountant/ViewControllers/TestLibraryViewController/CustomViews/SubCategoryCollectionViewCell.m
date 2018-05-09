//
//  SubCategoryCollectionViewCell.m
//  Accountant
//
//  Created by aaa on 2017/3/21.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "SubCategoryCollectionViewCell.h"
#import "CommonMacro.h"
#import "UIMacro.h"

@interface SubCategoryCollectionViewCell ()

@property (nonatomic,strong) UIImageView                *imageView;


@end

@implementation SubCategoryCollectionViewCell

- (void)resetViewWithDic:(NSDictionary *)infoDic indexPath:(NSIndexPath *)indexPath
{
    self.backgroundColor = [UIColor whiteColor];
    [self.imageView removeFromSuperview];
    [self.titleLabel removeFromSuperview];
    CGSize cellSize = self.frame.size;
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(cellSize.width/2 - 20, 10, 40, 40)];
    //        subImageView.backgroundColor = [UIColor grayColor];
//    self.imageView.image = [UIImage imageNamed:[infoDic objectForKey:kTestCategoryImageName]];
//    [self addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, cellSize.width - 50, 30)];
    if (indexPath.row%2 != 0) {
        self.titleLabel.frame = CGRectMake(10, 5, cellSize.width - 50, 30);
    }
    self.titleLabel.backgroundColor = kBackgroundGrayColor;
    self.titleLabel.text = [infoDic objectForKey:kTestCategoryName];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    self.titleLabel.textColor = kMainTextColor_100;
    [self addSubview:self.titleLabel];
}

- (void)resetViewWithDic:(NSDictionary *)infoDic position:(int)position
{
    self.backgroundColor = kBackgroundGrayColor;
    [self.titleLabel removeFromSuperview];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, self.frame.size.width - 30, 30)];
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    self.titleLabel.text = [infoDic objectForKey:kCourseName];
    self.titleLabel.textAlignment = position;
    
    if (position == 0) {
        self.titleLabel.frame = CGRectMake(15, 0.5, self.frame.size.width - 30, self.hd_height - 0.5);
        self.titleLabel.text = [NSString stringWithFormat:@"  %@", [infoDic objectForKey:@"title"]];
    }
    
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    self.titleLabel.textColor = kMainTextColor_100;
    [self addSubview:self.titleLabel];
}

@end
