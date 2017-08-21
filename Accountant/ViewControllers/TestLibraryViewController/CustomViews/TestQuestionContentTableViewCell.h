//
//  TestQuestionContentTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/3/24.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestQuestionContentTableViewCell : UITableViewCell

@property (nonatomic, strong)UIView             *headView;
@property (nonatomic,strong) UILabel            *testTypeLabel;
@property (nonatomic,strong) UILabel            *testContentLabel;


@property (nonatomic,strong) UILabel                    *questionCurrentLabel;
@property (nonatomic,strong) UILabel                    *questionCountLabel;
@property (nonatomic,assign) int                         questionTotalCount;
@property (nonatomic,assign) int                         questionCurrentIndex;

- (void)resetWithInfo:(NSDictionary *)infoDic;

@end
