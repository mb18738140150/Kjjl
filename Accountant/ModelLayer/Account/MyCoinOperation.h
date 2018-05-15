//
//  MyCoinOperation.h
//  Accountant
//
//  Created by aaa on 2018/5/13.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCoinOperation : NSObject

- (void)didRequestMyCoinWithNotifiedObject:(id<UserModule_MyCoin>)object;

@end
