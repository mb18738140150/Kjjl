//
//  OrderListOperation.h
//  Accountant
//
//  Created by aaa on 2017/12/19.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderListOperation : NSObject
@property (nonatomic, strong)NSMutableArray *orderList;

- (void)didRequestOrderListWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_OrderListProtocol>)object;
@end
