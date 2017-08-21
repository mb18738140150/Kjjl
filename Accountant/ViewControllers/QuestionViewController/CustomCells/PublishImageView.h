//
//  PublishImageView.h
//  Accountant
//
//  Created by aaa on 2017/3/15.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishImageView : UIView

@property (nonatomic,strong) UIImageView            *contentImageView;
@property (nonatomic,strong) UIImageView            *closeImageView;

- (void)resetDefaultImage;

- (void)showCloseImage;
- (void)hideCloseImage;

@end
