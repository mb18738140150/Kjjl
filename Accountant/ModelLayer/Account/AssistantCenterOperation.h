//
//  AssistantCenterOperation.h
//  Accountant
//
//  Created by aaa on 2017/12/26.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssistantCenterOperation : NSObject

@property (nonatomic, strong)NSMutableArray * assistantList;
@property (nonatomic, strong)NSMutableArray * telephoneNumberList;

- (void)didRequestAssistantWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_AssistantCenterProtocol>)object;

@end
