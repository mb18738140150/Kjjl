//
//  LivingDetailView.h
//  Accountant
//
//  Created by aaa on 2017/8/9.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LivingDetailView : UIView

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSDictionary * infoDic;

@property (nonatomic, copy)void(^payBlock)(NSDictionary * infoDic);
@end
