//
//  AllCourseTableDataSource.h
//  Accountant
//
//  Created by aaa on 2017/3/1.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AllCourseTableDataSource : NSObject<UITableViewDataSource>

@property (nonatomic,strong) NSArray                *courseListArray;

@end
