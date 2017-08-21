//
//  QuestionModuleModels.h
//  Accountant
//
//  Created by aaa on 2017/3/3.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionModel.h"
#import "ShowQuestionModel.h"
#import "QuestionDetailModel.h"

@interface QuestionModuleModels : NSObject

@property (nonatomic,assign) BOOL                isLoadMax;

@property (nonatomic,assign) int                 currentQuestionPageCount;

//答疑界面显示的问题
@property (nonatomic,strong) ShowQuestionModel  *showQuestionModel;

//首页界面显示的问题
@property (nonatomic,strong) ShowQuestionModel  *mainViewQuestionModel;

//点进问题详情里的信息
@property (nonatomic,strong) QuestionDetailModel    *questionDetailModel;

//已回答和未回答的问题列表
@property (nonatomic,strong) NSMutableArray         *alreadyReplyQuestionArray;
@property (nonatomic,strong) NSMutableArray         *notReplyQuestionArray;

- (int)nextPage;

- (void)resetLoadInfos;

@end
