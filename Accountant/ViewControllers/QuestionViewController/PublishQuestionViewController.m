//
//  PublishQuestionViewController.m
//  Accountant
//
//  Created by aaa on 2017/3/13.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "PublishQuestionViewController.h"
#import "UIMacro.h"
#import "QuestionManager.h"
#import "CommonMacro.h"
#import "SVProgressHUD.h"
#import "UIUtility.h"
#import "PublishImageView.h"
#import "ShowPhotoViewController.h"
#import "TZImagePickerController.h"
#import "ImageManager.h"
#import "SVProgressHUD.h"
#import "UIImage+Base64.h"

@interface PublishQuestionViewController ()<QuestionModule_QuestionPublishProtocol,TZImagePickerControllerDelegate,ShowPhotoDelegate,ImageModule_UploadProtocol>

@property (nonatomic,strong) UIControl          *resignControl;

@property (nonatomic,strong) UITableView        *contentTableView;

@property (nonatomic,strong) UILabel            *titleLabel;
@property (nonatomic,strong) UITextField        *titleField;
@property (nonatomic,strong) UILabel            *categoryLabel;
@property (nonatomic,strong) UIButton           *selectedCategoryButton;
@property (nonatomic,strong) UILabel            *categorySelectedLabel;
@property (nonatomic,strong) UILabel            *contentLabel;
@property (nonatomic,strong) UITextView         *contentField;

@property (nonatomic,strong) PublishImageView   *imageView1;
@property (nonatomic,strong) PublishImageView   *imageView2;
@property (nonatomic,strong) PublishImageView   *imageView3;

@property (nonatomic,assign) int                 clickImageIndex;


@property (nonatomic,strong) NSMutableArray     *imagesArray;

@property (nonatomic,strong) UIButton           *button1;
@property (nonatomic,strong) UIButton           *button2;
@property (nonatomic,strong) UIButton           *button3;
@property (nonatomic,strong) UIButton           *button4;

@property (nonatomic,assign) int                 categoryId;
@property (nonatomic,strong) NSString           *categoryName;


@end

@implementation PublishQuestionViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.categoryId = 17;
    self.categoryName = @"会计";
    self.imagesArray = [[NSMutableArray alloc] init];
    self.clickImageIndex = 0;
    
    [self navigationViewSetup];
    [self contentViewSetup];
    
    [self button1Click];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    self.contentField.frame = CGRectMake(20, 90, kScreenWidth - 40, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kbSize.height - 150 - 40);
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    self.contentField.frame = CGRectMake(20, 90, kScreenWidth - 40, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kTabBarHeight - 150 - 40);
    //do something
}

- (void)navigationViewSetup
{
    self.navigationItem.title = @"发布问题";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50};
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishQuestion)];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xFF671D)} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = item;
    [self.navigationItem.rightBarButtonItem setTintColor:kCommonMainTextColor_50];
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"public-返回"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
}

- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)publishQuestion
{
    if ([[UserManager sharedManager]getUserLevel] != 3) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"暂无答疑权限，请先购买会员" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (self.titleField.text != nil && self.contentField.text != nil && ![@""isEqualToString:self.titleField.text] && ![@"" isEqualToString:self.contentField.text]) {
        
        NSMutableString *imageStr = [[NSMutableString alloc] init];
        if (self.imagesArray.count != 0) {
            for (UIImage *image in self.imagesArray) {
                [imageStr appendString:[image base64]];
                [imageStr appendString:@"|"];
            }
            [imageStr deleteCharactersInRange:NSMakeRange(imageStr.length-1, 1)];
        }else{
            imageStr = [NSMutableString stringWithFormat:@""];
        }
        
        [SVProgressHUD show];
        NSDictionary *questionInfo = @{kQuestionClassId:@(self.categoryId),
                                       kQuestionTitle:self.categoryName,
                                       kQuestionContent:self.contentField.text,
                                       kQuestionImgStr:imageStr};
        [[QuestionManager sharedManager] didRequestPublishQuestionWithQuestionInfos:questionInfo withNotifiedObject:self];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"发布信息不完整" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }
    
}


- (void)selectCategory
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"选择分类" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"会计",@"出纳",@"税务",@"其它", nil];
    [alert show];
}

- (void)didQuestionPublishSuccessed
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"发布成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)didQuestionPublishFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)resignText
{
    [self.titleField resignFirstResponder];
    [self.contentField resignFirstResponder];
}

