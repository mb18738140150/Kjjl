//
//  LivingSectionDetailTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/9/21.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PlayType_living,
    PlayType_order,
    PlayType_videoBack,
} PlayType;

@interface LivingSectionDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *courseSectionNameLB;
@property (weak, nonatomic) IBOutlet UILabel *courseSectionTime;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *playTimeLB;

@property (weak, nonatomic) IBOutlet UIView *stateView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *stateBackView;

@property (nonatomic, copy)void(^PlayBlock)(PlayType playType);

- (void)resetInfoWithDic:(NSDictionary *)dicInfo;

@end
