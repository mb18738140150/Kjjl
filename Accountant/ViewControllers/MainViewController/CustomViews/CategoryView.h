//
//  CategoryView.h
//  Accountant
//
//  Created by aaa on 2017/3/6.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PageMain,
    PageCategory,
    PageMessage,
    PageLeft
}PageType;

@interface CategoryView : UIView

@property (nonatomic,strong) UIImageView            *coverImageView;
@property (nonatomic,strong) UILabel                *categoryNameLabel;
@property (nonatomic, strong) UILabel               *numberLabel;

@property (nonatomic,assign) int                     categoryId;
@property (nonatomic,strong) NSString               *categoryName;
@property (nonatomic,strong) NSString               *categoryCoverUrl;

@property (nonatomic,assign) PageType                pageType;

- (void)setupContents;
- (void)setupNaviContents;

@end
