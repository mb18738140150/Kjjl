//
//  QuestionDetailModel.h
//  Accountant
//
//  Created by aaa on 2017/3/7.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionReplyModel.h"

@interface QuestionDetailModel : NSObject

@property (nonatomic,strong) NSString       *questionQuizzerHeaderImageUrl;
@property (nonatomic,strong) NSString       *questionContent;
@property (nonatomic,strong) NSString       *questionTime;
@property (nonatomic,assign) int             questionReplyCount;
@property (nonatomic,assign) int             questionSeeCount;
@property (nonatomic,strong) NSString       *questionQuizzerUserName;
@property (nonatomic,strong) NSMutableArray *questionImgArray;

@property (nonatomic,strong) NSMutableArray *questionReplys;

- (void)removeAllReplys;
- (void)removeAllImages;

- (void)addQuestionReply:(QuestionReplyModel *)replyModel;
- (void)addImageUrl:(NSString *)str;

@end
