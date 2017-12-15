//
//  QuestionDetailViewTableDataSource.m
//  Accountant
//
//  Created by aaa on 2017/3/7.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "QuestionDetailViewTableDataSource.h"
#import "UIUtility.h"
#import "QuestionTableViewCell.h"
#import "QuestionReplyTableViewCell.h"
#import "AskedTableViewCell.h"
#import "NewCourseExchangeTableViewCell.h"

@implementation QuestionDetailViewTableDataSource

- (NSMutableArray *)statusArray
{
    if (!_statusArray) {
        _statusArray = [NSMutableArray array];
    }
    if (_statusArray.count == 0) {
        for (NSInteger i = 0; i < self.questionReplys.count; i++) {
            [_statusArray addObject:[NSNumber numberWithInteger:_fold]];
        }
    }
    
    return _statusArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section != 0) {
        
        NSInteger count = [[[self.questionReplys objectAtIndex:section - 1] objectForKey:kAskedArray] count];
        if (count > 3) {
            if ([[_statusArray objectAtIndex:section - 1] boolValue]) {
                return count + 2;
            }else
            {
                return 5;
            }
        }else
        {
            return count + 1;
        }
        
        return [[[self.questionReplys objectAtIndex:section - 1] objectForKey:kAskedArray] count] + 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellName = @"questionCell";
        QuestionTableViewCell *cell = (QuestionTableViewCell *)[UIUtility getCellWithCellName:cellName inTableView:tableView andCellClass:[QuestionTableViewCell class]];
        cell.isCalculatedDate = YES;
        cell.isShowFullContent = YES;
        cell.isQuestionDetail = YES;
        [cell resetCellWithInfo:self.questionInfo];
        return cell;
    }
    
    if (indexPath.section != 0) {
        
        NSInteger count = [[[self.questionReplys objectAtIndex:indexPath.section - 1] objectForKey:kAskedArray] count];
        
        if (indexPath.row == 0) {
            static NSString *cellName = @"questionReplyCell";
            QuestionReplyTableViewCell *cell = (QuestionReplyTableViewCell *)[UIUtility getCellWithCellName:cellName inTableView:tableView andCellClass:[QuestionReplyTableViewCell class]];
            __weak typeof(self) weakSelf = self;
            cell.askBlock = ^(NSDictionary *infoDic) {
                if (weakSelf.askQuestionBlock) {
                    weakSelf.askQuestionBlock(infoDic);
                }
            };
            
            [cell resetCellWithInfo:[self.questionReplys objectAtIndex:indexPath.row]];
            return cell;
        }else if ((count > 3 && [[_statusArray objectAtIndex:indexPath.section - 1] boolValue] && indexPath.row == count + 1) || (count > 3 && ![[_statusArray objectAtIndex:indexPath.section - 1] boolValue] && indexPath.row == 4)){
            static NSString *courseTitleCellName = @"courseFootCell";
            NewCourseExchangeTableViewCell *footCell = (NewCourseExchangeTableViewCell *)[self getCellWithCellName:courseTitleCellName inTableView:tableView andCellClass:[NewCourseExchangeTableViewCell class]];
            
            __weak typeof(self)weakSelf = self;
            footCell.MoreLivingCourseBlock = ^(BOOL showMore) {
                BOOL fold = [[weakSelf.statusArray objectAtIndex:indexPath.section - 1] boolValue];
                [weakSelf.statusArray replaceObjectAtIndex:indexPath.section - 1 withObject:[NSNumber numberWithBool:!fold]];
                if (weakSelf.showMoreReplayBlock) {
                    weakSelf.showMoreReplayBlock(indexPath.section,!fold);
                }
            };
            [footCell resetMoreInfo];
            if ([[self.statusArray objectAtIndex:indexPath.section - 1] boolValue]) {
                footCell.exchangeLB.text = @"收起";
                footCell.exchangeImageView.image = [UIImage imageNamed:@"形状-up"];
            }else
            {
                footCell.exchangeLB.text = @"展开";
                footCell.exchangeImageView.image = [UIImage imageNamed:@"形状-down"];
            }
            return footCell;
        }
        else
        {
            static NSString *cellName = @"askedReplyCell";
            AskedTableViewCell *cell = (AskedTableViewCell *)[UIUtility getCellWithCellName:cellName inTableView:tableView andCellClass:[AskedTableViewCell class]];
            NSDictionary * infoDic = [[self.questionReplys[indexPath.section - 1] objectForKey:kAskedArray] objectAtIndex:indexPath.row - 1];
            [cell resetCellWithInfoDic:infoDic];
            return cell;
        }
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 + self.questionReplys.count;
}

#pragma mark - utility
- (UITableViewCell *)getCellWithCellName:(NSString *)reuseName inTableView:(UITableView *)table andCellClass:(Class)cellClass
{
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:reuseName];
    if (cell == nil) {
        cell = [[cellClass alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
@end
