//
//  MyNoteViewController.m
//  Accountant
//
//  Created by aaa on 2017/3/18.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "MyNoteViewController.h"
#import "UIMacro.h"
#import "CommonMacro.h"
#import "NoteManager.h"
#import "UIUtility.h"
#import "SVProgressHUD.h"
#import "MyVideoNoteTableViewCell.h"
#import "MJRefresh.h"
#import "NoteManager.h"
#import "VideoNoteDetailViewController.h"


@interface MyNoteViewController ()<UITableViewDelegate,UITableViewDataSource,NoteModule_MyVideoNoteProtocol,NoteModule_DeleteVideoNoteProtocol>

@property (nonatomic,strong) NSArray                *myVideoNoteArray;

@property (nonatomic,strong) UITableView            *noteTableView;



@end

@implementation MyNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self navigationViewSetup];
    [self tableViewSetup];
    [self requestAllNote];
}

- (void)requestAllNote
{
    [SVProgressHUD show];
    [[NoteManager sharedManager] didRequestAllMyNoteWithNotifiedObject:self];
}

- (void)deleteNoteWithId:(int)noteId
{
    [SVProgressHUD show];
    [[NoteManager sharedManager] didRequestDeleteVideoNoteWithId:noteId andNotifiedObject:self];
}

#pragma mark - my video delegate
- (void)didRequestMyVideoNoteSuccess
{
    [SVProgressHUD dismiss];
    [self.noteTableView.mj_header endRefreshing];
    self.myVideoNoteArray = [[NoteManager sharedManager] getAllMyVideoNoteInfos];
    [self.noteTableView reloadData];
    
}

- (void)didRequestMyVideoNoteFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.noteTableView.mj_header endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestDeleteVideoNoteSuccess
{
    [SVProgressHUD dismiss];
    [self requestAllNote];
}

- (void)didRequestDeleteVideoNoteFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - ui
- (void)navigationViewSetup
{
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, kScreenWidth, 64)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"笔记";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //    self.navigationController.navigationBarHidden = YES;
    
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

- (void)tableViewSetup
{
    self.noteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    self.noteTableView.delegate = self;
    self.noteTableView.dataSource = self;
    self.noteTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestAllNote)];
//    self.noteTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.noteTableView];
}

#pragma mark - table func
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoNoteDetailViewController *vc = [[VideoNoteDetailViewController alloc] init];
    vc.noteDetailInfo = [self.myVideoNoteArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myVideoNoteArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyVideoNoteTableViewCell *cell = (MyVideoNoteTableViewCell *)[UIUtility getCellWithCellName:@"myVideoNoteCell" inTableView:tableView andCellClass:[MyVideoNoteTableViewCell class]];
    NSDictionary *dic = [self.myVideoNoteArray objectAtIndex:indexPath.row];
    [cell resetCellWithInfo:dic];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [self.myVideoNoteArray objectAtIndex:indexPath.row];
    NSString *content = [info objectForKey:kNoteVideoNoteContent];
    CGFloat maxHeight = 80;
    CGFloat contentHeight = [UIUtility getHeightWithText:content font:kMainFont width:kScreenWidth - 20];
    CGFloat height = 0;
    if (maxHeight > contentHeight) {
        height = contentHeight;
    }else{
        height = maxHeight;
    }
    return 10 + 20 + 5 + height +5+ 20 + 10;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *dic = [self.myVideoNoteArray objectAtIndex:indexPath.row];
        [self deleteNoteWithId:[[dic objectForKey:kNoteVideoNoteId] intValue]];
        
    }
}


@end
