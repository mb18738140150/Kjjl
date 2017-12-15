//
//  MemberDetailView.h
//  Accountant
//
//  Created by aaa on 2017/11/9.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum:NSInteger {
    MemberLevel_K1,
    MemberLevel_K2,
    MemberLevel_K3,
    MemberLevel_K4,
    MemberLevel_K5,
}MemberLevel;

@interface MemberDetailView : UIView

@property (nonatomic, copy)void (^memberCansultBlock)();
@property (nonatomic, copy)void (^memberBuyBlock)(MemberLevel level);

- (void)refreshUIWith:(MemberLevel)memberLevel;

@end
