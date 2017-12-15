//
//  VideoFunctionView.h
//  Accountant
//
//  Created by aaa on 2017/11/2.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoFunctionView : UIView

@property (nonatomic, copy)void (^cansultBlock)();
@property (nonatomic, copy)void (^buyBlock)();

- (instancetype)initWithFrame:(CGRect)frame andIsBuy:(BOOL)isBuy;

- (void)refreshWithInfoDic:(NSDictionary *)infoDic;

@end
