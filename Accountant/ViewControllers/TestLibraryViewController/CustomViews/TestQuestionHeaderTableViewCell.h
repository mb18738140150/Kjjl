//
//  TestQuestionHeaderTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/3/24.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TestModuleQuestionCollection <NSObject>

- (void)didQuestionCollect;
- (void)didQustionUncollect;

@end

@interface TestQuestionHeaderTableViewCell : UITableViewCell

@property (nonatomic,weak) id<TestModuleQuestionCollection>          delegate;

@property (nonatomic,strong) UILabel                    *questionCurrentLabel;
@property (nonatomic,strong) UILabel                    *questionCountLabel;
@property (nonatomic,assign) int                         questionTotalCount;
@property (nonatomic,assign) int                         questionCurrentIndex;

@property (nonatomic,strong) UIButton                   *questionBookmarkButton;

@property (nonatomic,strong) UIImageView                *collectImageView;

- (void)resetWithInfo:(NSDictionary *)infoDic andIsShowCollect:(BOOL)isShow;

@end
