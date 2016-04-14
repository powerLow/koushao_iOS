//
//  ChooseCoverStyleViewController.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/10/30.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "ChooseCoverStyleViewController.h"
#import "ActivityFunctionViewController.h"
#import "KSActivityCreatManager.h"
#import "Masonry.h"
#import "ImageUploader.h"
#import "KSClientApi.h"
#import <YYWebImage.h>

@interface ChooseCoverStyleViewController ()
@property(nonatomic,copy)NSArray* styleImageArray;
@property(nonatomic,strong)UIImageView* styleImageView;
@property(nonatomic,strong)UIImageView* contentImageView;
@property(nonatomic,strong)UITableView* styleListTableView;
@property(nonatomic,assign)NSInteger aspectX;
@property(nonatomic,assign)NSInteger aspectY;
@property(nonatomic,assign)BOOL isDetailReady;
@property(nonatomic,assign)BOOL isCoverReady;
@property(nonatomic,strong)KSActivityCreatManager* activityManger;
@end

@implementation ChooseCoverStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initTitleBar];
    [self initView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initData
{
    self.isDetailReady=NO;
    self.isCoverReady=NO;
    self.activityManger=[KSActivityCreatManager sharedManager];
    self.styleImageArray=[NSArray arrayWithObjects:@"poster_style1",@"poster_style2",@"poster_style3",@"poster_style4",@"poster_style5",@"poster_style6",@"poster_style7",nil];
}
-(void)initView
{
    [self initBigArea];
    [self initStylesList];
}
#pragma mark 初始化大……的区域
-(void)initBigArea
{
    UIView* mainDisplayArea=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width/4*3, [[UIScreen mainScreen]bounds].size.height)];
    mainDisplayArea.backgroundColor=[KSUtil colorWithHexString:@"#F9FAFB"];
    [self.view addSubview:mainDisplayArea];
    
    UILabel* textLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 65, 200, 40)];
    textLabel.font=[UIFont fontWithName:@"Arial" size:14];
    textLabel.text=@"你选定的版式";
    textLabel.textColor=[UIColor grayColor];
    [mainDisplayArea addSubview:textLabel];
    
    CGFloat mainDisplayWidth=([[UIScreen mainScreen]bounds].size.width/4*3)-40;
    UIView* mainDisplayPhoneContainer=[[UIView alloc]initWithFrame:CGRectMake(20, 100, mainDisplayWidth, mainDisplayWidth*2.02)];
    [mainDisplayArea addSubview:mainDisplayPhoneContainer];
    
    UIImageView* phoneShellImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mainDisplayWidth, mainDisplayWidth*2.02)];
    phoneShellImageView.image=[UIImage imageNamed:@"ic_mp2"];
    [mainDisplayPhoneContainer addSubview:phoneShellImageView];
    
    UIView* contentView=[[UIView alloc]initWithFrame:CGRectMake(mainDisplayWidth*0.07, mainDisplayWidth*0.406, mainDisplayWidth*0.86, mainDisplayWidth*1.379)];
    
    self.contentImageView=[[UIImageView alloc]init];
    [self.contentImageView setContentMode:UIViewContentModeScaleAspectFill];
    self.contentImageView.frame=[self getContentImageFrameByIndex:self.activityManger.coverStyle andContentViewWidth:mainDisplayWidth*0.86];
    self.contentImageView.clipsToBounds=YES;
    [self setContentImage:self.contentImageView];
    [contentView addSubview:self.contentImageView];
    
    self.styleImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,mainDisplayWidth*0.86, mainDisplayWidth*1.379)];
    self.styleImageView.image=[UIImage imageNamed:[self.styleImageArray objectAtIndex:self.activityManger.coverStyle]];
    [mainDisplayPhoneContainer addSubview:contentView];
    [contentView addSubview:  self.styleImageView];
    
    NSString* imagePath=self.activityManger.coverPosterPath;
    UIButton* cropPictureButton=[[UIButton alloc]init];
    if([imagePath hasPrefix:KS_SANDBOX])
    {
        cropPictureButton.alpha=1;
    }
    
    else if ([imagePath hasPrefix:@"assets-library://"])
    {
        cropPictureButton.alpha=1;
    }
    else
    {
        cropPictureButton.alpha=0;
    }
    [contentView addSubview:cropPictureButton];
    [cropPictureButton setTitle:@"点击可裁切图片" forState:UIControlStateNormal];
    [cropPictureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cropPictureButton.titleLabel.font=[UIFont fontWithName:@"Arial" size:20];
    cropPictureButton.backgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];
    @weakify(self)
    [cropPictureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(self.styleImageView.mas_width);
        make.bottom.mas_equalTo(self.styleImageView.mas_bottom);
        make.left.mas_equalTo(self.styleImageView.mas_left);
    }];
    
    [[cropPictureButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        
        NSInteger detailPos=self.styleListTableView.indexPathForSelectedRow.row;
        
        self.aspectX = 5;
        self.aspectY = 8;//默认裁切比例 3-6
        if (detailPos < 2) {// 1 2 正方形
            self.aspectX = 1;
            self.aspectY = 1;
        } else if (detailPos == 6) { //7 长方形
            self.aspectX = 7;
            self.aspectY = 5;
        }
        
        NSString* originImagePath=self.activityManger.coverPosterOriginalImagePath;
        if([originImagePath hasPrefix:KS_SANDBOX])
        {
            UIImage* targetImage=[self getImageFileWithLocalName:[NSString stringWithFormat:@"%@/%@",LOCAL_IMAGE_DIC,[originImagePath stringByReplacingOccurrencesOfString:KS_SANDBOX withString:@""]]];
            [self startCrop:targetImage];
        }
        
        else if ([originImagePath hasPrefix:@"assets-library://"])
        {
            [KSUtil loadItem:[NSURL URLWithString:originImagePath ] withSuccessBlock:^(ALAsset *asset) {
                UIImage* targetImage=[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage] ];
                [self startCrop:targetImage];
            } andFailureBlock:^{
                
            }];
        }
        
    }];
}
-(void)startCrop:(UIImage*)image
{
    dispatch_async(dispatch_get_main_queue(), ^{
        RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image];
        imageCropVC.delegate = self;
        imageCropVC.dataSource=self;
        imageCropVC.cropMode=RSKImageCropModeCustom;
        [self.navigationController pushViewController:imageCropVC animated:YES];
        
    });
    
}

