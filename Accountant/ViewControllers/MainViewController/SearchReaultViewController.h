//
//  SearchReaultViewController.h
//  Accountant
//
//  Created by aaa on 2017/7/5.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SearchResultType_videoCourse,
    SearchResultType_livingStream,
} SearchResultType;

@interface SearchReaultViewController : UIViewController

@property (nonatomic, assign)SearchResultType searchResultType;

@end
