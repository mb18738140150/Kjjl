//
//  GiftListOperation.h
//  Accountant
//
//  Created by aaa on 2018/2/5.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiftListOperation : NSObject

@property (nonatomic, strong)NSMutableArray * livingBackYearList;

- (void)didRequestGiftListWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_GiftList>)object;

@end
