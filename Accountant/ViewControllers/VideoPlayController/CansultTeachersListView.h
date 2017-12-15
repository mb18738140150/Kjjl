//
//  CansultTeachersListView.h
//  Accountant
//
//  Created by aaa on 2017/11/2.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CansultTeachersListView : UIView

@property (nonatomic, strong)NSArray *teachersArray;
@property (nonatomic, copy)void(^cansultBlock)(NSDictionary *infoDic);
@property (nonatomic, copy)void(^dismissBlock)();

- (instancetype)initWithFrame:(CGRect)frame andTeachersArr:(NSArray *)array;


@end
