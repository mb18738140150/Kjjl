//
//  ClassroomLivingTableViewCell.h
//  tiku
//
//  Created by aaa on 2017/5/12.
//  Copyright © 2017年 ytx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassroomLivingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *livingIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *livingTitleleLabel;
@property (weak, nonatomic) IBOutlet UILabel *livingTeacherNameLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@property (weak, nonatomic) IBOutlet UIButton *stateBT;

- (void)resetWithDic:(NSDictionary *)infoDic;

@end
