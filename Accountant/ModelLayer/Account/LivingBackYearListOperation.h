//
//  LivingBackYearListOperation.h
//  Accountant
//
//  Created by aaa on 2018/1/31.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LivingBackYearListOperation : NSObject
@property (nonatomic, strong)NSMutableArray * livingBackYearList;

- (void)didRequestLivingBackYearListWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_LivingBackYearList>)object;

@end
