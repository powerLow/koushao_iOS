//
//  InternalPhotoSlectorViewController.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/16.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "InternalPhotoSlectorViewController.h"
#import "KSClientApi.h"

#import "InternalPictureModel.h"
#import <YYWebImage.h>
@interface InternalPhotoSlectorViewController ()
@property(nonatomic,strong)UICollectionView* collectionView;
@property(nonatomic,strong)NSArray* imageArray;
@property(nonatomic,copy)NSString* originPath;
@end
@implementation InternalPhotoSlectorViewController
static NSString * CellIdentifier = @"GradientCell";
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor=[UIColor whiteColor];
    [self initData];
}
-(void)initView
{
    //初始化布局类(UICollectionViewLayout的子类)
    self.title=@"选择图片";
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
    //初始化collectionView
    fl.minimumLineSpacing=5;
    fl.minimumInteritemSpacing=5;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:fl];
    [self.view addSubview:self.collectionView];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    self.view.backgroundColor=[UIColor whiteColor];
    self.collectionView.backgroundColor=[UIColor whiteColor];
}
-(void)initData
{
    self.imageArray=[[NSArray alloc]init];
    @weakify(self)
    [[KSClientApi getNetPic:3]subscribeNext:^(NSArray* x) {
        @strongify(self)
        self.imageArray=x;
        [self initView];
    } error:^(NSError *error) {
        
    }];
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count+1;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    UIImageView* imageView=[[UIImageView alloc]initWithFrame:cell.contentView.frame];
    [cell.contentView addSubview:imageView];
    if(indexPath.row==0)
    {
        imageView.image=[UIImage imageNamed:@"choose_photo"];
    }
    else
    {
        InternalPictureModel* InternalPictureModel=[self.imageArray objectAtIndex:indexPath.row-1];
        [imageView yy_setImageWithURL:[NSURL URLWithString:InternalPictureModel.url]placeholder:nil];
    }
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat length=([UIScreen mainScreen].bounds.size.width-10)/3;
    return CGSizeMake(length,length);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5,0, 0, 0);
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //设置选择后的图片可被编辑
        picker.allowsEditing = NO;
        picker.delegate=self;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        InternalPictureModel* InternalPictureModel=[self.imageArray objectAtIndex:indexPath.row-1];
        self.originPath=InternalPictureModel.url;
        [self.delegate onImageSelectFinished:self.originPath withOriginPath:self.originPath];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:true completion:nil];
    
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    self.originPath=[imageURL absoluteString];
    if(imageURL!=nil)
    {
        UIImage * image=[info objectForKey:UIImagePickerControllerOriginalImage];
        RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image];
        imageCropVC.delegate = self;
        imageCropVC.dataSource=self;
        imageCropVC.cropMode=self.cropMode;
        [self.navigationController pushViewController:imageCropVC animated:YES];
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

-(void)saveCroopedToSandBox:(UIImage*)croppedImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* filename=[NSString stringWithFormat:@"%@.jpg",[KSUtil getUUIDString]];
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:filename];   // 保存文件的名称
    BOOL result = [UIImagePNGRepresentation(croppedImage)writeToFile: filePath    atomically:YES];
    if(result)
    {
        NSLog(filePath,nil);
        [self.delegate onImageSelectFinished:[NSString stringWithFormat:@"%@%@",KS_SANDBOX,filename] withOriginPath:self.originPath];
        NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-1]animated:YES];
    }
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
