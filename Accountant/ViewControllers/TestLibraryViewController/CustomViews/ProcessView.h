//
//  ProcessView.h
//  tiku
//
//  Created by aaa on 2017/5/9.
//  Copyright © 2017年 ytx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProcessView : UIView

@property(nonatomic,assign)CGFloat progress;
@property (nonatomic, strong)CAShapeLayer * processLayer;

@end
