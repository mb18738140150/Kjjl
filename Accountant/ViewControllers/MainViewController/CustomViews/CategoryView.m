//
//  CategoryView.m
//  Accountant
//
//  Created by aaa on 2017/3/6.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "CategoryView.h"
#import "MainViewMacro.h"
#import "UIImageView+WebCache.h"
#import "CommonMacro.h"
#import "NotificaitonMacro.h"

@implementation CategoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2-frame.size.height / 4 - 3.5, 0, frame.size.height / 2 + 7, frame.size.height / 2 + 7)];
        
        
        self.categoryNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.coverImageView.frame), frame.size.width, frame.size.height - self.coverImageView.frame.size.height)];
        
        self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.coverImageView.frame), 0, self.coverImageView.frame.size.height / 3, self.coverImageView.frame.size.height / 3)];
    }
    return self;
}

- (void)setupContents
{
    self.categoryNameLabel.text = self.categoryName;
    self.categoryNameLabel.textAlignment = NSTextAlignmentCenter;
    self.categoryNameLabel.font = [UIFont systemFontOfSize:12];
    self.categoryNameLabel.textColor = kMainTextColor_100;
    
    //    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.categoryCoverUrl]];
    self.coverImageView.image = [UIImage imageNamed:self.categoryCoverUrl];
    //    self.coverImageView.layer.cornerRadius = self.coverImageView.frame.size.height / 2;
    //    self.coverImageView.layer.masksToBounds = YES;
    //    self.coverImageView.layer.borderWidth = 0.5;
    //    self.coverImageView.layer.borderColor = kMainTextColor_100.CGColor;
    
    
    self.numberLabel.textColor = [UIColor whiteColor];
    self.numberLabel.textAlignment = 1;
    self.numberLabel.font = [UIFont systemFontOfSize:12];
    self.numberLabel.text = @"8";
    self.numberLabel.backgroundColor = kCommonMainColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    
    [self addSubview:self.coverImageView];
    [self addSubview:self.categoryNameLabel];
    //    [self addSubview:self.numberLabel];
}
- (void)setupNaviContents
{
    self.categoryNameLabel.text = self.categoryName;
    self.categoryNameLabel.textAlignment = NSTextAlignmentCenter;
    self.categoryNameLabel.font = [UIFont systemFontOfSize:12];
    self.categoryNameLabel.textColor = kMainTextColor;
    self.coverImageView.frame = CGRectMake(0, 0, self.frame.size.height , self.frame.size.height );
    
    self.coverImageView.image = [UIImage imageNamed:self.categoryCoverUrl];
    
    self.numberLabel.frame = CGRectMake(CGRectGetMaxX(self.coverImageView.frame), 0, self.coverImageView.frame.size.height / 2, self.coverImageView.frame.size.height / 2);
    self.numberLabel.textColor = [UIColor whiteColor];
    self.numberLabel.textAlignment = 1;
    self.numberLabel.font = [UIFont systemFontOfSize:9];
    self.numberLabel.text = @"8";
    self.numberLabel.backgroundColor = [UIColor redColor];
    self.numberLabel.layer.cornerRadius = self.numberLabel.frame.size.height / 2;
    self.numberLabel.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    
    [self addSubview:self.coverImageView];
    [self addSubview:self.categoryNameLabel];
    //    [self addSubview:self.numberLabel];
}
- (void)click
{
    NSDictionary *dic = @{kCourseCategoryName:self.categoryName,
                          kCourseCategoryId:@(self.categoryId)};
    if (self.pageType == PageMain) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfMainPageCategoryClick object:dic];
    }
    if (self.pageType == PageCategory) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfCategoryPageCategoryClick object:dic];
    }
    if (self.pageType == PageMessage) {
        NSLog(@"点击了消息中心");
    }
    if (self.pageType == PageLeft) {
        NSLog(@"点击了左上角");
    }
}

@end
