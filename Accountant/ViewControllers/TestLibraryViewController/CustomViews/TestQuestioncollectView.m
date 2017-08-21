//
//  TestQuestioncollectView.m
//  Accountant
//
//  Created by aaa on 2017/4/7.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestQuestioncollectView.h"
#import "UIMacro.h"
#import "CommonMacro.h"
#import "TestMacro.h"

@implementation TestQuestioncollectView

- (void)resetWithInfo:(NSDictionary *)infoDic andIsShowCollect:(BOOL)isShow
{
    self.backgroundColor = [UIColor clearColor];
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
        
        self.collectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 13, self.frame.size.height / 2 - 13, 25, 25)];
        
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
        
        
        [self addSubview:self.collectImageView];
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

- (void)resettitleWithInfo:(NSDictionary *)infoDic andIsShowCollect:(BOOL)isShow
{
    self.backgroundColor = [UIColor clearColor];
    
    
    if (isShow) {
        [self.collectionBT removeFromSuperview];
        
        self.collectionBT = [UIButton buttonWithType:UIButtonTypeCustom];
        self.collectionBT.frame = CGRectMake(0, 0, self.hd_width, self.hd_height);
        
        if (![[infoDic objectForKey:kTestQuestionIsCollected] boolValue]) {
            [self.collectionBT setImage:[UIImage imageNamed:@"tiku_收藏(1)"] forState:UIControlStateNormal];
            [self.collectionBT setTitle:@"收藏" forState:UIControlStateNormal];
            [self.collectionBT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            self.collectionBT.titleLabel.font = kMainFont;
            [self.collectionBT addTarget:self action:@selector(collectQuestion) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            [self.collectionBT setImage:[UIImage imageNamed:@"tiku_收藏-选中"] forState:UIControlStateNormal];
            [self.collectionBT setTitle:@"已收藏" forState:UIControlStateNormal];
            [self.collectionBT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            self.collectionBT.titleLabel.font = kMainFont;
            [self.collectionBT addTarget:self action:@selector(uncollectQuestion) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.collectionBT setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        
        [self addSubview:self.collectionBT];
        
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