-(CGRect)getContentImageFrameByIndex:(NSInteger)index andContentViewWidth:(CGFloat)contentViewWidth
{
    if(index==0)
    {
        return CGRectMake(contentViewWidth*0.15,contentViewWidth*0.17, contentViewWidth*0.72, contentViewWidth*0.72);
    }
    else if(index==1)
    {
        return CGRectMake(0, 0, contentViewWidth, contentViewWidth);
    }
    else if(index==6)
    {
        return CGRectMake(0, 0, contentViewWidth, contentViewWidth*0.73);
    }
    else
    {
        return CGRectMake(0, 0, contentViewWidth, contentViewWidth*1.6);
        
    }
    return CGRectMake(0, 0, 0, 0);
}

#pragma mark 初始化样式列表
-(void)initStylesList
{
    UIView* StylesListArea=[[UIView alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/4*3, 0, [[UIScreen mainScreen] bounds].size.width/4, [[UIScreen mainScreen]bounds].size.height)];
    StylesListArea.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:StylesListArea];
    
    CGFloat mainDisplayWidth=([[UIScreen mainScreen]bounds].size.width/4)-10;
    self.styleListTableView=[[UITableView alloc]initWithFrame:CGRectMake(5, 0, mainDisplayWidth, [[UIScreen mainScreen]bounds].size.height)];
    [StylesListArea addSubview:self.styleListTableView];
    self.styleListTableView.delegate=self;
    self.styleListTableView.dataSource=self;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(100, 0.0, 0.0, 0.0);
    self.styleListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.styleListTableView setContentInset:contentInsets];
    
    NSIndexPath* indexPath=[NSIndexPath indexPathForRow:self.activityManger.coverStyle inSection:0];
    [self.styleListTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    self.styleListTableView.showsVerticalScrollIndicator=NO;
}

#pragma 样式列表的TableViewCell代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* tableViewCell=[[UITableViewCell alloc]init];
//    tableViewCell.selectedBackgroundView = [[UIView alloc] initWithFrame:tableViewCell.frame];
//    tableViewCell.selectedBackgroundView.backgroundColor = [KSUtil colorWithHexString:@"#2CBD86"];
    tableViewCell.selectedBackgroundView.layer.borderWidth = 1;
    tableViewCell.selectedBackgroundView.layer.borderColor = BASE_COLOR.CGColor;
    CGFloat mainDisplayWidth=([[UIScreen mainScreen]bounds].size.width/4);
    
    UIView* contentView=[[UIView alloc]initWithFrame:CGRectMake(mainDisplayWidth*0.02, 8, mainDisplayWidth*0.86, mainDisplayWidth*1.379)];
    
    UIImageView* insetCoverImageView=[[UIImageView alloc]init];
    [insetCoverImageView setContentMode:UIViewContentModeScaleAspectFill];
    insetCoverImageView.frame=[self getContentImageFrameByIndex:indexPath.row andContentViewWidth:mainDisplayWidth*0.86];
    insetCoverImageView.clipsToBounds=YES;
    [self setContentImage:insetCoverImageView];
    [contentView addSubview:insetCoverImageView];
    
    
    UIImageView* styleImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,mainDisplayWidth*0.862, mainDisplayWidth*1.379)];
    styleImageView.image=[UIImage imageNamed:[self.styleImageArray objectAtIndex:indexPath.row]];
    
    [contentView addSubview:styleImageView];
    [tableViewCell.contentView addSubview:contentView];
    
    return tableViewCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat mainDisplayWidth=([[UIScreen mainScreen]bounds].size.width/4)-10;
    return mainDisplayWidth*1.6+10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.styleImageView.image=[UIImage imageNamed:[self.styleImageArray objectAtIndex:indexPath.row]];
    [self setContentImage:self.contentImageView];
    CGFloat mainDisplayWidth=([[UIScreen mainScreen]bounds].size.width/4*3)-40;
    self.contentImageView.frame=[self getContentImageFrameByIndex:indexPath.row andContentViewWidth:mainDisplayWidth*0.86];
    self.activityManger.coverStyle=indexPath.row;
    [self.activityManger ks_saveOrUpdate];
}

