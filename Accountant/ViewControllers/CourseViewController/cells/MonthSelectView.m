//
//  MonthSelectView.m
//  Accountant
//
//  Created by aaa on 2017/9/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "MonthSelectView.h"
#import "LivingCourseCollectionViewCell.h"

#define kLivingCourseCollectionViewCellId @"LivingCourseCollectionViewCellId"
@interface MonthSelectView ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView *collectionView;

@end

@implementation MonthSelectView

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
    self.selectIndexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(50, 35);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 35) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[LivingCourseCollectionViewCell class] forCellWithReuseIdentifier:kLivingCourseCollectionViewCellId];
    [self addSubview:self.collectionView];
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 32, kScreenWidth, 3)];
    bottomView.backgroundColor = UIRGBColor(230, 230, 230);
    [self addSubview:bottomView];
    
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LivingCourseCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLivingCourseCollectionViewCellId forIndexPath:indexPath];
    NSString * title = @"";
    if (indexPath.item == 0) {
        title = @"2017";
    }else
    {
        title = [NSString stringWithFormat:@"%ld月", (long)indexPath.row + 4];
    }
    [cell resetTitleWith:title];
    if ([self.selectIndexpath isEqual:indexPath]) {
        cell.titleLabel.textColor = kCommonMainColor;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50, 35);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectIndexpath = indexPath;
    int item = indexPath.item;
    if (indexPath.item > 0) {
        item = indexPath.item + 4;
    }
    if (self.MonthSelectBlock) {
        self.MonthSelectBlock(item);
    }
    [self.collectionView reloadData];
}


@end
