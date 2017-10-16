//
//  LiveStreamingCollectionViewCell.h
//  Accountant
//
//  Created by aaa on 2017/6/15.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveStreamingCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)UILabel * pointLabel;
@property (nonatomic, strong)UIImageView *pointImageView;
@property (nonatomic, strong)UILabel * timeLB;
@property (nonatomic, strong)UIView * lineView;

@property (nonatomic, strong)UIImageView * imageView;



@property (nonatomic, strong)UILabel * stateLabel;

@property (nonatomic, strong)UILabel * titleLB;
@property (nonatomic, strong)UILabel * countLB;

@property (nonatomic, strong)UILabel * timeLabel;

- (void)resetInfoWith:(NSDictionary *)infoDic;

@end
