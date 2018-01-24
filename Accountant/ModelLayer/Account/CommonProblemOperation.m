//
//  CommonProblemOperation.m
//  Accountant
//
//  Created by aaa on 2018/1/22.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "CommonProblemOperation.h"

#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"

@interface CommonProblemOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_CommonProblem> notifiedObject;

@end

@implementation CommonProblemOperation

- (NSMutableArray *)memberLevelDetailList
{
    if (!_commonProblemList) {
        _commonProblemList = [NSMutableArray array];
    }
    return _commonProblemList;
}

- (void)didRequestCommonProblemWithNotifiedObject:(id<UserModule_CommonProblem>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestCommonProblemWithProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [self.memberLevelDetailList removeAllObjects];
    NSArray * list = [successInfo objectForKey:@"data"];
    for (NSDictionary * assistantInfo in list) {
        [self.commonProblemList addObject:assistantInfo];
    }
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestCommonProblemSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestCommonProblemFailed:failInfo];
    }
}

@end
