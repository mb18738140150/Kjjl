//
//  QuestionReplyTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/3/7.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionReplyTableViewCell : UITableViewCell

@property (nonatomic, copy)void (^askBlock)(NSDictionary *infoDic);

- (void)resetCellWithInfo:(NSDictionary *)dic;

- (void)resetLivingDetailCellWithInfoDic:(NSDictionary *)infoDic;

@end
