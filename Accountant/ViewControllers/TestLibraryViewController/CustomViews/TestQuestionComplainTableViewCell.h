//
//  TestQuestionComplainTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/3/24.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestQuestionComplainTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel            *complainLabel;
@property (nonatomic,strong) UILabel            *titleLabel;

@property (nonatomic, strong)UITextView * contentLB;
@property (nonatomic, assign)BOOL isTextAnswer;

- (void)resetWithInfo:(NSDictionary *)infoDic;

@end
