//
//  MemberLevelDetail.h
//  Accountant
//
//  Created by aaa on 2017/12/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberLevelDetail : NSObject

@property (nonatomic, strong)NSMutableArray * memberLevelDetailList;

- (void)didRequestMemberLevelDetailWithNotifiedObject:(id<UserModule_LevelDetailProtocol>)object;

@end
