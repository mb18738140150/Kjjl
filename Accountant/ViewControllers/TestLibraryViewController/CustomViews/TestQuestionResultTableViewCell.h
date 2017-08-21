//
//  TestQuestionResultTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/3/24.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestMacro.h"

@interface TestQuestionResultTableViewCell : UITableViewCell

@property (nonatomic,strong) UIView         *bgView;

@property (nonatomic,strong) UILabel        *correctLabel;
@property (nonatomic,strong) UILabel        *myLabel;

@property (nonatomic,strong) UILabel        *correctTextLabel;
@property (nonatomic,strong) UILabel        *myTextLabel;

- (void)resetWithInfo:(NSDictionary *)infoDic;

@end
