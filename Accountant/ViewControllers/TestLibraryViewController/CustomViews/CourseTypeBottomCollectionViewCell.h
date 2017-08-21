//
//  CourseTypeBottomCollectionViewCell.h
//  Accountant
//
//  Created by aaa on 2017/6/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Type_collect,
    Type_wrong,
} SelectType;

@interface CourseTypeBottomCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *collectView;
@property (weak, nonatomic) IBOutlet UILabel *collectCount;

@property (weak, nonatomic) IBOutlet UIView *wrongView;
@property (weak, nonatomic) IBOutlet UILabel *wrongCountLB;

@property (nonatomic, assign)SelectType selectType;

@property (nonatomic, copy)void(^SelectTypeBlock)(SelectType type);

@end
