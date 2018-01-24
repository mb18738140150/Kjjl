//
//  MKPPlaceholderTextView.h
//  MKPPlaceholderTextView
//
//  Created by  on 16/11/30.
//  Copyright © 2016年 毛凯平. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKPPlaceholderTextView : UITextView
/** 占位文字 */
@property(nonatomic,copy) NSString *placeholder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor * placeholderColor;

@end
