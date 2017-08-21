//
//  HistoryTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/3/17.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonMacro.h"

@interface HistoryTableViewCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *cellInfoDic;

- (void)resetCellWithInfo:(NSDictionary *)infoDic;

@end
