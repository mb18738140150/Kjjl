//
//  LiveStreamingTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/6/15.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "LiveStreamingTableViewCell.h"
#import "LiveStreamingCollectionViewCell.h"

#define kLiveStreamingCollectionViewCellId @"LiveStreamingCollectionViewCellId"

@interface LiveStreamingTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView * collectionView;
@property (nonatomic, strong)UILabel * liveLB;
@property (nonatomic, strong)UIImageView * goImageView;

@end

@implementation LiveStreamingTableViewCell

- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (void)resetInfoWith:(NSArray *)dataArray
{
    self.dataArray = dataArray;
    self.backgroundColor = [UIColor whiteColor];
    if (!self.collectionView) {
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake((kScreenWidth - 15) / 2.5, 160);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth - 15, 160) collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView registerClass:[LiveStreamingCollectionViewCell class] forCellWithReuseIdentifier:kLiveStreamingCollectionViewCellId];
        [self addSubview:self.collectionView];
        
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 160, kScreenWidth, 50)];
        bottomView.backgroundColor = [UIColor whiteColor];
//        [self addSubview:bottomView];
        
        self.liveLB = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - 35, 15, 70, 20)];
        self.liveLB.text = @"进入直播";
        self.liveLB.font = kMainFont;
        self.liveLB.textColor = kCommonMainTextColor_100;
        self.liveLB.textAlignment = 1;
        self.liveLB.userInteractionEnabled = YES;
        [bottomView addSubview:self.liveLB];
        
        self.goImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.liveLB.frame), 18, 15, 14)];
        self.goImageView.image = [UIImage imageNamed:@"shouye-trankle"];
        [bottomView addSubview:self.goImageView];
        self.goImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goLiveStreamingClick)];
        [bottomView addGestureRecognizer:tap];
    }
    [self.collectionView reloadData];
}

- (void)goLiveStreamingClick
{
    NSLog(@"进入直播");
    if (self.morelivingBlock) {
        self.morelivingBlock();
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LiveStreamingCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLiveStreamingCollectionViewCellId forIndexPath:indexPath];
    [cell resetInfoWith:self.dataArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d", indexPath.item);
    
    if (self.clickBlock) {
        self.clickBlock(self.dataArray[indexPath.row]);
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
