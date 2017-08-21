//
//  AnswerCardAnswerCollectionViewCell.h
//  Accountant
//
//  Created by aaa on 2017/3/30.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerCardAnswerCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) NSDictionary           *dic;

@property (nonatomic,strong) UIView                 *bgView;

@property (nonatomic,strong) UILabel                *answerLabel;

- (void)resetCellWithInfo:(NSDictionary *)infoDic;

@end
