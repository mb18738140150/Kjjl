//
//  QuestionDetailViewController.m
//  Accountant
//
//  Created by aaa on 2017/3/7.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "QuestionDetailViewController.h"
#import "QuestionManager.h"
#import "UIMacro.h"
#import "QuestionDetailViewTableDataSource.h"
#import "SVProgressHUD.h"
#import "UIUtility.h"
#import "CommonMacro.h"
#import "QuestionMacro.h"


@interface QuestionDetailViewController ()<QuestionModule_QuestionDetailProtocol,UITableViewDelegate>

@property (nonatomic,strong) UITableView                            *contentTableView;
@property (nonatomic,strong) QuestionDetailViewTableDataSource      *tableDataSource;

@end

@implementation QuestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navigationViewSetup];
    [self contentViewSetup];
    [self requestDetail];
}

- (void)navigationViewSetup
{
    self.navigationItem.title = @"答疑详情";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50};
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"public-返回"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)contentViewSetup
{
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - request
- (void)requestDetail
{
    [SVProgressHUD show];
    [[QuestionManager sharedManager] didRequestQuestionDetailWithQuestionId:self.questionId andNotifiedObject:self];
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    self.contentTableView.delegate = self;
    self.tableDataSource = [[QuestionDetailViewTableDataSource alloc] init];
    __weak typeof(self)weakSelf = self;
    self.tableDataSource.askQuestionBlock = ^(NSDictionary *infoDic) {
        NSLog(@"%@", infoDic);
    };
    self.tableDataSource.showMoreReplayBlock = ^(NSInteger section, BOOL fold) {
        if (fold) {
            [weakSelf.contentTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationBottom];
        }else
        {
            [weakSelf.contentTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationTop];
            [weakSelf.contentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    };
    
    self.contentTableView.dataSource = self.tableDataSource;
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.contentTableView];
}

#pragma mark - table delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UIFont *font = kMainFont;
        CGFloat contentHeight = [UIUtility getSpaceLabelHeght:[self.tableDataSource.questionInfo objectForKey:kQuestionContent] font:font width:kScreenWidth - 20];
        NSArray *img = [self.tableDataSource.questionInfo objectForKey:kQuestionImgStr];
        if (img.count == 0) {
            return 10 + kHeightOfCellHeaderImage + 10 +  contentHeight + 10 + 30;
        }else{
            return 10 + kHeightOfCellHeaderImage + 10 + contentHeight + 5 + 60 + 10 + 30;
        }
    }
    if (indexPath.section > 0) {
        
        NSInteger count = [[[self.tableDataSource.questionReplys objectAtIndex:indexPath.section - 1] objectForKey:kAskedArray] count];
        
        if (indexPath.row == 0) {
            NSDictionary *infoDic = [self.tableDataSource.questionReplys objectAtIndex:indexPath.row];
            UIFont *font = kMainFont;
            CGFloat contentHeight = [UIUtility getSpaceLabelHeght:[infoDic objectForKey:kReplyContent] font:font width:kScreenWidth - 40];
            return 20 + kHeightOfCellHeaderImage + 10 + contentHeight + 10 ;
        }else if ((count > 3 && [[self.tableDataSource.statusArray objectAtIndex:indexPath.section - 1] boolValue] && indexPath.row == count + 1) || (count > 3 && ![[self.tableDataSource.statusArray objectAtIndex:indexPath.section - 1] boolValue] && indexPath.row == 4)){
            return kCellHeightOfCourseTitle;
        }
        else
        {
            NSDictionary *infoDic = [[[self.tableDataSource.questionReplys objectAtIndex:indexPath.section - 1] objectForKey:kAskedArray] objectAtIndex:indexPath.row - 1];
            
            CGFloat contentHeight = [UIUtility getHeightWithText:[infoDic objectForKey:@"replyCon"] font:kMainFont width:kScreenWidth / 2 - 25];
            
            CGFloat space = 0.0;
            if (indexPath.row == count) {
                space = 15;
            }
             if ((count > 3 && [[self.tableDataSource.statusArray objectAtIndex:indexPath.section - 1] boolValue] && indexPath.row == count) || (count > 3 && ![[self.tableDataSource.statusArray objectAtIndex:indexPath.section - 1] boolValue] && indexPath.row == 3))
             {
                 space = 15;
             }
            
            return 10 + 5 + contentHeight + 5 + space;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        if ([[QuestionManager sharedManager] getDetailQuestionReplyArray].count != 0 && section == 1) {
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
            bgView.backgroundColor = UIRGBColor(245, 245, 245);
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 9, 3, 22)];
            lineView.backgroundColor = UIRGBColor(246, 104, 6);
            [bgView addSubview:lineView];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(lineView.frame.origin.x + 15, 10, 100, 20)];
            titleLabel.font = [UIFont systemFontOfSize:17];
            titleLabel.textColor = UIRGBColor(246, 104, 6);
            titleLabel.text = [NSString stringWithFormat:@"讨论区(%ld)", (long)self.tableDataSource.questionReplys.count];
            [bgView addSubview:titleLabel];
            
            return bgView;
        }else{
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
            UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
            topLineView.backgroundColor = UIRGBColor(245, 245, 245);
            [bgView addSubview:topLineView];
            return bgView;
        }
        
    }else{
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        if ([[QuestionManager sharedManager] getDetailQuestionReplyArray].count != 0 && section == 1) {
            return 40;
        }else{
            return 5;
        }
    }
    return 0;
}

#pragma mark - delegate funcs
- (void)didQuestionRequestSuccessed
{
    self.tableDataSource.questionInfo = [[QuestionManager sharedManager] getDetailQuestionInfo];
    self.tableDataSource.questionReplys = [[QuestionManager sharedManager] getDetailQuestionReplyArray];
    [self.contentTableView reloadData];
    [SVProgressHUD dismiss];
}

- (void)didQuestionRequestFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"网络连接失败，请稍后再试"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    });
}


@end
