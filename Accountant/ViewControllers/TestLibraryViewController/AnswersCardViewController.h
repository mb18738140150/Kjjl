//
//  AnswersCardViewController.h
//  Accountant
//
//  Created by aaa on 2017/3/30.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SubmitBlock)();

@interface AnswersCardViewController : UIViewController
@property (nonatomic,strong) NSString       *cateName;
@property (nonatomic,assign) int             cateId;
- (void)submiteBlock:(SubmitBlock)block;

@end
