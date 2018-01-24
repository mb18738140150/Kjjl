//
//  MemberLevelDetail.m
//  Accountant
//
//  Created by aaa on 2017/12/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "MemberLevelDetail.h"

#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"

@interface MemberLevelDetail ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_LevelDetailProtocol> notifiedObject;

@end

@implementation MemberLevelDetail

- (NSMutableArray *)memberLevelDetailList
{
    if (!_memberLevelDetailList) {
        _memberLevelDetailList = [NSMutableArray array];
    }
    return _memberLevelDetailList;
}

- (void)didRequestMemberLevelDetailWithNotifiedObject:(id<UserModule_LevelDetailProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestMemberLevelDetailWithProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [self.memberLevelDetailList removeAllObjects];
    NSArray * list = [successInfo objectForKey:@"data"];
    for (NSDictionary * assistantInfo in list) {
        [self.memberLevelDetailList addObject:assistantInfo];
    }
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestLevelDetailSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestLevelDetailFailed:failInfo];
    }
}

@end
