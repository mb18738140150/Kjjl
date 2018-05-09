//
//  PackageDetailOperation.h
//  Accountant
//
//  Created by aaa on 2018/4/27.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseModuleProtocol.h"

@interface PackageDetailOperation : NSObject

@property (nonatomic, strong)NSDictionary *infoDic;
- (void)didRequestPackageDetailWithpackageId:(int)packageId andNotifiedObject:(id<CourseModule_PackageDetailProtocol>)object;

@end
