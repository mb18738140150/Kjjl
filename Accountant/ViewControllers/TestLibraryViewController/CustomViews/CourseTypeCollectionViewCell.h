//
//  CourseTypeCollectionViewCell.h
//  Accountant
//
//  Created by aaa on 2017/6/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseTypeCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *detailLB;


- (void)resetWithInfo:(NSDictionary *)infoDic;

@end
