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
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)UIButton * yearBtn;

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
    self.yearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.yearBtn.frame = CGRectMake(10, 0, 50, 35);
    [self.yearBtn setTitle:[NSString stringWithFormat:@"%d",[NSString getCurrentYear]] forState:UIControlStateNormal];
    [self.yearBtn setTitleColor:kCommonMainColor forState:UIControlStateNormal];
    [self addSubview:self.yearBtn];
    [self.yearBtn addTarget:self action:@selector(showYearsList) forControlEvents:UIControlEventTouchUpInside];
    
    self.selectIndexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(50, 35);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(60, 0, kScreenWidth - 20 - 60, 35) collectionViewLayout:layout];
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

#pragma collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LivingCourseCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLivingCourseCollectionViewCellId forIndexPath:indexPath];
    NSString * title = @"";
    
    title = [NSString stringWithFormat:@"%ld月", (long)indexPath.row + 1];
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
    int item = indexPath.item + 1;
    if (self.MonthSelectBlock) {
        self.MonthSelectBlock(item);
    }
    [self.collectionView reloadData];
}
#pragma mark - tableViewdelegate
- (void)showYearsList
{
    if (self.YearSelectBlock) {
        self.YearSelectBlock(self.yearBtn.titleLabel.text);
    }
}

- (void)setyearTitle:(NSString *)yearStr
{
    [self.yearBtn setTitle:yearStr forState:UIControlStateNormal];
}


@end
