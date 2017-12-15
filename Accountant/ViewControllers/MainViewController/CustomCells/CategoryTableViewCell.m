//
//  CategoryTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "CategoryTableViewCell.h"
#import "MainViewMacro.h"
#import "UIMacro.h"
#import "CommonMacro.h"
#import "CategoryView.h"
#import "UIImage+Scale.h"

@interface CategoryTableViewCell ()

@property (nonatomic,strong) NSMutableArray         *categoryViews;
//@property (nonatomic,strong) UIView                 *bottomLineView;

@end

@implementation CategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetWithCategoryInfos:(NSArray *)infoArray
{
    if (self.backImageView) {
        return;
    }
    
    self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    
    self.backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, [UIImage imageGetHeight:[UIImage imageNamed:@"shouye-banner"]])];
    self.backImageView.image = [UIImage imageNamed:@"shouye-banner"];
    [self addSubview:self.backImageView];
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.backImageView.frame) - 20, kScreenWidth, kCellHeightOfCategoryView * 2 + 48)];
    [self addSubview:self.topView];
    self.topView.backgroundColor = [UIColor whiteColor];
//    self.topView.layer.cornerRadius = 15;
//    self.topView.layer.masksToBounds = YES;
    
    for (CategoryView *view in self.categoryViews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < infoArray.count; i++) {
        CategoryView *cateView = [[CategoryView alloc] initWithFrame:CGRectMake(i%4 * ((kScreenWidth)/4), i/4 * (kCellHeightOfCategoryView+10)+18, ((kScreenWidth)/4), kCellHeightOfCategoryView)];
        NSDictionary *cateInfo = [infoArray objectAtIndex:i];
        cateView.categoryId = [[cateInfo objectForKey:kCourseCategoryId] intValue];
        cateView.pageType = self.pageType;
        cateView.categoryName = [cateInfo objectForKey:kCourseCategoryName];
        cateView.categoryCoverUrl = [cateInfo objectForKey:kCourseCategoryCoverUrl];
        [cateView setupContents];
//        cateView.backgroundColor = kBackgroundGrayColor;
        [_topView addSubview:cateView];
        [self.categoryViews addObject:cateView];
    }
    
}

- (void)resetMainCategoryInfos:(NSArray *)infoArray
{
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kCellHeightOfCategoryView + 28)];
    [self addSubview:self.topView];
    self.topView.backgroundColor = [UIColor whiteColor];
    for (CategoryView *view in self.categoryViews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < infoArray.count; i++) {
        CategoryView *cateView = [[CategoryView alloc] initWithFrame:CGRectMake(i%4 * ((kScreenWidth)/4), i/4 * (kCellHeightOfCategoryView+10) + 14, ((kScreenWidth)/4), kCellHeightOfCategoryView)];
        NSDictionary *cateInfo = [infoArray objectAtIndex:i];
        cateView.categoryId = [[cateInfo objectForKey:kCourseCategoryId] intValue];
        cateView.pageType = self.pageType;
        cateView.categoryName = [cateInfo objectForKey:kCourseCategoryName];
        cateView.categoryCoverUrl = [cateInfo objectForKey:kCourseCategoryCoverUrl];
        [cateView setupContents];
        //        cateView.backgroundColor = kBackgroundGrayColor;
        [_topView addSubview:cateView];
        [self.categoryViews addObject:cateView];
    }
}

@end