- (void)contentViewSetup
{
    self.resignControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kTabBarHeight)];
    [self.resignControl addTarget:self action:@selector(resignText) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.resignControl];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 60, 20)];
    self.titleLabel.text = @"标  题";
    [self.resignControl addSubview:self.titleLabel];
    
    self.titleField = [[UITextField alloc] initWithFrame:CGRectMake(100, 20, 200, 20)];
    self.titleField.placeholder = @"  请输入标题";
    [self.resignControl addSubview:self.titleField];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 19, 200, 1)];
    bottomLine.backgroundColor = kTableViewCellSeparatorColor;
    [self.titleField addSubview:bottomLine];
    
    self.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 60, 20)];
    self.categoryLabel.text = @"分  类";
    [self.resignControl addSubview:self.categoryLabel];
    
    float buttonWidth = (kScreenWidth - 120)/4;
    self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button1.frame = CGRectMake(100, 60, buttonWidth, 20);
    [self.button1 setTitle:@"会计" forState:UIControlStateNormal];
    [self.button1 setTitleColor:kTableViewCellSeparatorColor forState:UIControlStateNormal];
    [self.button1 addTarget:self action:@selector(button1Click) forControlEvents:UIControlEventTouchUpInside];
    [self.resignControl addSubview:self.button1];
    
    self.button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button2.frame = CGRectMake(100 + buttonWidth, 60, buttonWidth, 20);
    [self.button2 setTitle:@"出纳" forState:UIControlStateNormal];
    [self.button2 setTitleColor:kTableViewCellSeparatorColor forState:UIControlStateNormal];
    [self.button2 addTarget:self action:@selector(button2Click) forControlEvents:UIControlEventTouchUpInside];
    [self.resignControl addSubview:self.button2];
    
    self.button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button3.frame= CGRectMake(100+buttonWidth*2, 60, buttonWidth, 20);
    [self.button3 setTitle:@"税务" forState:UIControlStateNormal];
    [self.button3 setTitleColor:kTableViewCellSeparatorColor forState:UIControlStateNormal];
    [self.button3 addTarget:self action:@selector(button3Click) forControlEvents:UIControlEventTouchUpInside];
    [self.resignControl addSubview:self.button3];
    
    self.button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button4.frame = CGRectMake(100 + buttonWidth * 3, 60, buttonWidth, 20);
    [self.button4 setTitle:@"其它" forState:UIControlStateNormal];
    [self.button4 setTitleColor:kTableViewCellSeparatorColor forState:UIControlStateNormal];
    [self.button4 addTarget:self action:@selector(button4Click) forControlEvents:UIControlEventTouchUpInside];
    [self.resignControl addSubview:self.button4];
    
    
    self.contentField = [[UITextView alloc] initWithFrame:CGRectMake(20, 90, kScreenWidth - 40, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kTabBarHeight - 150 - 40)];
    
    self.contentField.layer.borderWidth = 1;
    self.contentField.layer.borderColor = kTableViewCellSeparatorColor.CGColor;
    self.contentField.layer.cornerRadius = 5;
    [self.resignControl addSubview:self.contentField];
    
    self.imageView1 = [[PublishImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.contentField.frame) + 10, 60, 60)];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImageClickFunc1)];
    [self.imageView1 addGestureRecognizer:tap1];
    self.imageView1.userInteractionEnabled = YES;
    
    self.imageView2 = [[PublishImageView alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(self.contentField.frame) + 10, 60, 60)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImageClickFunc2)];
    [self.imageView2 addGestureRecognizer:tap2];
    self.imageView2.userInteractionEnabled = YES;
    
    self.imageView3 = [[PublishImageView alloc] initWithFrame:CGRectMake(180, CGRectGetMaxY(self.contentField.frame) + 10, 60, 60)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImageClickFunc3)];
    [self.imageView3 addGestureRecognizer:tap3];
    self.imageView3.userInteractionEnabled = YES;
    
    [self resetImageViews];
    
}

