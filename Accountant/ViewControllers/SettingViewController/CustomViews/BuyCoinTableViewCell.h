//
//  BuyCoinTableViewCell.h
//  Accountant
//
//  Created by aaa on 2018/5/13.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyCoinTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *goldLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageRight;
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;

@property (nonatomic, assign)BOOL isSelect;

- (void)resetWithInfo:(NSDictionary *)infoDic;

@end
