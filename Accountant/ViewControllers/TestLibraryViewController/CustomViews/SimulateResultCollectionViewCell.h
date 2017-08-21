//
//  SimulateResultCollectionViewCell.h
//  Accountant
//
//  Created by aaa on 2017/4/5.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimulateResultCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)UIImageView * imageView;
@property (nonatomic, strong)UILabel * questionNumberLabel;

- (void)resetCellWithinfo:(NSDictionary *)questionInfo;

@end
