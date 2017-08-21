//
//  ShowPhotoViewController.m
//  Accountant
//
//  Created by aaa on 2017/3/16.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "ShowPhotoViewController.h"
#import "UIMacro.h"

@interface ShowPhotoViewController ()<UIAlertViewDelegate>

@property (nonatomic,strong) UIImageView        *imageView;
@property (nonatomic,strong) UIImage            *image;

@end

@implementation ShowPhotoViewController

- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super init]) {
        self.image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"浏览";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close-2.png"] style:UIBarButtonItemStylePlain target:self action:@selector(dissmiss)];
    self.navigationItem.leftBarButtonItem = item;
    
    
    if (self.isShowDelete) {
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(delete)];
        self.navigationItem.rightBarButtonItem = item1;
    }
    
    
    [self initContentViews];
    
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
}

- (void)dissmiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)delete
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要删除么" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.delegate didPhotoDelete];
        [self dissmiss];
    }
}

- (void)initContentViews
{
    self.imageView = [[UIImageView alloc] init];
    if (self.image.size.height > self.image.size.width) {
        float height = kScreenHeight - kStatusBarHeight - kNavigationBarHeight;
        float width = height/self.image.size.height*self.image.size.width;
        self.imageView.frame = CGRectMake(kScreenWidth/2 - width/2, 0, width, height);
    }else{
        float width = kScreenWidth;
        float height = width / self.image.size.width * self.image.size.height;
        self.imageView.frame = CGRectMake(0, kScreenHeight/2-height/2 - kNavigationBarHeight, width, height);
    }
    self.imageView.image = self.image;
    [self.view addSubview:self.imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
