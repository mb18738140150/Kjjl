//
//  InputTextTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/3/7.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputTextTableViewCell : UITableViewCell

@property (nonatomic,strong)  UILabel           *infoLabel;
@property (nonatomic,strong)  UITextField       *inputTextField;
@property (nonatomic,strong)  UIView            *bottomLineView;

- (void)resetWithInfo:(NSDictionary *)dic;

@end
