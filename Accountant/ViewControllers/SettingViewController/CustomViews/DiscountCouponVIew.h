//
//  DiscountCouponVIew.h
//  Accountant
//
//  Created by aaa on 2018/3/16.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscountCouponVIew : UIView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UIImageView * backImageView;
@property (nonatomic, strong)UIImageView * titleImageView;
@property (nonatomic, strong)UIButton * closeBtn;
@property (nonatomic, strong)UIButton * getBtn;

@property (nonatomic, strong)UITableView * discountCouponTable;

@property (nonatomic, copy)void(^closeBlock)();
@property (nonatomic, copy)void(^getDiscountCouponBlock)();

@property (nonatomic, strong)NSArray * dataArray;
- (void)refreshUIWith:(NSArray *)dataArray;
@end
