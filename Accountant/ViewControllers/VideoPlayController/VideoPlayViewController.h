//
//  VideoPlayViewController.h
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoPlayViewController : UIViewController

@property (nonatomic,assign) BOOL                            isPlayFromLoacation;
@property (nonatomic,assign) int                             beginChapterId;
@property (nonatomic,assign) int                             beginVideoId;

@property (nonatomic, strong)NSDictionary                    *infoDic;

- (void)dismissStiop;

@end
