//
//  DiscountCouponVIew.m
//  Accountant
//
//  Created by aaa on 2018/3/16.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "DiscountCouponVIew.h"
#import "DiscountCouponTCCell.h"

#define kCellId @"DiscountCouponTCCellID"

#define kBackImagescal 655.0/792
#define kTitleImageViewScal 644.0 / 128


@implementation DiscountCouponVIew

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    UIView * backView = [[UIView alloc]initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    [self addSubview:backView];
    
    CGFloat backImageW = kScreenWidth - 40;
    CGFloat backImageH = backImageW / kBackImagescal;
    self.backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, (kScreenHeight - backImageH) / 2, backImageW, backImageH)];
    self.backImageView.image = [UIImage imageNamed:@"discountCoupon_bg"];
    self.backImageView.userInteractionEnabled = YES;
    [self addSubview:self.backImageView];
    
    CGFloat titleImageH = backImageH * 0.1;
    CGFloat titleImageW = titleImageH * kTitleImageViewScal;
    self.titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake((backImageW - titleImageW) / 2, (backImageH * 0.25 - titleImageH) / 2, titleImageW, titleImageH)];
    self.titleImageView.image = [UIImage imageNamed:@"discountCoupon_bt"];
    [self.backImageView addSubview:self.titleImageView];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeBtn.frame = CGRectMake(CGRectGetMaxX(self.backImageView.frame) - 40, self.backImageView.hd_y + 10, 30, 30);
    [self.closeBtn setImage:[[UIImage imageNamed:@"discountCoupon_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self addSubview:self.closeBtn];
    [self.closeBtn addTarget:self action:@selector(closeAction ) forControlEvents:UIControlEventTouchUpInside];
    
    self.getBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.getBtn.frame = CGRectMake(backImageW * 0.2, backImageH * 0.8, backImageW * 0.6, titleImageH);
    self.getBtn.backgroundColor = UIColorFromRGB(0xffeb01);
    [self.getBtn setTitle:@"确认领取" forState:UIControlStateNormal];
    [self.getBtn setTitleColor:UIColorFromRGB(0xee3e2f) forState:UIControlStateNormal];
    self.getBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.getBtn.layer.cornerRadius = titleImageH / 2;
    self.getBtn.layer.masksToBounds = YES;
    [self.backImageView addSubview:self.getBtn];
    [self.getBtn addTarget:self action:@selector(getDiscountCouponAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.discountCouponTable = [[UITableView alloc]initWithFrame:CGRectMake(30, backImageH * 0.25 + 10, backImageW - 60, backImageH * 0.5 - 20) style:UITableViewStylePlain];
    self.discountCouponTable.delegate = self;
    self.discountCouponTable.dataSource = self;
    [self.backImageView addSubview:self.discountCouponTable];
    self.discountCouponTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.discountCouponTable.tableHeaderView = [self getTableHeaderView];
    [self.discountCouponTable registerClass:[DiscountCouponTCCell class] forCellReuseIdentifier:kCellId];
    
}

- (void)refreshUIWith:(NSArray *)dataArray
{
    [self.discountCouponTable reloadData];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiscountCouponTCCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    [cell refreshWithInfoDic:self.dataArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.discountCouponTable.hd_height * 0.4;
}

- (UIView *)getTableHeaderView
{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.discountCouponTable.hd_width, self.discountCouponTable.hd_height * 0.2)];
    label.text = @"优惠券已放入账户中，请在【 我的 】页面中查看";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = UIColorFromRGB(0x333333);
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}


- (void)closeAction
{
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void)getDiscountCouponAction
{
    if (self.getDiscountCouponBlock) {
        self.getDiscountCouponBlock();
    }
}

@end
