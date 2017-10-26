//
//  QuestionReplyModel.h
//  Accountant
//
//  Created by aaa on 2017/3/7.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionReplyModel : NSObject

@property (nonatomic,strong) NSString   *replyContent;
@property (nonatomic,strong) NSString   *replyTime;
@property (nonatomic,strong) NSString   *replierHeaderImageUrl;
@property (nonatomic,strong) NSString   *replierUserName;
@property (nonatomic, assign) int       *replayUserId;
@property (nonatomic, strong) NSMutableArray *askedArray;

@end
