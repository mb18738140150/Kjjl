//
//  LiveStreamingTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/6/15.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveStreamingTableViewCell : UITableViewCell

@property (nonatomic, strong)NSArray * dataArray;

@property (nonatomic, copy)void(^clickBlock)(NSDictionary *infoDic);

@property (nonatomic, copy)void(^morelivingBlock)();

- (void)resetInfoWith:(NSArray *)dataArray;

@end
