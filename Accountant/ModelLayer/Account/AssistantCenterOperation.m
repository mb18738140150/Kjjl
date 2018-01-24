//
//  AssistantCenterOperation.m
//  Accountant
//
//  Created by aaa on 2017/12/26.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "AssistantCenterOperation.h"

#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"

@interface AssistantCenterOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_AssistantCenterProtocol> notifiedObject;

@property (nonatomic, strong)NSNumber *commond;
@end

@implementation AssistantCenterOperation

- (void)didRequestAssistantWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_AssistantCenterProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestAssistantCenterWithInfoDic:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [self.assistantList removeAllObjects];
    [self.telephoneNumberList removeAllObjects];
    NSArray * list = [successInfo objectForKey:@"assistantList"];
    for (NSDictionary * assistantInfo in list) {
        [self.assistantList addObject:assistantInfo];
    }
    NSArray * telList = [successInfo objectForKey:@"telephoneNumberList"];
    for (NSString * telStr in telList) {
        [self.telephoneNumberList addObject:telStr];
    }
    
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestAssistantCenterSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestAssistantCenterFailed:failInfo];
    }
}

@end
