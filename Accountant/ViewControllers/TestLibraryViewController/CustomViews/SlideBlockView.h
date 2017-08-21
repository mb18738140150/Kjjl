//
//  SlideBlockView.h
//  tiku
//
//  Created by aaa on 2017/5/3.
//  Copyright © 2017年 ytx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MoveConversationViewBlock)(CGPoint point);

@interface SlideBlockView : UIView

@property (nonatomic, assign)CGPoint beginPoint;
@property (nonatomic, strong)UIImageView * backImageView;
@property (nonatomic, copy)MoveConversationViewBlock moveBlock;

- (void)moveSlideBlock:(MoveConversationViewBlock)block;

@end