- (void)resetImageViews
{
    [self.imageView1 removeFromSuperview];
    [self.imageView2 removeFromSuperview];
    [self.imageView3 removeFromSuperview];
    NSUInteger imageCount = self.imagesArray.count;
    if (imageCount == 0) {
        [self.imageView1 resetDefaultImage];
        [self.view addSubview:self.imageView1];
    }
    if (imageCount == 1) {
        self.imageView1.contentImageView.image = [self.imagesArray objectAtIndex:0];
        [self.view addSubview:self.imageView1];
        [self.imageView2 resetDefaultImage];
        [self.view addSubview:self.imageView2];
    }
    if (imageCount == 2) {
        self.imageView1.contentImageView.image = [self.imagesArray objectAtIndex:0];
        [self.view addSubview:self.imageView1];
        self.imageView2.contentImageView.image = [self.imagesArray objectAtIndex:1];
        [self.view addSubview:self.imageView2];
        [self.imageView3 resetDefaultImage];
        [self.view addSubview:self.imageView3];
    }
    if (imageCount == 3) {
        self.imageView1.contentImageView.image = [self.imagesArray objectAtIndex:0];
        [self.view addSubview:self.imageView1];
        self.imageView2.contentImageView.image = [self.imagesArray objectAtIndex:1];
        [self.view addSubview:self.imageView2];
        self.imageView3.contentImageView.image = [self.imagesArray objectAtIndex:2];
        [self.view addSubview:self.imageView3];
    }
    
}

- (void)selectImage
{
    if (self.clickImageIndex < self.imagesArray.count) {
        ShowPhotoViewController *vc = [[ShowPhotoViewController alloc] initWithImage:[self.imagesArray objectAtIndex:self.clickImageIndex]];
        vc.delegate = self;
        vc.isShowDelete = YES;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }else{
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
        imagePickerVc.allowPickingVideo = NO;
        [self.navigationController presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

- (void)uploadImage:(UIImage *)image
{
    [SVProgressHUD show];
    NSData *data = UIImagePNGRepresentation(image);
    [[ImageManager sharedManager] didUploadImage:data withNotifiedObject:self];
}

#pragma mark - upload delegate
- (void)didImageUploadSuccess
{
    [SVProgressHUD dismiss];
}

- (void)didImageUploadFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - show photo delegate
- (void)didPhotoDelete
{
    [self.imagesArray removeObjectAtIndex:self.clickImageIndex];
    [self resetImageViews];
}

#pragma mark - pick image func
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    UIImage *image = [photos lastObject];
    if (self.clickImageIndex < self.imagesArray.count) {
        [self.imagesArray removeObjectAtIndex:self.clickImageIndex];
        [self.imagesArray insertObject:image atIndex:self.clickImageIndex];
    }else{
        [self.imagesArray addObject:image];
    }
    [self resetImageViews];
/*    if (self.clickImageIndex < self.imagesArray.count) {
        [self.imagesArray removeObjectAtIndex:self.clickImageIndex];
        [self.imagesArray insertObject:image atIndex:self.clickImageIndex];
    }else{
        [self.imagesArray addObject:image];
    }
    [self uploadImage:image];
    [self resetImageViews];*/
}

#pragma mark - response func
- (void)addImageClickFunc1
{
    self.clickImageIndex = 0;
    [self selectImage];
}

- (void)addImageClickFunc2
{
    self.clickImageIndex = 1;
    [self selectImage];
}

- (void)addImageClickFunc3
{
    self.clickImageIndex = 2;
    [self selectImage];
}

- (void)resetButtons
{
    [self resignText];
    [self.button1 setTitleColor:kTableViewCellSeparatorColor forState:UIControlStateNormal];
    [self.button2 setTitleColor:kTableViewCellSeparatorColor forState:UIControlStateNormal];
    [self.button3 setTitleColor:kTableViewCellSeparatorColor forState:UIControlStateNormal];
    [self.button4 setTitleColor:kTableViewCellSeparatorColor forState:UIControlStateNormal];
}

- (void)button1Click
{
    [self resetButtons];
    [self.button1 setTitleColor:UIColorFromRGB(0xFF671D) forState:UIControlStateNormal];
    self.categoryId = 17;
}

- (void)button2Click
{
    [self resetButtons];
    [self.button2 setTitleColor:UIColorFromRGB(0xFF671D) forState:UIControlStateNormal];
    self.categoryId = 18;
}

- (void)button3Click
{
    [self resetButtons];
    [self.button3 setTitleColor:UIColorFromRGB(0xFF671D) forState:UIControlStateNormal];
    self.categoryId = 19;
}

- (void)button4Click
{
    [self resetButtons];
    [self.button4 setTitleColor:UIColorFromRGB(0xFF671D) forState:UIControlStateNormal];
    self.categoryId = 20;
}

@end
