//
//  DredgeMemberPriceselectTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/12/5.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DredgeMemberPriceselectTableViewCell : UITableViewCell

@property (nonatomic, copy)void(^memberlevelSelectBlock)(NSDictionary *infoDic);
@property (nonatomic, copy)void(^lookMemberDetailBlock)();

@property (nonatomic, strong)NSString * memberLevel;
- (void)resetCell;



@end
