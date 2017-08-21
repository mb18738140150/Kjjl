//
//  QuestionManager.h
//  Accountant
//
//  Created by aaa on 2017/3/2.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionModuleProtocol.h"

@interface QuestionManager : NSObject

+ (instancetype)sharedManager;


/**
 判断答疑问题是否都加载完了

 @return 是否加载完毕
 */
- (BOOL)isLoadMax;



/**
 下拉刷新时重置请求信息
 */
- (void)resetQuestionRequestConfig;


/**
 请求当前答疑信息，首次进入答疑页面请求的方法

 @param object 请求成功后通知的对象
 */
- (void)didCurrentPageQuestionRequestWithNotifiedObject:(id<QuestionModule_QuestionProtocol>)object;


/**
 请求下页答疑信息，用于下拉加载更多实用

 @param object 请求成功后通知的对象
 */
- (void)didNextPageQuestionRequestWithNotifiedObject:(id<QuestionModule_QuestionProtocol>)object;


/**
 请求某一问题、回答的详情

 @param questionId 问题id
 @param object 请求成功后通知的对象
 */
- (void)didRequestQuestionDetailWithQuestionId:(int)questionId andNotifiedObject:(id<QuestionModule_QuestionDetailProtocol>)object;


/**
 请求首页显示的问答信息

 @param object 请求成功后通知的对象
 */
- (void)didRequestMainPageQuestionRequestWithNotifiedObject:(id<QuestionModule_QuestionProtocol>)object;


/**
 发布问题请求的函数

 @param dicInfo 发布的问题信息
 @param object 请求成功后通知的对象
 */
- (void)didRequestPublishQuestionWithQuestionInfos:(NSDictionary *)dicInfo withNotifiedObject:(id<QuestionModule_QuestionPublishProtocol>)object;


/**
 请求已回答的问题的信息

 @param object 请求成功后通知的对象
 */
- (void)didRequestMyQuestionAlreadyReplyWithNotifiedObject:(id<QuestionModule_MyQuestionAlreadyReply>)object;


/**
 请求未回答道问题的信息

 @param object 请求成功后通知的对象
 */
- (void)didRequestMyQuestionNotReplyWithNotifiedObject:(id<QuestionModule_MyQuestionNotReply>)object;


/**
 获取答疑问题信息的接口

 @return 问题的信息
 */
- (NSArray *)getQuestionsInfos;


/**
 获取主页答疑问题信息接口
 
 @return 问题信息
 */
- (NSArray *)getMainQuestionInfos;


/**
 获取答疑问题详情接口，用于显示答疑详情页面信息

 @return 答疑详情信息
 */
- (NSDictionary *)getDetailQuestionInfo;


/**
 获取答疑回答信息借口，用于显示在答疑详情页面中

 @return 问题回复信息
 */
- (NSArray *)getDetailQuestionReplyArray;


/**
 获取我的 答疑 已回答道信息

 @return 已回答道信息
 */
- (NSArray *)getAlreadyReplyQuestionArray;


/**
 获取我的 答疑 未回答道信息

 @return 未回答道信息
 */
- (NSArray *)getNotReplyQuestionArray;

@end
