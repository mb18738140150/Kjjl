//
//  ScreenCollectionViewCell.h
//  Accountant
//
//  Created by aaa on 2017/4/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *seperateLine;

-(void) resetWith:(NSString *)string;

@end
