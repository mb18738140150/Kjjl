//
//  LivingCourseFlowLayout.m
//  Accountant
//
//  Created by aaa on 2017/9/29.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "LivingCourseFlowLayout.h"

@implementation LivingCourseFlowLayout

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    self.itemSize = CGSizeMake(48, 70);
    self.minimumInteritemSpacing = 5;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray * array = [super layoutAttributesForElementsInRect:rect];
    for (int i = 1; i < array.count; i++) {
        UICollectionViewLayoutAttributes * lastAtt = array[i - 1];
        CGFloat begainX = lastAtt.frame.origin.x + lastAtt.size.width / 3;
        UICollectionViewLayoutAttributes * attr = array[i];
        attr.transform = CGAffineTransformMakeTranslation(-(attr.frame.origin.y - begainX), 0);
    }
    return array;
}

@end
