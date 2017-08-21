//
//  BindJPushOperation.h
//  Accountant
//
//  Created by aaa on 2017/7/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BindJPushOperation : NSObject

- (void)didRequestBindJPushWithCID:(NSString *)cid withNotifiedObject:(id<UserModule_BindJPushProtocol>)object;

@end
