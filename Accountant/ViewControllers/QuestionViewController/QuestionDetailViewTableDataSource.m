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

@implementation QuestionDetailViewTableDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return self.questionReplys.count;
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
    if (indexPath.section == 1) {
        static NSString *cellName = @"questionReplyCell";
        QuestionReplyTableViewCell *cell = (QuestionReplyTableViewCell *)[UIUtility getCellWithCellName:cellName inTableView:tableView andCellClass:[QuestionReplyTableViewCell class]];
        [cell resetCellWithInfo:[self.questionReplys objectAtIndex:indexPath.row]];
        return cell;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

@end
