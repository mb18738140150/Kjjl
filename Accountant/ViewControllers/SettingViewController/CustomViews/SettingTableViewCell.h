//
//  SettingTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/6/26.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewCell : UITableViewCell

@property (nonatomic, copy)void(^upgradeMemberLevelBlock)();

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIButton *memberLevelBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipDetailLB;

@property (weak, nonatomic) IBOutlet UIImageView *tipImageView;

- (void)resetMemberWithInfo:(NSDictionary *)infoDic andHaveNewActivty:(BOOL)haveActivity;

- (void)resetcellWithInfo:(NSDictionary *)infoDic andHaveNewActivty:(BOOL)haveActivity;


@end
