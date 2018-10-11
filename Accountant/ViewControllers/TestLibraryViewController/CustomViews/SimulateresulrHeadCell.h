//
//  SimulateresulrHeadCell.h
//  Accountant
//
//  Created by aaa on 2017/4/5.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SimulateresulrHeadCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *scoreLB;
@property (weak, nonatomic) IBOutlet UILabel *rightLB;

@property (weak, nonatomic) IBOutlet UILabel *wrongnumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ScoreLBHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scoreLBWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconImageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wrongCountLBHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wrongLBHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightCountLBHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLBHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rateLBHeight;

@property (nonatomic, assign)int time;

- (void)resetWithInfo:(NSDictionary *)dic;
- (void)resetScoreWithInfo:(NSDictionary *)dic;
@end
