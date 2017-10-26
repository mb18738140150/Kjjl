//
//  MainVCCourseTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/10/14.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainVCCourseTableViewCell : UITableViewCell

@property (nonatomic, copy)void(^MoreCourseClickBlock)();
@property (nonatomic, strong)UILabel *liveLB;
- (void)resetInfo;

@end