-(void)initTitleBar
{
    self.navigationItem.backBarButtonItem.title=@"";
    //下一步按钮
    UILabel* rightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 80, 40)];
    rightTitleLabel.backgroundColor = [UIColor clearColor];
    rightTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    rightTitleLabel.textColor = [UIColor whiteColor];
    rightTitleLabel.text = @"完成";
    rightTitleLabel.textAlignment=NSTextAlignmentRight;
    UIButton* rightTitleButton=[[UIButton alloc] initWithFrame:CGRectMake(0,0,80,40)];
    [rightTitleButton addSubview:rightTitleLabel];
    [rightTitleButton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightTitleButton];
    
    //设置NavigationBar的相关属性
    // self.navigationItem.leftBarButtonItem=leftBarButtonItem;
    self.navigationItem.rightBarButtonItem=rightBarButtonItem;
}

-(void)backToActivityList
{
    [self.navigationController popViewControllerAnimated:YES];
}

//图片上传完之后的下一个步骤
-(void)processNext
{
    if(self.isDetailReady&&self.isCoverReady)
    {
        [[KSClientApi setActivityTemplete]subscribeNext:^(id x) {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            self.activityManger.isTempleteSettingComplete=YES;
            [self.activityManger ks_saveOrUpdate];
            if(self.isModify)
            {
                NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
            }
            else
            {
                ActivityFunctionViewController * activityFunctionViewController=[[ActivityFunctionViewController alloc]init];
                activityFunctionViewController.title=@"活动功能";
                activityFunctionViewController.view.backgroundColor=[KSUtil colorWithHexString:@"#F9FAFB"];
                self.isCoverReady=NO;
                self.isDetailReady=NO;
                [self.navigationController pushViewController:activityFunctionViewController animated:YES];
            }
        } error:^(NSError *error) {
            self.isCoverReady=NO;
            self.isDetailReady=NO;
            KSError([error.userInfo objectForKey:@"tips"]);
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            
        }];
    }
    
}
-(void)nextStep
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].labelText = @"正在提交数据";
    NSString* detailPosterPath=[self.activityManger.detailPosterArray objectAtIndex:self.activityManger.detailStyle];
    NSString* coverPosterPath=self.activityManger.coverPosterPath;
    
    //详情版式的图片
    if([detailPosterPath hasPrefix:@"http://"])
    {
        [self.activityManger.detailPosterHashMap setObject:detailPosterPath forKey:detailPosterPath];
        self.isDetailReady=YES;
        [self processNext];
    }
    else if([self.activityManger.detailPosterHashMap objectForKey:detailPosterPath]) //先前已经上传过该图片
    {
        self.isDetailReady=YES;
        [self processNext];
    }
    else //没有上传
    {
        ImageUploader* imageUploader=[[ImageUploader alloc]init];
        imageUploader.imagePath=detailPosterPath;
        imageUploader.action=5;
        [imageUploader beginUploadImageWithSuccessBlock:^(NSString *url) {
            [self.activityManger.detailPosterHashMap setObject:url forKey:detailPosterPath];
            self.isDetailReady=YES;
            [self processNext];
        } andFailureBlock:^{
            KSError(@"天了噜！出现了一个错误！");
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        }];
    }
    
    //封面版式的图片
    if([coverPosterPath hasPrefix:@"http://"])
    {
        [self.activityManger.coverPosterHashMap setObject:coverPosterPath forKey:coverPosterPath];
        self.isCoverReady=YES;
        [self processNext];
    }
    else if([self.activityManger.coverPosterHashMap objectForKey:coverPosterPath]) //先前已经上传过该图片
    {
        self.isCoverReady=YES;
        [self processNext];
    }
    else //没有上传
    {
        ImageUploader* imageUploader=[[ImageUploader alloc]init];
        imageUploader.imagePath=coverPosterPath;
        imageUploader.action=1;
        [imageUploader beginUploadImageWithSuccessBlock:^(NSString *url) {
            [self.activityManger.coverPosterHashMap setObject:url forKey:coverPosterPath];
            self.isCoverReady=YES;
            [self processNext];
        } andFailureBlock:^{
            KSError(@"天了噜！出现了一个错误！");
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        }];
    }
}

