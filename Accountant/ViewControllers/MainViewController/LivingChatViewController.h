//
//  LivingChatViewController.h
//  Accountant
//
//  Created by aaa on 2017/8/7.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface LivingChatViewController : RCConversationViewController

@property (nonatomic, strong)NSDictionary * infoDic;
- (void)popupChatViewController;
@end
