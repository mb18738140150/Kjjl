//
//  ScreenView.m
//  Accountant
//
//  Created by aaa on 2017/4/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "ScreenView.h"
#import "UIMacro.h"
#import "ScreenCollectionViewCell.h"
#define kScreenCellID @"screencollectionviewcellID"

@interface ScreenView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView * screenCollectionView;

@end

@implementation ScreenView

- (instancetype)initWithFrame:(CGRect)frame withArr:(NSArray *)titleArr
{
    if (self = [super initWithFrame:frame]) {
        self.titleArr = [titleArr mutableCopy];
        [self prepareUI];
    }
    return self;
}
- (void)selectCourse:(NSString *)title index:(int)row
{
    if (title.length == 0) {
        [self.titleArr replaceObjectAtIndex:row withObject:@"全部"];
    }else
    {
        [self.titleArr replaceObjectAtIndex:row withObject:title];
    }
    [self.screenCollectionView reloadData];
    self.screenCollectionView.contentSize = CGSizeMake(kScreenWidth, 40);
}
- (void)prepareUI
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(kScreenWidth / self.titleArr.count, 40);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.screenCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) collectionViewLayout:layout];
    [self.screenCollectionView registerNib:[UINib nibWithNibName:@"ScreenCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kScreenCellID];
    self.screenCollectionView.bounces = NO;
    self.screenCollectionView.contentSize = CGSizeMake(kScreenWidth, 40);
    self.screenCollectionView.showsHorizontalScrollIndicator = NO;
    self.screenCollectionView.delegate = self;
    self.screenCollectionView.dataSource = self;
    [self addSubview:self.screenCollectionView];
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, 1)];
    bottomView.backgroundColor = [UIColor colorWithWhite:.8 alpha:1];
    [self addSubview:bottomView];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titleArr.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ScreenCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kScreenCellID forIndexPath:indexPath];
    [cell resetWith:self.titleArr[indexPath.item]];
    if (indexPath.item == self.titleArr.count - 1) {
        cell.seperateLine.hidden = YES;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectBlock) {
        self.selectBlock(self.titleArr[indexPath.item],indexPath.item);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
