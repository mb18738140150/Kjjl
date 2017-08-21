//
//  SimulateresultCollectionReusableView.h
//  Accountant
//
//  Created by aaa on 2017/4/5.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimulateresultCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong)UIView * topView;
@property (nonatomic, strong)UIView * seperateView;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UIImageView * imageView;
- (void)resetWithTitle:(NSString *)title;

@end
