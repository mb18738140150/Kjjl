//
//  LivingDetailView.m
//  Accountant
//
//  Created by aaa on 2017/8/9.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "LivingDetailView.h"
#import "QuestionReplyTableViewCell.h"
#import "LivingDetailTableViewCell.h"

@interface LivingDetailView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation LivingDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[QuestionReplyTableViewCell class] forCellReuseIdentifier:@"questionReplyCell"];
    [self.tableView registerClass:[LivingDetailTableViewCell class] forCellReuseIdentifier:@"livingDetailCell"];
}

#pragma mark - table delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UIFont *font = kMainFont;
        CGFloat contentHeight = [UIUtility getSpaceLabelHeght:[self.infoDic objectForKey:kTeacherDetail] font:font width:kScreenWidth - 40];
        return 20 + kHeightOfCellHeaderImage + 10 + contentHeight + 10;
    }
    if (indexPath.section > 0) {
        UIFont *font = kMainFont;
        CGFloat contentHeight = [UIUtility getSpaceLabelHeght:[self.infoDic objectForKey:kLivingDetail] font:font width:kScreenWidth - 40];
        return  10 + contentHeight + 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-20, 1)];
    topLineView.backgroundColor = kTableViewCellSeparatorColor;
    //            [bgView addSubview:topLineView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 3, 22)];
    lineView.backgroundColor = kCommonMainColor;
    [bgView addSubview:lineView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(lineView.frame.origin.x + 10, 20, 100, 20)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = kCommonMainColor;
    if (section == 0) {
        titleLabel.text = @"主讲老师";
    }else
    {
        titleLabel.text = @"视频详情";
    }
    [bgView addSubview:titleLabel];

    return bgView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellName = @"questionReplyCell";
        QuestionReplyTableViewCell *cell = (QuestionReplyTableViewCell *)[UIUtility getCellWithCellName:cellName inTableView:tableView andCellClass:[QuestionReplyTableViewCell class]];
        [cell resetLivingDetailCellWithInfoDic:self.infoDic];
        return cell;
    }
    if (indexPath.section == 1) {
        static NSString *cellName = @"livingDetailCell";
        LivingDetailTableViewCell *cell = (LivingDetailTableViewCell *)[UIUtility getCellWithCellName:cellName inTableView:tableView andCellClass:[LivingDetailTableViewCell class]];
        [cell resetWithInfoDic:self.infoDic];
        return cell;
    }
    return nil;
}

@end
