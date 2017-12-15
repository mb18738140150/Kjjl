//
//  PayCourseOperation.h
//  Accountant
//
//  Created by aaa on 2017/11/22.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModuleProtocol.h"

@interface PayCourseOperation : NSObject

@property (nonatomic, strong)NSDictionary *payOrderDetailInfo;

- (void)didRequestPayOrderWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_PayOrderProtocol>)object;
@end
