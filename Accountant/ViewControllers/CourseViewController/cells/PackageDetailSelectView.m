//
//  PackageDetailSelectView.m
//  Accountant
//
//  Created by aaa on 2018/4/17.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "PackageDetailSelectView.h"
#import "PackageDetailSelectCell.h"

#define kCellID @"PackageDetailSelectCellId"


@implementation PackageDetailSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    self.backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, self.hd_height - 450, kScreenWidth, 450)];
    self.backGroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backGroundView];
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, -49, 115, 115)];
    self.iconImageView.image = [UIImage imageNamed:@""];
    self.iconImageView.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    [self.backGroundView addSubview:self.iconImageView];
    
    self.priceLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 20, 10, kScreenWidth - 155, 20)];
    self.priceLB.textColor = [UIColor redColor];
    self.priceLB.font = [UIFont boldSystemFontOfSize:17];
    [self.backGroundView addSubview:self.priceLB];
    
    self.storeCountLB = [[UILabel alloc]initWithFrame:CGRectMake(self.priceLB.hd_x, CGRectGetMaxY(self.priceLB.frame) + 15, self.priceLB.hd_width, 15)];
    self.storeCountLB.font = [UIFont systemFontOfSize:12];
    self.storeCountLB.textColor = UIColorFromRGB(0x333333);
    [self.backGroundView addSubview:self.storeCountLB];
    
    self.selectLB = [[UILabel alloc]initWithFrame:CGRectMake(self.priceLB.hd_x, CGRectGetMaxY(self.storeCountLB.frame) + 15, self.priceLB.hd_width, 15)];
    self.selectLB.font = [UIFont systemFontOfSize:12];
    self.selectLB.textColor = UIColorFromRGB(0xcccccc);
    [self.backGroundView addSubview:self.selectLB];
    
    self.guigeLB = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.iconImageView.frame) + 36, kScreenWidth - 20, 15)];
    self.guigeLB.text = @"规格";
    self.guigeLB.textColor = UIColorFromRGB(0x333333);
    self.guigeLB.font = [UIFont systemFontOfSize:18];
    [self.backGroundView addSubview:self.guigeLB];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((kScreenWidth - 76) / 3, 35);
    layout.minimumLineSpacing = 18;
    
    self.guigeCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(19, CGRectGetMaxY(self.guigeLB.frame) + 20, kScreenWidth - 38, 137) collectionViewLayout:layout];
    self.guigeCollectionView.delegate = self;
    self.guigeCollectionView.dataSource = self;
    [self.backGroundView addSubview:self.guigeCollectionView];
    
    self.buyCountLB = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.guigeCollectionView.frame) + 34, 100, 20)];
    self.buyCountLB.text = @"购买数量";
    self.buyCountLB.textColor = UIColorFromRGB(0x333333);
    self.buyCountLB.font = [UIFont systemFontOfSize:18];
    [self.backGroundView addSubview:self.buyCountLB];
    
    __weak typeof(self)weakSelf = self;
    self.packageCountView = [[PackageCountView alloc]initWithFrame:CGRectMake(kScreenWidth - 116 , CGRectGetMaxY(self.guigeCollectionView.frame) + 32, 96, 23)];
    self.packageCountView.countBlock = ^(int count) {
        weakSelf.buyCount = count;
    };
    [self.backGroundView addSubview:self.packageCountView];
    
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sureBtn.frame = CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50);
    self.sureBtn.backgroundColor = UIRGBColor(254, 88, 38);
    [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.backGroundView addSubview:self.sureBtn];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PackageDetailSelectCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    [cell refreshWithInfo:@{}];
    
    if ([self.selectIndexPath isEqual:indexPath]) {
        [cell resetSelectState];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectIndexPath = indexPath;
    
    [self refreshUIWithInfo:@{}];
}

- (void)refreshUIWithInfo:(NSDictionary *)infoDic
{
    self.priceLB.text = [infoDic objectForKey:@"price"];
    self.storeCountLB.text = [infoDic objectForKey:@"storeCount"];
    self.selectLB.text = [infoDic objectForKey:@"select"];
    [self.packageCountView reset];
    [self.guigeCollectionView reloadData];
}

@end
