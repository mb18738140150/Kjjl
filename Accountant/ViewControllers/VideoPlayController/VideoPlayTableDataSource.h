//
//  VideoPlayTableDataSource.h
//  Accountant
//
//  Created by aaa on 2017/3/1.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VideoPlayTableDataSource : NSObject<UITableViewDataSource>

@property (nonatomic,weak) NSArray                  *chapterArray;
@property (nonatomic,weak) NSArray                  *chapterVideoInfoArray;

@property (nonatomic,assign) NSInteger               selectedSection;
@property (nonatomic,assign) NSInteger               selectedRow;
@property (nonatomic, strong) NSMutableArray *statusArray;
@end
