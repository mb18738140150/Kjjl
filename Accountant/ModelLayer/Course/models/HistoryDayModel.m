//
//  HistoryDayModel.m
//  Accountant
//
//  Created by aaa on 2017/3/18.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "HistoryDayModel.h"

@implementation HistoryDayModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.historyModels = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)removeAllHistory
{
    [self.historyModels removeAllObjects];
}

- (void)addHistory:(HistoryDisplayModel *)model
{
    [self.historyModels addObject:model];
}

@end
