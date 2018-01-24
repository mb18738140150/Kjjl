//
//  HelpCenterView.h
//  Accountant
//
//  Created by aaa on 2018/1/9.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HelpType_tel,
    HelpType_assistant
} HelpType;

@interface HelpCenterView : UIView

@property (nonatomic, copy)void(^telephoneBlock)(NSString *telStr);
@property (nonatomic, copy)void(^cansultBlock)(NSDictionary *infoDic);
@property (nonatomic, copy)void(^dismissBlock)();

- (void)resetViewWith:(HelpType)type;
- (instancetype)initWithFrame:(CGRect)frame;

@end
