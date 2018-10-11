//
//  LivingCourseTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/9/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "LivingCourseTableViewCell.h"
#import "LivingCourseCollectionViewCell.h"

#define kLivingCourseCollectionViewCellId @"LivingCourseCollectionViewCellId"

@interface LivingCourseTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView * collectionView;
@property (nonatomic, strong)NSArray * dataArr;

@end

@implementation LivingCourseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetInfoWithArray:(NSArray *)array
{
    self.dataArr = array;
    if (!self.collectionView) {
        
        UIView * seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        seperateView.backgroundColor = UIRGBColor(230, 230, 230);
//        [self.contentView addSubview:seperateView];
        
        UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(15, 10, 2, 15)];
        lineView1.backgroundColor = kCommonMainColor;
        [self.contentView addSubview:lineView1];
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView1.frame) + 5, 10, kScreenWidth - 40, 15)];
        titleLabel.textColor = kCommonMainTextColor_50;
        titleLabel.text = @"本月直播课程";
        titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:titleLabel];
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        if (IS_PAD) {
            layout.itemSize = CGSizeMake(kScreenWidth / 3, kScreenWidth / 5);
        }else
        {
            layout.itemSize = CGSizeMake(kScreenWidth / 2.2, kScreenWidth / 4);
        }
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView1.frame) + 10, kScreenWidth, kScreenWidth / 4) collectionViewLayout:layout];
        if (IS_PAD) {
            self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(lineView1.frame) + 10, kScreenWidth, kScreenWidth / 5);
        }
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView registerClass:[LivingCourseCollectionViewCell class] forCellWithReuseIdentifier:kLivingCourseCollectionViewCellId];
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:self.collectionView];
        
        UIView * seperateView2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView.frame) + 10, kScreenWidth, 3)];
        seperateView2.backgroundColor = UIRGBColor(230, 230, 230);
        [self.contentView addSubview:seperateView2];
        
        UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(seperateView2.frame) + 10, 2, 15)];
        lineView2.backgroundColor = kCommonMainColor;
        [self.contentView addSubview:lineView2];
        
        UILabel * titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView2.frame) + 5, lineView2.hd_y, kScreenWidth - 40, 15)];
        titleLabel2.textColor = kCommonMainTextColor_50;
        titleLabel2.text = @"本月直播时间表";
        titleLabel2.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:titleLabel2];
    }
    
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LivingCourseCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLivingCourseCollectionViewCellId forIndexPath:indexPath];
    [cell resetInfo:self.dataArr[indexPath.item]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_PAD) {
        return CGSizeMake(kScreenWidth / 3, kScreenWidth / 5);
    }
    return CGSizeMake(kScreenWidth / 2.2, kScreenWidth / 4);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.LivingCourseBlock) {
        self.LivingCourseBlock(self.dataArr[indexPath.row]);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
