//
//  TestQuestionAnswerTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/3/24.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestQuestionAnswerTableViewCell : UITableViewCell

@property (nonatomic, strong)UIView             *separateLine;

@property (nonatomic, strong)UIButton *idBT;

//@property (nonatomic,strong) UIView             *idView;
//@property (nonatomic,strong) UILabel            *idLabel;
@property (nonatomic,strong) UILabel            *contentLabel;

- (void)resetWithInfo:(NSDictionary *)infoDic andIsSelect:(BOOL)isSelected;

@end
