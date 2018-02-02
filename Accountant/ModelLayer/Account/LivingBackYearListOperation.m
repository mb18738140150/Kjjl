//
//  LivingBackYearListOperation.m
//  Accountant
//
//  Created by aaa on 2018/1/31.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "LivingBackYearListOperation.h"

#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"

@interface LivingBackYearListOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_LivingBackYearList> notifiedObject;

@end

@implementation LivingBackYearListOperation

- (NSMutableArray *)livingBackYearList
{
    if (!_livingBackYearList) {
        _livingBackYearList = [NSMutableArray array];
    }
    return _livingBackYearList;
}

- (void)didRequestLivingBackYearListWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_LivingBackYearList>)object;
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestLivingBackYearListWithInfoDic:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    NSLog(@"yearList = %@", successInfo);
    
    [self.livingBackYearList removeAllObjects];
    NSArray * list = [successInfo objectForKey:@"yearList"];
    for (NSDictionary * assistantInfo in list) {
        [self.livingBackYearList addObject:assistantInfo];
    }
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestLivingBackYearListSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestLivingBackYearListFailed:failInfo];
    }
}
@end
