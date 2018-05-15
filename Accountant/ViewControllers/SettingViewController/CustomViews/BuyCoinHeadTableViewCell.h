//
//  BuyCoinHeadTableViewCell.h
//  Accountant
//
//  Created by aaa on 2018/5/13.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyCoinHeadTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *iconLB;

- (void)resetWith:(int)coinCount;

@end
