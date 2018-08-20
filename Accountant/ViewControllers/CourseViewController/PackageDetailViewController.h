//
//  PackageDetailViewController.h
//  Accountant
//
//  Created by aaa on 2018/4/20.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface PackageDetailViewController : UIViewController

@property (nonatomic, strong)NSNumber * packageId;

- (void)refreshWithId;

@end
