//
//  ShowPhotoViewController.h
//  Accountant
//
//  Created by aaa on 2017/3/16.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowPhotoDelegate <NSObject>

- (void)didPhotoDelete;

@end

@interface ShowPhotoViewController : UIViewController

@property (nonatomic,weak) id<ShowPhotoDelegate> delegate;

@property (nonatomic,assign) BOOL                    isShowDelete;

- (instancetype)initWithImage:(UIImage *)image;

@end
