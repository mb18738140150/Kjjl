//
//  GiftListOperation.m
//  Accountant
//
//  Created by aaa on 2018/2/5.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "GiftListOperation.h"
#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"

@interface GiftListOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_GiftList> notifiedObject;

@end
@implementation GiftListOperation

- (NSMutableArray *)livingBackYearList
{
    if (!_livingBackYearList) {
        _livingBackYearList = [NSMutableArray array];
    }
    return _livingBackYearList;
}


- (void)didRequestGiftListWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_GiftList>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestGiftListWithInfoDic:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    NSLog(@"yearList = %@", successInfo);
    
    [self.livingBackYearList removeAllObjects];
    NSArray * list = [successInfo objectForKey:@"data"];
    for (NSDictionary * assistantInfo in list) {
        [self.livingBackYearList addObject:assistantInfo];
    }
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestGiftListSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestGiftListFailed:failInfo];
    }
}

@end
