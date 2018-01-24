//
//  CategorySectionHeadView.h
//  tiku
//
//  Created by aaa on 2017/5/16.
//  Copyright © 2017年 ytx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MFoldingSectionState) {
    
    MFoldingSectionStateFlod, // 折叠
    MFoldingSectionStateShow, // 打开
};

// 箭头的位置
typedef NS_ENUM(NSUInteger, MFoldingSectionHeaderArrowPosition) {
    
    MFoldingSectionHeaderArrowPositionLeft,
    MFoldingSectionHeaderArrowPositionRight,
};
@protocol MFoldingSectionHeaderDelegate <NSObject>

- (void)MFoldingSectionHeaderTappedAtIndex:(NSInteger)index;

@end


@interface CategorySectionHeadView : UIView

@property (nonatomic, weak)id<MFoldingSectionHeaderDelegate> tapDelegate;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, assign)BOOL   isChapter;

-(instancetype)initWithFrame:(CGRect)frame withTag:(NSInteger)tag;

-(void)setupWithBackgroundColor:(UIColor *)backgroundColor
                    titleString:(NSString *)titleString
                     titleColor:(UIColor *)titleColor
                      titleFont:(UIFont *)titleFont
              descriptionString:(NSString *)descriptionString
               descriptionColor:(UIColor *)descriptionColor
                descriptionFont:(UIFont *)descriptionFont
              peopleCountString:(NSString *)peopleCountString
               peopleCountColor:(UIColor *)peopleCountColor
                peopleCountFont:(UIFont *)peopleCountFont
                     arrowImage:(UIImage *)arrowImage
                     learnImage:(UIImage *)learnImage
                  arrowPosition:(MFoldingSectionHeaderArrowPosition)arrowPosition
                   sectionState:(MFoldingSectionState)sectionState;

-(void)setupVideoWithBackgroundColor:(UIColor *)backgroundColor
                    titleString:(NSString *)titleString
                     titleColor:(UIColor *)titleColor
                      titleFont:(UIFont *)titleFont
                     arrowImage:(UIImage *)arrowImage
                     learnImage:(UIImage *)learnImage
                  arrowPosition:(MFoldingSectionHeaderArrowPosition)arrowPosition
                   sectionState:(MFoldingSectionState)sectionState;

@end
