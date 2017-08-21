//
//  QuestionDetailViewTableDataSource.h
//  Accountant
//
//  Created by aaa on 2017/3/7.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QuestionDetailViewTableDataSource : NSObject<UITableViewDataSource>

@property (nonatomic,strong) NSDictionary       *questionInfo;
@property (nonatomic,strong) NSArray            *questionReplys;

@end
