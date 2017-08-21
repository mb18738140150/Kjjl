//
//  QuestionViewTableDataSource.h
//  Accountant
//
//  Created by aaa on 2017/3/2.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QuestionViewTableDataSource : NSObject<UITableViewDataSource>

@property (nonatomic,weak) NSArray          *questionsInfoArray;

@property (nonatomic, copy)void(^MoreReplyBlock)(int questionId);

- (instancetype)init;

@end
