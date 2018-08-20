//
//  CourseSectionTableViewCell.h
//  Accountant
//
//  Created by aaa on 2018/1/27.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseSectionTableViewCell : UITableViewCell

@property (nonatomic, copy)void (^FoldBlock)(NSMutableDictionary *infoDic);

@property (nonatomic, assign)BOOL isTaocan;

- (void)resetWithInfoDic:(NSDictionary *)infoDic;

+ (CGFloat)getCellHeightWith:(NSDictionary *)infoDic andIsFold:(BOOL)isFold;

@end
