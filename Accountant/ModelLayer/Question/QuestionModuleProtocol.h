//
//  QuestionModuleProtocol.h
//  Accountant
//
//  Created by aaa on 2017/3/2.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QuestionModule_QuestionProtocol <NSObject>

- (void)didQuestionRequestSuccessed;
- (void)didQuestionRequestFailed:(NSString *)failedInfo;

@end

@protocol QuestionModule_QuestionDetailProtocol <NSObject>

- (void)didQuestionRequestSuccessed;
- (void)didQuestionRequestFailed:(NSString *)failedInfo;

@end

@protocol QuestionModule_QuestionPublishProtocol <NSObject>

- (void)didQuestionPublishSuccessed;
- (void)didQuestionPublishFailed:(NSString *)failedInfo;

@end

@protocol QuestionModule_MyQuestionAlreadyReply <NSObject>

- (void)didMyQuestionAlreadyReplyRequestSuccessed;
- (void)didMyQuestionAlreadyReplyRequestFailed:(NSString *)failedInfo;

@end

@protocol QuestionModule_MyQuestionNotReply <NSObject>

- (void)didMyQuestionNotReplyRequestSuccessed;
- (void)didMyQuestionNotReplyRequestFailed:(NSString *)failedInfo;

@end
