//
//  CancelOrderLivingCourseOperation.h
//  Accountant
//
//  Created by aaa on 2017/10/13.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CancelOrderLivingCourseOperation : UIView
- (void)didRequestCancelOrderLivingCourseWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_CancelOrderLivingCourseProtocol>)object;
@end