-(UIImage*) getImageFileWithLocalName:(NSString*)filePath
{
    NSError* err = [[NSError alloc] init];
    NSData* data = [[NSData alloc] initWithContentsOfFile:filePath
                                                  options:NSDataReadingMapped
                                                    error:&err];
    UIImage* img = nil;
    if(data != nil)
    {
        img = [[UIImage alloc] initWithData:data];
    }
    else
    {
        NSLog(@"getImageFileWithName error code : %ld",(long)[err code]);
    }
    return img;
}

-(void)setContentImage:(UIImageView*)imageView
{
    NSString* imagePath=self.activityManger.coverPosterPath;
    if([imagePath hasPrefix:KS_SANDBOX])
    {
        imageView.image=[self getImageFileWithLocalName:[NSString stringWithFormat:@"%@/%@",LOCAL_IMAGE_DIC,[imagePath stringByReplacingOccurrencesOfString:KS_SANDBOX withString:@""]]];
    }
    else if([imagePath containsString:@"http://"])
    {
        NSURL* url=[NSURL URLWithString:imagePath];
        [imageView yy_setImageWithURL:url placeholder:nil];
    }
    else if ([imagePath hasPrefix:@"assets-library://"])
    {
        [KSUtil loadItem:[NSURL URLWithString:imagePath ] withSuccessBlock:^(ALAsset *asset) {
            imageView.image=[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage] ];
        } andFailureBlock:^{
            
        }];
    }
    else
    {
        imageView.image=[UIImage imageNamed:imagePath];
    }
}

#pragma mark 图片裁切的相关方法
-(void)saveCroopedToSandBox:(UIImage*)croppedImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* filename=[NSString stringWithFormat:@"%@.jpg",[KSUtil getUUIDString]];
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:filename];   // 保存文件的名称
    BOOL result = [UIImagePNGRepresentation(croppedImage)writeToFile: filePath    atomically:YES];
    if(result)
    {
        NSLog(filePath,nil);
        NSString* filenameResult=[NSString stringWithFormat:@"%@%@",KS_SANDBOX,filename];
        self.activityManger.coverPosterPath=filenameResult;
        [self.activityManger ks_saveOrUpdate];
        [self setContentImage:self.contentImageView];
        [self.styleListTableView reloadData];
        [self.styleListTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.activityManger.coverStyle inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
        [self.navigationController popViewControllerAnimated:YES];
        [self.activityManger ks_saveOrUpdate];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:true completion:nil];
}

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image has been cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
{
    [self saveCroopedToSandBox:croppedImage];
}

// The original image has been cropped. Additionally provides a rotation angle used to produce image.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
                  rotationAngle:(CGFloat)rotationAngle
{
    [self saveCroopedToSandBox:croppedImage];
}

// The original image will be cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                  willCropImage:(UIImage *)originalImage
{
    // Use when `applyMaskToCroppedImage` set to YES.
    
}


// Returns a custom rect for the mask.
- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller
{
    CGSize maskSize;
    CGFloat width=SCREEN_WIDTH*0.9;
    if ([controller isPortraitInterfaceOrientation]) {
        maskSize = CGSizeMake(width, width*self.aspectY/self.aspectX);
    } else {
        maskSize = CGSizeMake(width, width*self.aspectY/self.aspectX);
    }
    
    CGFloat viewWidth = CGRectGetWidth(controller.view.frame);
    CGFloat viewHeight = CGRectGetHeight(controller.view.frame);
    
    CGRect maskRect = CGRectMake((viewWidth - maskSize.width) * 0.5f,
                                 (viewHeight - maskSize.height) * 0.5f,
                                 maskSize.width,
                                 maskSize.height);
    return maskRect;
}

// Returns a custom path for the mask.
- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller
{
    CGRect rect = controller.maskRect;
    CGPoint point1 = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPoint point2 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGPoint point3 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGPoint point4 = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
    
    UIBezierPath *rectangle = [UIBezierPath bezierPath];
    [rectangle moveToPoint:point1];
    [rectangle addLineToPoint:point2];
    [rectangle addLineToPoint:point3];
    [rectangle addLineToPoint:point4];
    [rectangle closePath];
    return rectangle;
}

- (CGRect)imageCropViewControllerCustomMovementRect:(RSKImageCropViewController *)controller
{
    return controller.maskRect;
}
@end
