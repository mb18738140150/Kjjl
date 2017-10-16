//
//  CategoryDetailTableViewCell.h
//  tiku
//
//  Created by aaa on 2017/5/16.
//  Copyright © 2017年 ytx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProcessView.h"

typedef enum : NSUInteger {
    CellType_chapterTest,
    CellType_myWrong,
    CellType_easyWrong,
    CellType_collect,
    CellType_video
} CellType;

typedef enum : NSUInteger {
    DownloadState_unDownload,
    DownloadState_downloading,
} VideoDownloadState;

@interface CategoryDetailTableViewCell : UITableViewCell

@property (nonatomic, assign)CellType cellType;

@property (nonatomic, strong)UIImageView * showStateImageView;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UILabel * questionCountLabel;
@property (nonatomic, strong)UILabel *learnPepleCountLB;
@property (nonatomic, strong)ProcessView * learnProcessView;
@property (nonatomic, strong)UIImageView *learnImageView;// 下载
@property (nonatomic, strong)UILabel * totalCountLB;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIView        *bottomLineView;
@property (nonatomic, strong)UIView * lineView;
@property (nonatomic, assign)VideoDownloadState downloadState;
@property (nonatomic, copy)void(^downloadBlock)(VideoDownloadState downloadState);

- (void)resetisLast:(BOOL)islast withDicInfo:(NSDictionary *)infoDic;

- (void)hideDownloadBtn;

@end
