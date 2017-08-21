//
//  DownloadingTableViewDataSource.m
//  Accountant
//
//  Created by aaa on 2017/3/10.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DownloadingTableViewDataSource.h"
#import "CommonMacro.h"
#import "DownloaderManager.h"
//#import "DownloadingTableViewCell.h"
#import "DownLoadModel.h"

#import "CoursecategoryTableViewCell.h"

#import "TYDownloadSessionManager.h"

@implementation DownloadingTableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.downloadingVideoInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
    CoursecategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CoursecategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *videoInfo = [self.downloadingVideoInfos objectAtIndex:indexPath.row];
    cell.courseType = CourseCategoryType_downLoading;

    [cell resetCellContent:videoInfo];
    if (indexPath.row == 0) {
        cell.tag = 2222;
    }
    
      __weak typeof(cell)weakCell = cell;
    TYDownloadModel * TY_model = [[DownloaderManager sharedManager] TY_getDownLoadModelWithDownloadVideoURL:[videoInfo objectForKey:kVideoURL]];
    TY_model.progressBlock = ^(TYDownloadProgress *progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakCell.progressView.progress = progress.progress;
            weakCell.progresslabel.text = [NSString stringWithFormat:@"%.1f%%", progress.progress * 100];
        });
    };
    
    cell.DownStateBlock = ^(BOOL isPause){
        if (isPause) {
            [[DownloaderManager sharedManager]TY_pauseDownloadWithModel:TY_model];
            weakCell.progresslabel.text = @"暂停中";
        }else
        {
            [[DownloaderManager sharedManager]TY_unPauseDownloadWithModel:TY_model];
            weakCell.progresslabel.text = @"等待中";
        }
    };

    if (TY_model.state == TYDownloadStateReadying) {
        cell.progresslabel.text = @"等待中";
        cell.stateBT.selected = NO;
    }else if(TY_model.state == TYDownloadStateRunning){
        cell.progresslabel.text = @"下载中";
        cell.stateBT.selected = NO;
    }else if(TY_model.state == TYDownloadStateSuspended){
        cell.progresslabel.text = @"暂停中";
        cell.stateBT.selected = YES;
    }else if(TY_model.state == TYDownloadStateFailed){
        cell.progresslabel.text = @"下载失败";
        cell.stateBT.hidden = YES;
    }
    cell.courseNameLabel.text = [videoInfo objectForKey:kVideoName];

    return cell;
    /*
     
     typedef NS_ENUM(NSUInteger, TYDownloadState) {
     TYDownloadStateNone,        // 未下载 或 下载删除了
     TYDownloadStateReadying,    // 等待下载
     TYDownloadStateRunning,     // 正在下载
     TYDownloadStateSuspended,   // 下载暂停
     TYDownloadStateCompleted,   // 下载完成
     TYDownloadStateFailed       // 下载失败
     };
     
     */
    
//    DownLoadModel * model = [[DownloaderManager sharedManager] getDownLoadModelWithDownloadTsakId:[videoInfo objectForKey:kDownloadTaskId]];
//    
//    NSLog(@"%@ ---- %@", [model.infoDic objectForKey:kDownloadTaskId], [model.infoDic objectForKey:kVideoName]);
//    
//  
//    
//    model.DownloadProcessBlock = ^(float process){
//        dispatch_async(dispatch_get_main_queue(), ^{
//            weakCell.progressView.progress = process;
//            weakCell.progresslabel.text = [NSString stringWithFormat:@"%.1f%%", process * 100];
//        });
//    };
//    
//    cell.DownStateBlock = ^(BOOL isPause){
//        if (isPause) {
//            [[DownloaderManager sharedManager]pauseDownloadWithModel:model];
//            weakCell.progresslabel.text = @"暂停中";
//        }else
//        {
//            [[DownloaderManager sharedManager]unPauseDownloadWithModel:model];
//            weakCell.progresslabel.text = @"等待中";
//        }
//    };
//
//    if (model.downLoadState == DownloadStateWait) {
//        cell.progresslabel.text = @"等待中";
//        cell.stateBT.selected = NO;
//    }else if(model.downLoadState == DownloadStateDownloading){
//        cell.progresslabel.text = @"下载中";
//        cell.stateBT.selected = NO;
//    }else{
//        cell.progresslabel.text = @"暂停中";
//        cell.stateBT.selected = YES;
//    }
//    cell.courseNameLabel.text = [videoInfo objectForKey:kVideoName];
    
    
}

@end
