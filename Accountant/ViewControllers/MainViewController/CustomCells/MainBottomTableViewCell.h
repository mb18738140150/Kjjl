//
//  MainBottomTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/6/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainBottomTableViewCell : UITableViewCell

@property (nonatomic, strong)UILabel *liveLB;
@property (nonatomic, strong)UIImageView * goImageView;

- (void)resetInfo;

@end
