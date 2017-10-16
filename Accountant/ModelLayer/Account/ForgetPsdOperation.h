//
//  ForgetPsdOperation.h
//  Accountant
//
//  Created by aaa on 2017/9/13.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModuleProtocol.h"

@interface ForgetPsdOperation : NSObject
- (void)didRequestForgetPsdWithWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_ForgetPasswordProtocol>)object;
@end
