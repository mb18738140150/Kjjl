//
//  LivingCourseListView.m
//  Accountant
//
//  Created by aaa on 2017/10/11.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "LivingCourseListView.h"
#import "ClassroomLivingTableViewCell.h"

#define kClassroomLivingcellId @"ClassroomLivingTableViewCellID"

@interface LivingCourseListView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation LivingCourseListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   [self.tableView registerNib:[UINib nibWithNibName:@"ClassroomLivingTableViewCell" bundle:nil] forCellReuseIdentifier:kClassroomLivingcellId];
    [self addSubview:self.tableView];
}

#pragma mark - table delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * infoDic = self.dataArr[indexPath.row];
    return 81;
//    if ([[infoDic objectForKey:kLivingState] intValue] == 2 || [[infoDic objectForKey:kLivingState] intValue] == 3) {
//    }
//    return 110;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassroomLivingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kClassroomLivingcellId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.livingDetailVC = YES;
    NSDictionary * dic = [self.dataArr objectAtIndex:indexPath.row] ;
    [cell resetWithDic:dic];
    
    __weak typeof(self)weakSelf = self;
    cell.LivingPlayBlock = ^(LivingPlayType playType) {
        
        if (weakSelf.LivingPlayViewBlock) {
            weakSelf.LivingPlayViewBlock(self.dataArr[indexPath.row],playType);
        }
    };
    
    cell.countDownFinishBlock = ^{
        NSLog(@"倒计时完毕");
        
        if (weakSelf.countDownBlock) {
            weakSelf.countDownBlock(dic);
        }
    };
    
    if ([[dic objectForKey:kCourseSecondID] isEqual:[self.selectLivingSectionInfoDic objectForKey:kCourseSecondID]]) {
        cell.backgroundColor = UIRGBColor(254, 238, 218);
    }else
    {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = self.dataArr[indexPath.row];
    if (self.LivingPlayViewBlock) {
        self.LivingPlayViewBlock(dic,100);
    }
}

- (void)removeAll
{
    self.countDownBlock = nil;
    self.tableView = nil;
}

@end
