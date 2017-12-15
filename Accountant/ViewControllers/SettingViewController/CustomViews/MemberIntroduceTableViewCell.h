//
//  MemberIntroduceTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/11/7.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberIntroduceTableViewCell : UITableViewCell

@property (nonatomic, copy)void (^buyMemberBlock)();

@property (nonatomic, assign)BOOL noPayBtn;

- (void)resetCell;



@end
