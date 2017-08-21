//
//  HistoryDayModel.h
//  Accountant
//
//  Created by aaa on 2017/3/18.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HistoryDisplayModel.h"

@interface HistoryDayModel : NSObject

@property (nonatomic,strong) NSString               *timeString;
@property (nonatomic,strong) NSMutableArray         *historyModels;

- (void)removeAllHistory;

- (void)addHistory:(HistoryDisplayModel *)model;

@end
