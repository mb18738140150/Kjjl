//
//  OrderListOperation.m
//  Accountant
//
//  Created by aaa on 2017/12/19.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "OrderListOperation.h"

#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"

@interface OrderListOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_OrderListProtocol> notifiedObject;
@end

@implementation OrderListOperation

- (NSMutableArray *)orderList
{
    if (!_orderList) {
        _orderList = [NSMutableArray array];
    }
    return _orderList;
}

- (void)didRequestOrderListWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_OrderListProtocol>)object{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestOrderListWithInfoDic:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [self.orderList removeAllObjects];
    NSArray *dataList = [successInfo objectForKey:@"data"];
    for (NSDictionary *infoDic in dataList) {
        [self.orderList addObject:infoDic];
    }
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestOrderListSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestOrderListFailed:failInfo];
    }
}

@end
