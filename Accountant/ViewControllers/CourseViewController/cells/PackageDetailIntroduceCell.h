//
//  PackageDetailIntroduceCell.h
//  Accountant
//
//  Created by aaa on 2018/4/27.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface PackageDetailIntroduceCell : UITableViewCell<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>

@property (nonatomic, strong)UIView * tipView;
@property (nonatomic, strong)UILabel * titleLB;
@property (nonatomic, assign)CGFloat height;

@property (nonatomic, strong)UITextView * textView;
@property (nonatomic, strong)UIImageView * introImageView;
@property (nonatomic, strong)WKWebView * webView;

@property (nonatomic, copy)void(^imgeComplateBlock)(CGFloat height);

- (void)resetWitnInfo:(NSDictionary *)infoDic andImage:(UIImageView *)imageView;
- (void)resetWithInfo:(NSDictionary *)infoDic;

@end
