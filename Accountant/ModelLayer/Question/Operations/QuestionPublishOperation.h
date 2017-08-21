//
//  QuestionPublishOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/13.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionModuleProtocol.h"

@interface QuestionPublishOperation : NSObject

@property (nonatomic,weak) id<QuestionModule_QuestionPublishProtocol>        notifiedObject;

- (void)didPublishQuestion:(NSDictionary *)questionInfo withNotifiedObject:(id<QuestionModule_QuestionPublishProtocol>)object;

@end
