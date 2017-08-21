//
//  QuestionModel.h
//  Accountant
//
//  Created by aaa on 2017/3/3.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject

@property (nonatomic,strong) NSString       *questionContent;
@property (nonatomic,assign) int             questionId;
@property (nonatomic,strong) NSString       *questionTime;
@property (nonatomic,strong) NSString       *questionQuizzerHeaderImageUrl;
@property (nonatomic,strong) NSString       *questionQuizzerUserName;
@property (nonatomic,assign) int             questionQuizzerId;
@property (nonatomic,assign) int             questionReplyCount;
@property (nonatomic,assign) int             questionSeeCount;

@property (nonatomic, assign)NSArray * replyList;

@end
