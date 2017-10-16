//
//  ContentTableViewDataSource.h
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CategoryView.h"

@interface ContentTableViewDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, copy)void(^clockBlock)(NSDictionary *infoDic);

@property (nonatomic, copy)void(^MoreBlock)();

@property (nonatomic, copy)void(^exchangeNewCourseBlock)();

@property (nonatomic, copy)void (^moreLivingCourseBlock)();

@property (nonatomic, copy)void (^mainMoreCourseBlock)();

@property (nonatomic,weak) NSArray              *catoryDataSourceArray;

@property (nonatomic,strong) NSArray            *mainQuestionArray;

@property (nonatomic, strong)NSArray            *notStartLivingCOurseAyrray;

@property (nonatomic, copy)void(^mainCountDownBlock)();

@end
