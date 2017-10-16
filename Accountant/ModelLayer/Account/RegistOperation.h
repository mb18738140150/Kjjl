//
//  RegistOperation.h
//  Accountant
//
//  Created by aaa on 2017/9/13.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModuleProtocol.h"

@interface RegistOperation : NSObject
- (void)didRequestRegistWithWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_RegistProtocol>)object;
@end
