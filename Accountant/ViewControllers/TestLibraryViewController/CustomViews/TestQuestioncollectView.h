//
//  TestQuestioncollectView.h
//  Accountant
//
//  Created by aaa on 2017/4/7.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TestModuleQuestionCollection <NSObject>

- (void)didQuestionCollect;
- (void)didQustionUncollect;

@end

@interface TestQuestioncollectView : UIView
@property (nonatomic,weak) id<TestModuleQuestionCollection>          delegate;

@property (nonatomic,strong) UIImageView                *collectImageView;
@property (nonatomic, strong)UIButton                   *collectionBT;

- (void)resetWithInfo:(NSDictionary *)infoDic andIsShowCollect:(BOOL)isShow;
- (void)resettitleWithInfo:(NSDictionary *)infoDic andIsShowCollect:(BOOL)isShow;
@end
