//
//  TestQuestionHeaderTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/3/24.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestQuestionHeaderTableViewCell.h"
#import "UIMacro.h"
#import "CommonMacro.h"
#import "TestMacro.h"

@implementation TestQuestionHeaderTableViewCell

- (void)resetWithInfo:(NSDictionary *)infoDic andIsShowCollect:(BOOL)isShow
{
    self.backgroundColor = kBackgroundGrayColor;
/*    [self.questionCountLabel removeFromSuperview];
    [self.questionCurrentLabel removeFromSuperview];
    
    self.questionCurrentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-140, 0, 60, kHeightOfQuestionHeadTitleView)];
    self.questionCurrentLabel.textAlignment = NSTextAlignmentRight;
    self.questionCurrentLabel.text = [NSString stringWithFormat:@"%d",self.questionCurrentIndex+1];
    self.questionCurrentLabel.textColor = kCommonNavigationBarColor;
    self.questionCurrentLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.questionCurrentLabel];
    
    self.questionCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-80, 0, 60, kHeightOfQuestionHeadTitleView)];
    self.questionCountLabel.textAlignment = NSTextAlignmentRight;
    self.questionCountLabel.text = [NSString stringWithFormat:@" / %d",self.questionTotalCount];
    self.questionCountLabel.textColor = [UIColor grayColor];
    self.questionCountLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.questionCountLabel];*/
    
    if (isShow) {
        [self.collectImageView removeFromSuperview];
        
        self.collectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 50, 10, 30, 30)];
        
        if (![[infoDic objectForKey:kTestQuestionIsCollected] boolValue]) {
            self.collectImageView.image = [UIImage imageNamed:@"collect.png"];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collectQuestion)];
            [self.collectImageView addGestureRecognizer:tap];
            self.collectImageView.userInteractionEnabled = YES;
        }else{
            self.collectImageView.image = [UIImage imageNamed:@"collected.png"];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uncollectQuestion)];
            [self.collectImageView addGestureRecognizer:tap];
            self.collectImageView.userInteractionEnabled = YES;
        }
        
        
//        [self addSubview:self.collectImageView];
        
/*        [self.questionBookmarkButton removeFromSuperview];
        
        self.questionBookmarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.questionBookmarkButton.frame = CGRectMake(kScreenWidth - 100, 0, 80, 50);
        self.questionBookmarkButton.titleLabel.font = [UIFont systemFontOfSize:16];
        NSLog(@"%@",[infoDic objectForKey:kTestQuestionIsCollected]);
        if ([[infoDic objectForKey:kTestQuestionIsCollected] boolValue]) {
            [self.questionBookmarkButton setTitle:@"已收藏" forState:UIControlStateNormal];
            [self.questionBookmarkButton setTitleColor:kCommonNavigationBarColor forState:UIControlStateNormal];
        }else{
            [self.questionBookmarkButton setTitle:@"收藏" forState:UIControlStateNormal];
            [self.questionBookmarkButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.questionBookmarkButton addTarget:self action:@selector(collectQuestion) forControlEvents:UIControlEventTouchUpInside];
        }
        [self addSubview:self.questionBookmarkButton];*/
    }
    
    
    
    
}

- (void)collectQuestion
{
    [self.delegate didQuestionCollect];
}

- (void)uncollectQuestion
{
    [self.delegate didQustionUncollect];
}

@end
