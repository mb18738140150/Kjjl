//
//  PackageDetailSelectView.h
//  Accountant
//
//  Created by aaa on 2018/4/17.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PackageCountView.h"

@interface PackageDetailSelectView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)UIView * backGroundView;

@property (nonatomic, strong)UIImageView * iconImageView;
@property (nonatomic, strong)UILabel * priceLB;
@property (nonatomic, strong)UILabel * storeCountLB;
@property (nonatomic, strong)UILabel * selectLB;
@property (nonatomic, strong)UILabel * guigeLB;
@property (nonatomic, strong)UICollectionView * guigeCollectionView;
@property (nonatomic, strong)UILabel * buyCountLB;
@property (nonatomic, strong)PackageCountView * packageCountView;
@property (nonatomic, assign)int buyCount;
@property (nonatomic, strong)UIButton * sureBtn;

@property (nonatomic, strong)NSString *imageUrl;
@property (nonatomic, strong)NSArray * dataArray;
@property (nonatomic, strong)NSIndexPath * selectIndexPath;
@property (nonatomic, strong)NSDictionary * selectInfoDic;
@property (nonatomic, copy)void(^selectBlock)(NSDictionary * infoDic);
@property (nonatomic, copy)void(^dismissBlock)();

- (void)resetUI;

@end
