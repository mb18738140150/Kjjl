//
//  CommonProblemOperation.h
//  Accountant
//
//  Created by aaa on 2018/1/22.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonProblemOperation : NSObject
@property (nonatomic, strong)NSMutableArray * commonProblemList;

- (void)didRequestCommonProblemWithNotifiedObject:(id<UserModule_CommonProblem>)object;


@end
